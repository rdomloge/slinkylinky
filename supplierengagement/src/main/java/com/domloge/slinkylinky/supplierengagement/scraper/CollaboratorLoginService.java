package com.domloge.slinkylinky.supplierengagement.scraper;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.Duration;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.domloge.slinkylinky.supplierengagement.scraper.CollaboratorAuthSessionService.SessionSnapshot;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.microsoft.playwright.Browser;
import com.microsoft.playwright.BrowserContext;
import com.microsoft.playwright.BrowserType;
import com.microsoft.playwright.Locator;
import com.microsoft.playwright.Page;
import com.microsoft.playwright.Playwright;
import com.microsoft.playwright.PlaywrightException;
import com.microsoft.playwright.options.Cookie;
import com.microsoft.playwright.options.LoadState;

import lombok.extern.slf4j.Slf4j;

/**
 * Automates login to collaborator.pro using a headless Chromium browser.
 *
 * <p>Collaborator.pro is protected by Cloudflare Turnstile, which blocks plain
 * headless browsers. When {@code collaborator.flaresolverr.url} is configured,
 * this service first calls FlareSolverr to obtain a valid {@code cf_clearance}
 * cookie, then pre-seeds it into the Playwright browser context so the login page
 * loads without a challenge.
 *
 * <p>Collaborator.pro may require 2FA email verification after submitting credentials.
 * In that case {@link #login()} returns status {@code AWAITING_2FA} and holds the
 * browser session open. The caller must then invoke {@link #submitTwoFactorCode(String)}
 * with the code from the email to complete authentication.
 *
 * <p>On success the extracted cookies are validated by
 * {@link CollaboratorAuthSessionService#importCookies} (same path as manual import).
 */
@Service
@Slf4j
public class CollaboratorLoginService {

    private static final String LOGIN_URL = "https://collaborator.pro/login";
    private static final String USER_AGENT =
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 " +
            "(KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36";

    /** Patches the signals Cloudflare uses to distinguish headless from real Chrome. */
    private static final String STEALTH_SCRIPT = """
            Object.defineProperty(navigator, 'webdriver', { get: () => undefined });
            window.chrome = { runtime: {}, loadTimes: function(){}, csi: function(){}, app: {} };
            Object.defineProperty(navigator, 'plugins', {
                get: () => Array.from({length: 5}, (_, i) => ({
                    name: 'Plugin' + i, filename: 'plugin' + i + '.dll', description: '', length: 0
                }))
            });
            Object.defineProperty(navigator, 'languages', { get: () => ['en-US', 'en'] });
            Object.defineProperty(navigator, 'hardwareConcurrency', { get: () => 4 });
            """;

    @Value("${collaborator.browser.path:}")
    private String browserPath;

    /** Base URL of a running FlareSolverr instance, e.g. {@code http://localhost:8191}. Empty = disabled. */
    @Value("${collaborator.flaresolverr.url:}")
    private String flareSolverrUrl;

    @Autowired
    private CollaboratorAuthSessionService sessionService;

    private final ObjectMapper mapper = new ObjectMapper();

    // ── Pending 2FA state ─────────────────────────────────────────────────────
    // These hold the Playwright resources open between login() and submitTwoFactorCode().

    private volatile Playwright pending2faPlaywright;
    private volatile Browser pending2faBrowser;
    private volatile BrowserContext pending2faContext;
    private volatile Page pending2faPage;
    private volatile Instant pending2faExpiry;

    // ── Public API ────────────────────────────────────────────────────────────

    /**
     * Performs an automated headless login and returns a validated {@link SessionSnapshot}.
     *
     * <p>Possible statuses:
     * <ul>
     *   <li>{@code AUTHENTICATED} — login succeeded, session is ready
     *   <li>{@code AWAITING_2FA} — a verification code was sent by email; call
     *       {@link #submitTwoFactorCode(String)} to complete login
     *   <li>{@code FAILED} — login failed; errorMessage contains the reason
     * </ul>
     */
    public synchronized SessionSnapshot login(String username, String password) {
        if (!StringUtils.hasText(username) || !StringUtils.hasText(password)) {
            return fail("Collaborator credentials are required");
        }

        // Clean up any stale pending 2FA session
        cleanupPending2fa();

        log.info("Starting automated Collaborator.pro login (user={})", username);

        // Step 1 — obtain Cloudflare bypass cookies via FlareSolverr (if configured)
        List<Cookie> bypassCookies = List.of();
        String effectiveUserAgent = USER_AGENT;

        if (StringUtils.hasText(flareSolverrUrl)) {
            try {
                FlareSolverrResult bypass = callFlareSolverr();
                bypassCookies = bypass.playwrightCookies();
                if (StringUtils.hasText(bypass.userAgent())) {
                    effectiveUserAgent = bypass.userAgent();
                }
                log.info("FlareSolverr bypass succeeded — {} cookies obtained", bypassCookies.size());
            } catch (Exception e) {
                log.warn("FlareSolverr call failed: {} — will attempt plain headless login", e.getMessage());
            }
        } else {
            log.info("FlareSolverr not configured — attempting plain headless login");
        }

        // Step 2 — launch Playwright with bypass cookies pre-seeded
        // Note: cannot use try-with-resources here because we may need to hold the browser open for 2FA.
        Playwright playwright = null;
        try {
            playwright = Playwright.create();

            BrowserType.LaunchOptions launchOpts = new BrowserType.LaunchOptions()
                    .setHeadless(true)
                    .setArgs(List.of(
                            "--disable-blink-features=AutomationControlled",
                            "--no-sandbox",
                            "--disable-dev-shm-usage",
                            "--disable-gpu",
                            "--window-size=1920,1080",
                            "--lang=en-US,en"
                    ));

            if (StringUtils.hasText(browserPath)) {
                launchOpts.setExecutablePath(Paths.get(browserPath));
                log.info("Using system Chromium at {}", browserPath);
            }

            Browser browser = playwright.chromium().launch(launchOpts);

            Browser.NewContextOptions ctxOpts = new Browser.NewContextOptions()
                    .setUserAgent(effectiveUserAgent)
                    .setViewportSize(1920, 1080)
                    .setLocale("en-US")
                    .setTimezoneId("America/New_York")
                    .setIgnoreHTTPSErrors(true);

            BrowserContext context = browser.newContext(ctxOpts);
            context.addInitScript(STEALTH_SCRIPT);

            if (!bypassCookies.isEmpty()) {
                context.addCookies(bypassCookies);
                log.debug("Pre-seeded {} bypass cookies into browser context", bypassCookies.size());
            }

            Page page = context.newPage();
            page.setDefaultTimeout(30_000);

            SessionSnapshot result = performLogin(page, context, username, password);

            if ("AWAITING_2FA".equals(result.getStatus())) {
                // Hold resources open — submitTwoFactorCode() will close them
                pending2faPlaywright = playwright;
                pending2faBrowser = browser;
                pending2faContext = context;
                pending2faPage = page;
                pending2faExpiry = Instant.now().plusSeconds(300); // 5-minute window
                log.info("2FA required — browser held open for up to 5 minutes");
                return result;
            }

            // Close browser on any non-2FA outcome
            closeQuietly(playwright);
            return result;

        } catch (Exception e) {
            log.error("Automated Collaborator.pro login failed with exception", e);
            closeQuietly(playwright);
            return fail("Login failed: " + e.getClass().getSimpleName() + " — " + e.getMessage());
        }
    }

    /**
     * Completes a pending 2FA login by submitting the verification code from email.
     * Must be called after {@link #login(String, String)} returned {@code AWAITING_2FA}.
     *
     * @return {@code AUTHENTICATED} on success, {@code FAILED} on any error
     */
    public synchronized SessionSnapshot submitTwoFactorCode(String code) {
        if (pending2faPage == null) {
            return fail("No pending 2FA session. Please initiate login again.");
        }
        if (Instant.now().isAfter(pending2faExpiry)) {
            cleanupPending2fa();
            return fail("2FA session expired (5-minute window). Please initiate login again.");
        }

        Page page = pending2faPage;
        BrowserContext context = pending2faContext;

        try {
            log.info("Submitting 2FA code (url={})", page.url());
            dumpDiagnostics(page, page.url());

            Locator codeField = findField(page,
                    "input[name*='code']",
                    "input[name*='Code']",
                    "input[name*='otp']",
                    "input[name*='token']",
                    "input[name*='verify']",
                    "input[name*='pin']",
                    "input[type='number']",
                    "input[type='text']:not([name*='email']):not([name*='login']):not([name*='user'])");

            if (codeField == null) {
                dumpDiagnostics(page, page.url());
                cleanupPending2fa();
                return fail("Could not find verification code input field on page: " + page.url());
            }

            codeField.fill(code);
            log.debug("Filled verification code field");

            Locator submitBtn = findField(page,
                    "button[type='submit']",
                    "input[type='submit']",
                    "button:has-text('Verify')",
                    "button:has-text('Confirm')",
                    "button:has-text('Submit')",
                    "button:has-text('Continue')",
                    "button.btn-primary");
            if (submitBtn == null) {
                cleanupPending2fa();
                return fail("Could not find submit button on 2FA verification page");
            }
            submitBtn.click();
            log.debug("Clicked 2FA submit button");

            // Wait for redirect to a non-2FA, non-login page
            try {
                page.waitForURL(
                        url -> url.contains("collaborator.pro")
                                && !url.contains("/login")
                                && !isTwoFactorUrl(url),
                        new Page.WaitForURLOptions().setTimeout(15_000));
            } catch (PlaywrightException e) {
                String currentUrl = page.url();
                dumpDiagnostics(page, currentUrl);
                cleanupPending2fa();
                return fail("2FA verification did not complete — still on: " + currentUrl
                        + ". Check that the code is correct and has not expired.");
            }

            log.info("2FA login complete — url={}", page.url());

            String cookieHeader = context.cookies().stream()
                    .map(c -> c.name + "=" + c.value)
                    .collect(Collectors.joining("; "));
            log.debug("Extracted {} cookies after 2FA", context.cookies().size());

            cleanupPending2fa();

            SessionSnapshot snapshot = sessionService.importCookies(cookieHeader, "auto-login");
            log.info("Auto-login (2FA complete) result: status={}", snapshot.getStatus());
            return snapshot;

        } catch (Exception e) {
            log.error("2FA submission failed with exception", e);
            cleanupPending2fa();
            return fail("2FA submission failed: " + e.getClass().getSimpleName() + " — " + e.getMessage());
        }
    }

    // ── FlareSolverr ─────────────────────────────────────────────────────────

    /**
     * Calls FlareSolverr to retrieve a valid {@code cf_clearance} (and any other
     * Cloudflare cookies) for the Collaborator.pro login page.
     */
    private FlareSolverrResult callFlareSolverr() throws Exception {
        String apiUrl = flareSolverrUrl.replaceAll("/+$", "") + "/v1";
        String body = """
                {"cmd":"request.get","url":"https://collaborator.pro/login","maxTimeout":60000}
                """;

        log.info("Calling FlareSolverr at {}", apiUrl);

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(apiUrl))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(body))
                .timeout(Duration.ofSeconds(90))
                .build();

        HttpResponse<String> response = HttpClient.newHttpClient()
                .send(request, HttpResponse.BodyHandlers.ofString());

        JsonNode root = mapper.readTree(response.body());
        String status = root.path("status").asText();
        if (!"ok".equals(status)) {
            throw new RuntimeException("FlareSolverr returned status=" + status
                    + ": " + root.path("message").asText("(no message)"));
        }

        JsonNode solution = root.path("solution");
        String userAgent = solution.path("userAgent").asText(null);

        List<RawCookie> rawCookies = new ArrayList<>();
        for (JsonNode c : solution.path("cookies")) {
            rawCookies.add(new RawCookie(
                    c.path("name").asText(),
                    c.path("value").asText(),
                    c.path("domain").asText(".collaborator.pro"),
                    c.path("path").asText("/"),
                    c.path("secure").asBoolean(true),
                    c.path("httpOnly").asBoolean(false)
            ));
        }

        log.debug("FlareSolverr returned cookies: {}",
                rawCookies.stream().map(RawCookie::name).collect(Collectors.joining(", ")));
        return new FlareSolverrResult(rawCookies, userAgent);
    }

    // ── Login flow ────────────────────────────────────────────────────────────

    private SessionSnapshot performLogin(Page page, BrowserContext context, String username, String password) {
        log.debug("Navigating to {}", LOGIN_URL);
        try {
            page.navigate(LOGIN_URL);
        } catch (PlaywrightException e) {
            return fail("Could not reach login page: " + e.getMessage());
        }

        try {
            page.waitForLoadState(LoadState.NETWORKIDLE, new Page.WaitForLoadStateOptions().setTimeout(30_000));
        } catch (PlaywrightException e) {
            log.debug("NETWORKIDLE timeout, proceeding with DOMCONTENTLOADED content");
            try {
                page.waitForLoadState(LoadState.DOMCONTENTLOADED);
            } catch (PlaywrightException ignored) {}
        }

        String currentUrl = page.url();
        String pageTitle = page.title();
        log.debug("Login page loaded — url={}, title={}", currentUrl, pageTitle);

        // Cloudflare challenge still showing?
        if ("Just a moment...".equalsIgnoreCase(pageTitle) || currentUrl.contains("/cdn-cgi/")) {
            dumpDiagnostics(page, currentUrl);
            return fail("Cloudflare challenge not bypassed (title='" + pageTitle + "'). "
                    + "Ensure FlareSolverr is running and collaborator.flaresolverr.url is set correctly.");
        }

        // Fill email
        Locator emailField = findField(page,
                "input[type='email']",
                "input[name='LoginForm[email]']",
                "input[name*='email']",
                "input[name*='Email']",
                "input[name*='login']",
                "input[name*='username']",
                "input:not([type='hidden']):not([type='password']):not([type='submit']):not([type='checkbox'])");
        if (emailField == null) {
            dumpDiagnostics(page, currentUrl);
            return fail("Could not locate email/username field on login page (url=" + currentUrl + ")");
        }
        emailField.fill(username);
        log.debug("Filled email field");

        // Fill password
        Locator passwordField = findField(page,
                "input[type='password']",
                "input[name='LoginForm[password]']",
                "input[name*='password']");
        if (passwordField == null) {
            return fail("Could not locate password field on login page");
        }
        passwordField.fill(password);
        log.debug("Filled password field");

        // Submit
        Locator submitBtn = findField(page,
                "button[type='submit']",
                "input[type='submit']",
                "button.btn-primary",
                "button:has-text('Login')",
                "button:has-text('Sign in')",
                "button:has-text('Log in')");
        if (submitBtn == null) {
            return fail("Could not locate submit button on login page");
        }
        submitBtn.click();
        log.debug("Clicked submit");

        // Wait for the page to settle after form submission.
        // We cannot use waitForURL(not /login) because Collaborator.pro keeps the URL at /login
        // while showing the 2FA verification step — the URL only changes on the final redirect.
        try {
            page.waitForLoadState(LoadState.NETWORKIDLE, new Page.WaitForLoadStateOptions().setTimeout(15_000));
        } catch (PlaywrightException e) {
            log.debug("NETWORKIDLE timeout after submit — checking page state");
            try {
                page.waitForLoadState(LoadState.DOMCONTENTLOADED, new Page.WaitForLoadStateOptions().setTimeout(3_000));
            } catch (PlaywrightException ignored) {}
        }

        String postSubmitUrl = page.url();
        String postSubmitTitle = page.title();
        log.info("Post-submit page — url={}, title={}", postSubmitUrl, postSubmitTitle);

        // Check if we landed on a 2FA / email-verification page.
        // This may be the same /login URL with changed form content.
        if (isTwoFactorPage(page)) {
            log.info("2FA verification page detected at {}", postSubmitUrl);
            dumpDiagnostics(page, postSubmitUrl); // log field names to help selector tuning
            return new SessionSnapshot(null, "AWAITING_2FA",
                    "A verification code has been sent to your email. Enter it to complete login.", null);
        }

        // Still on the login page with no 2FA detected — wrong credentials or form error
        if (postSubmitUrl.contains("/login")) {
            String errorSnippet = "";
            try {
                Object err = page.evaluate(
                        "document.querySelector('.alert, .alert-danger, .field-error, [class*=\"error\"]')?.textContent?.trim()");
                if (err != null && !err.toString().isBlank()) {
                    errorSnippet = " — page says: " + err.toString().strip().substring(0, Math.min(200, err.toString().length()));
                }
            } catch (Exception ignored) {}
            dumpDiagnostics(page, postSubmitUrl);
            return fail("Login did not complete — still on login page" + errorSnippet
                    + ". Check credentials or look at the diagnostics screenshot.");
        }

        // Successfully redirected away from /login — normal success path
        log.info("Login redirect confirmed — url={}", postSubmitUrl);
        String cookieHeader = context.cookies().stream()
                .map(c -> c.name + "=" + c.value)
                .collect(Collectors.joining("; "));
        log.debug("Extracted {} cookies for import", context.cookies().size());

        SessionSnapshot snapshot = sessionService.importCookies(cookieHeader, "auto-login");
        log.info("Auto-login result: status={}", snapshot.getStatus());
        return snapshot;
    }

    // ── 2FA detection ─────────────────────────────────────────────────────────

    private boolean isTwoFactorPage(Page page) {
        String url = page.url().toLowerCase();
        String title = page.title().toLowerCase();

        if (isTwoFactorUrl(url)) return true;

        if (title.contains("verif") || title.contains("confirm") || title.contains("two-factor")
                || title.contains("otp") || title.contains("security code")) {
            return true;
        }

        // Content check: look for a single text/number input with code-like attributes
        try {
            Object hasCodeField = page.evaluate("""
                    (() => {
                        const inputs = Array.from(document.querySelectorAll('input[type="text"], input[type="number"]'));
                        return inputs.some(el => {
                            const attr = (el.name + ' ' + el.id + ' ' + (el.placeholder || '')).toLowerCase();
                            return attr.includes('code') || attr.includes('token') || attr.includes('otp')
                                || attr.includes('verify') || attr.includes('pin');
                        });
                    })()
                    """);
            if (Boolean.TRUE.equals(hasCodeField)) return true;
        } catch (Exception ignored) {}

        return false;
    }

    private boolean isTwoFactorUrl(String url) {
        String lower = url.toLowerCase();
        return lower.contains("/verify") || lower.contains("/2fa") || lower.contains("/mfa")
                || lower.contains("/otp") || lower.contains("/check") || lower.contains("/confirm")
                || lower.contains("/code") || lower.contains("/auth/");
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    /** Returns the first visible locator matching any of the given selectors, or {@code null}. */
    private Locator findField(Page page, String... selectors) {
        for (String selector : selectors) {
            try {
                Locator loc = page.locator(selector).first();
                if (loc.count() > 0 && loc.isVisible()) {
                    log.debug("Matched field selector: {}", selector);
                    return loc;
                }
            } catch (PlaywrightException ignored) {}
        }
        return null;
    }

    /** Logs input element HTML and saves a screenshot to temp for diagnosis. */
    private void dumpDiagnostics(Page page, String url) {
        try {
            log.warn("=== Collaborator login diagnostics (url={}) ===", url);
            log.warn("Page title: {}", page.title());
            Object inputs = page.evaluate("""
                    Array.from(document.querySelectorAll('input, select, textarea'))
                         .map(el => el.outerHTML.substring(0, 300))
                         .join('\\n')
                    """);
            log.warn("Form fields:\\n{}", inputs);
            Path screenshotPath = Paths.get(System.getProperty("java.io.tmpdir"), "collaborator-login-debug.png");
            page.screenshot(new Page.ScreenshotOptions().setPath(screenshotPath).setFullPage(true));
            log.warn("Screenshot saved to: {}", screenshotPath.toAbsolutePath());
        } catch (Exception e) {
            log.warn("Diagnostics dump failed: {}", e.getMessage());
        }
    }

    private synchronized void cleanupPending2fa() {
        if (pending2faPlaywright != null) {
            log.debug("Closing pending 2FA browser session");
            closeQuietly(pending2faPlaywright);
            pending2faPlaywright = null;
            pending2faBrowser = null;
            pending2faContext = null;
            pending2faPage = null;
            pending2faExpiry = null;
        }
    }

    /** Cleans up an expired 2FA session so the browser process does not leak. */
    @Scheduled(fixedDelay = 60_000)
    public void cleanupExpired2fa() {
        if (pending2faExpiry != null && Instant.now().isAfter(pending2faExpiry)) {
            log.info("2FA session timed out — closing browser");
            cleanupPending2fa();
        }
    }

    private static void closeQuietly(Playwright playwright) {
        if (playwright == null) return;
        try { playwright.close(); } catch (Exception ignored) {}
    }

    private static SessionSnapshot fail(String message) {
        log.warn("Auto-login failed: {}", message);
        return new SessionSnapshot(null, "FAILED", message, null);
    }

    // ── Data records ─────────────────────────────────────────────────────────

    private record RawCookie(String name, String value, String domain, String path,
                              boolean secure, boolean httpOnly) {}

    private record FlareSolverrResult(List<RawCookie> rawCookies, String userAgent) {
        List<Cookie> playwrightCookies() {
            return rawCookies.stream()
                    .map(c -> new Cookie(c.name(), c.value())
                            .setDomain(c.domain())
                            .setPath(c.path())
                            .setSecure(c.secure())
                            .setHttpOnly(c.httpOnly()))
                    .collect(Collectors.toList());
        }
    }
}
