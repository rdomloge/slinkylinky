package com.domloge.slinkylinky.supplierengagement.scraper;

import java.nio.file.Paths;
import java.util.List;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.springframework.stereotype.Service;

import com.microsoft.playwright.Browser;
import com.microsoft.playwright.BrowserContext;
import com.microsoft.playwright.BrowserType;
import com.microsoft.playwright.Page;
import com.microsoft.playwright.Playwright;
import com.microsoft.playwright.PlaywrightException;
import com.microsoft.playwright.options.LoadState;

import lombok.extern.slf4j.Slf4j;

/**
 * Discovers a contact email address using a headless Chromium browser via Playwright.
 * Handles JavaScript-rendered pages that plain HTTP scraping cannot reach.
 *
 * <p>Callers must first open a {@link PlaywrightSession} (which launches the browser)
 * and pass it to {@link #discoverEmail}. The session should be held for the lifetime
 * of a worker thread and closed when done.
 */
@Service
@Slf4j
public class BrowserContactDiscoveryService {

    private static final int PAGE_TIMEOUT_MS = 15_000;

    /**
     * Opens a new Playwright session (launches Chromium). The caller is responsible
     * for closing it via try-with-resources.
     */
    public PlaywrightSession openSession() {
        return new PlaywrightSession();
    }

    /**
     * Discovers a contact email for the given domain using the provided browser session.
     * Iterates the same contact paths as HTTP discovery, rendering each page fully.
     *
     * @return the best contact email found, or {@code null} if none
     */
    public String discoverEmail(String domain, PlaywrightSession session) {
        for (String path : EmailExtractor.CONTACT_PATHS) {
            String email = tryUrl("https://" + domain + path, domain, session);
            if (email != null) return email;
        }
        String email = tryUrl("http://" + domain, domain, session);
        if (email != null) return email;

        log.debug("No contact email found via browser for {}", domain);
        return null;
    }

    private String tryUrl(String url, String domain, PlaywrightSession session) {
        // Fresh context per URL for cookie isolation and clean state
        Browser.NewContextOptions ctxOpts = new Browser.NewContextOptions()
                .setUserAgent(EmailExtractor.USER_AGENT)
                .setIgnoreHTTPSErrors(true);

        try (BrowserContext context = session.browser.newContext(ctxOpts)) {
            Page page = context.newPage();
            page.setDefaultTimeout(PAGE_TIMEOUT_MS);

            try {
                page.navigate(url);
            } catch (PlaywrightException e) {
                log.debug("Browser could not navigate to {}: {}", url, e.getMessage());
                return null;
            }

            // Wait for JS to finish rendering; fall back to DOM-ready if networkidle times out
            try {
                page.waitForLoadState(LoadState.NETWORKIDLE);
            } catch (PlaywrightException e) {
                log.debug("networkidle timeout for {}, proceeding with domcontentloaded content", url);
                try {
                    page.waitForLoadState(LoadState.DOMCONTENTLOADED);
                } catch (PlaywrightException ignored) {
                    // use whatever content we have
                }
            }

            String html = page.content();
            Document doc = Jsoup.parse(html, url);
            return EmailExtractor.extractFromDocument(doc, domain, url);

        } catch (Exception e) {
            log.debug("Browser error for {}: {}", url, e.getMessage());
            return null;
        }
    }

    /**
     * Holds a Playwright instance and its launched Chromium browser.
     * Intended to be opened once per worker thread and held for its lifetime.
     */
    public static class PlaywrightSession implements AutoCloseable {

        final Playwright playwright;
        final Browser browser;

        PlaywrightSession() {
            this.playwright = Playwright.create();
            BrowserType.LaunchOptions opts = new BrowserType.LaunchOptions()
                    .setHeadless(true)
                    .setArgs(List.of("--no-sandbox", "--disable-dev-shm-usage", "--disable-gpu"));

            String execPath = System.getenv("PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH");
            if (execPath != null && !execPath.isBlank()) {
                opts.setExecutablePath(Paths.get(execPath));
                log.info("Playwright using system Chromium at {}", execPath);
            }

            this.browser = playwright.chromium().launch(opts);
            log.info("Playwright Chromium browser launched");
        }

        @Override
        public void close() {
            try { browser.close(); } catch (Exception ignored) {}
            try { playwright.close(); } catch (Exception ignored) {}
            log.info("Playwright Chromium browser closed");
        }
    }
}
