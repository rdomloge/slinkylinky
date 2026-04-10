package com.domloge.slinkylinky.supplierengagement.scraper;

import java.security.SecureRandom;
import java.security.cert.X509Certificate;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.slf4j.Slf4j;

/**
 * Discovers a contact email address for a given domain by scraping the
 * site's homepage and common contact pages.
 */
@Service
@Slf4j
public class ContactDiscoveryService {

    private static final ObjectMapper MAPPER = new ObjectMapper();

    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "[a-zA-Z0-9._%+\\-]+@[a-zA-Z0-9.\\-]+\\.[a-zA-Z]{2,}");

    private static final Set<String> IGNORED_PREFIXES = Set.of(
            "noreply", "no-reply");

    /** Generic contact prefixes, in priority order. */
    private static final List<String> PREFERRED_PREFIXES = List.of(
            "info", "contact", "hello", "enquiries", "enquiry",
            "inquiries", "inquiry", "office", "admin", "general",
            "mail", "support", "editorial", "press", "editor");

    private static final List<String> CONTACT_PATHS = List.of(
            "", "/contact", "/contact-us", "/about", "/about-us", "/get-in-touch", "/contacts");

    private static final String USER_AGENT =
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 " +
            "(KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36";

    private static final int TIMEOUT_MS = 8_000;

    private static final SSLSocketFactory TRUST_ALL_SSL = createTrustAllSslFactory();

    /**
     * Attempts to find a contact email for the given domain.
     * Tries HTTPS then HTTP, and checks homepage plus common contact pages.
     * When a page has multiple emails, selects the one with a preferred generic
     * prefix (info@, contact@, etc.) that matches the site's domain.
     *
     * @return the best contact email found, or {@code null} if none
     */
    public String discoverEmail(String domain) {
        for (String path : CONTACT_PATHS) {
            String email = tryUrl("https://" + domain + path, domain);
            if (email != null) return email;
        }
        // HTTP fallback for the homepage only
        String email = tryUrl("http://" + domain, domain);
        if (email != null) return email;

        log.debug("No contact email found for {}", domain);
        return null;
    }

    private String tryUrl(String url, String domain) {
        try {
            Document doc = Jsoup.connect(url)
                    .timeout(TIMEOUT_MS)
                    .userAgent(USER_AGENT)
                    .header("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8")
                    .header("Accept-Language", "en-GB,en;q=0.9")
                    .followRedirects(true)
                    .sslSocketFactory(TRUST_ALL_SSL)
                    .get();

            // Collect all plausible email candidates (LinkedHashSet preserves discovery order, deduplicates)
            Set<String> candidates = new LinkedHashSet<>();

            // Priority 1: mailto: href values (case-insensitive)
            for (Element a : doc.select("a[href]")) {
                String href = a.attr("href");
                if (href.toLowerCase().startsWith("mailto:")) {
                    String candidate = href.replaceFirst("(?i)^mailto:", "").split("\\?")[0].trim();
                    if (isPlausible(candidate)) candidates.add(candidate.toLowerCase());
                }
            }

            // Priority 1b: JSON-LD structured data (Schema.org)
            collectJsonLdEmails(doc, candidates);

            // Priority 1c: Cloudflare email obfuscation (data-cfemail attribute)
            // CF puts data-cfemail on <span class="__cf_email__">, not on the <a>
            for (Element el : doc.select("[data-cfemail]")) {
                String candidate = decodeCfEmail(el.attr("data-cfemail"));
                if (isPlausible(candidate)) candidates.add(candidate.toLowerCase());
            }

            // Priority 2: email addresses in page text
            String text = doc.body() != null ? doc.body().text() : "";
            Matcher m = EMAIL_PATTERN.matcher(text);
            while (m.find()) {
                String candidate = m.group();
                if (isPlausible(candidate)) candidates.add(candidate.toLowerCase());
            }

            if (candidates.isEmpty()) return null;

            return selectBest(candidates, domain, url);

        } catch (Exception e) {
            log.debug("Could not fetch {}: {}", url, e.getMessage());
        }
        return null;
    }

    /**
     * From a set of candidate emails, select the best contact address:
     * 1. Filter to emails whose domain matches the site domain
     * 2. Of those, keep only ones with a preferred prefix (info, contact, etc.)
     * 3. If exactly one preferred match → return it
     * 4. If multiple preferred matches → return the highest-priority prefix
     * 5. If no preferred matches but domain matches exist → log and return null
     * 6. If no domain matches → log and return null
     */
    private String selectBest(Set<String> candidates, String domain, String url) {
        // Normalise domain for comparison (strip www.)
        String normDomain = domain.toLowerCase().replaceFirst("^www\\.", "");

        // Filter to emails at this domain
        List<String> domainMatches = candidates.stream()
                .filter(e -> {
                    String emailDomain = e.substring(e.indexOf('@') + 1).replaceFirst("^www\\.", "");
                    return emailDomain.equals(normDomain);
                })
                .toList();

        if (domainMatches.isEmpty()) {
            // No emails at this domain — only found third-party addresses
            if (candidates.size() == 1) {
                String only = candidates.iterator().next();
                log.debug("No @{} email at {}; using only candidate: {}", domain, url, only);
                return only;
            }
            log.info("Found {} emails at {} but none match domain {} — candidates: {}",
                    candidates.size(), url, domain, candidates);
            return null;
        }

        if (domainMatches.size() == 1) {
            log.debug("Single @{} email at {}: {}", domain, url, domainMatches.get(0));
            return domainMatches.get(0);
        }

        // Multiple emails at this domain — pick by preferred prefix
        for (String prefix : PREFERRED_PREFIXES) {
            List<String> prefixMatches = domainMatches.stream()
                    .filter(e -> e.substring(0, e.indexOf('@')).equals(prefix))
                    .toList();
            if (prefixMatches.size() == 1) {
                log.debug("Selected {}@ from {} candidates at {}", prefix, domainMatches.size(), url);
                return prefixMatches.get(0);
            }
        }

        log.info("Found {} @{} emails at {} but none have a preferred prefix — candidates: {}",
                domainMatches.size(), domain, url, domainMatches);
        return null;
    }

    private String decodeCfEmail(String hex) {
        try {
            int key = Integer.parseInt(hex.substring(0, 2), 16);
            StringBuilder sb = new StringBuilder();
            for (int i = 2; i + 1 < hex.length(); i += 2) {
                sb.append((char) (Integer.parseInt(hex.substring(i, i + 2), 16) ^ key));
            }
            return sb.toString();
        } catch (NumberFormatException e) {
            return "";
        }
    }

    private void collectJsonLdEmails(Document doc, Set<String> candidates) {
        for (Element script : doc.select("script[type=application/ld+json]")) {
            try {
                JsonNode root = MAPPER.readTree(script.html());
                collectJsonLdEmails(root, candidates);
            } catch (Exception e) {
                log.debug("Could not parse JSON-LD: {}", e.getMessage());
            }
        }
    }

    private void collectJsonLdEmails(JsonNode node, Set<String> candidates) {
        if (node == null) return;

        if (node.has("email")) {
            JsonNode emailNode = node.get("email");
            String email = emailNode.isTextual() ? emailNode.asText() : null;
            if (email != null && isPlausible(email)) {
                candidates.add(email.toLowerCase());
            }
        }

        // Recursively search child nodes (for @graph arrays and nested objects)
        if (node.isArray()) {
            for (JsonNode item : node) {
                collectJsonLdEmails(item, candidates);
            }
        } else if (node.isObject()) {
            for (JsonNode child : node) {
                collectJsonLdEmails(child, candidates);
            }
        }
    }

    private boolean isPlausible(String email) {
        if (email == null || !email.contains("@")) return false;
        String local = email.substring(0, email.indexOf('@')).toLowerCase();
        if (IGNORED_PREFIXES.contains(local)) return false;
        // Filter obvious example/placeholder addresses and CF obfuscation placeholders
        String lower = email.toLowerCase();
        return !lower.contains("example.com")
                && !lower.contains("domain.com")
                && !lower.contains("yourdomain")
                && !lower.equals("[email\u00a0protected]")
                && !lower.contains("email-protection");
    }

    private static SSLSocketFactory createTrustAllSslFactory() {
        try {
            TrustManager[] trustAll = { new X509TrustManager() {
                public X509Certificate[] getAcceptedIssuers() { return new X509Certificate[0]; }
                public void checkClientTrusted(X509Certificate[] certs, String authType) { }
                public void checkServerTrusted(X509Certificate[] certs, String authType) { }
            }};
            SSLContext ctx = SSLContext.getInstance("TLS");
            ctx.init(null, trustAll, new SecureRandom());
            return ctx.getSocketFactory();
        } catch (Exception e) {
            throw new RuntimeException("Failed to create trust-all SSL factory", e);
        }
    }
}
