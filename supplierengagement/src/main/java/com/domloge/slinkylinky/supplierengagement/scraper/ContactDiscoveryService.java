package com.domloge.slinkylinky.supplierengagement.scraper;

import java.security.SecureRandom;
import java.security.cert.X509Certificate;

import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.springframework.stereotype.Service;

import lombok.extern.slf4j.Slf4j;

/**
 * Discovers a contact email address for a given domain by scraping the
 * site's homepage and common contact pages using plain HTTP connections.
 * When this returns null, callers should fall back to {@link BrowserContactDiscoveryService}.
 */
@Service
@Slf4j
public class ContactDiscoveryService {

    private static final int TIMEOUT_MS = 8_000;

    private static final SSLSocketFactory TRUST_ALL_SSL = createTrustAllSslFactory();

    /**
     * Attempts to find a contact email for the given domain via plain HTTP.
     * Tries HTTPS then HTTP, and checks homepage plus common contact pages.
     *
     * @return the best contact email found, or {@code null} if none
     */
    public String discoverEmail(String domain) {
        for (String path : EmailExtractor.CONTACT_PATHS) {
            String email = tryUrl("https://" + domain + path, domain);
            if (email != null) return email;
        }
        // HTTP fallback for the homepage only
        String email = tryUrl("http://" + domain, domain);
        if (email != null) return email;

        log.debug("No contact email found via HTTP for {}", domain);
        return null;
    }

    private String tryUrl(String url, String domain) {
        try {
            Document doc = Jsoup.connect(url)
                    .timeout(TIMEOUT_MS)
                    .userAgent(EmailExtractor.USER_AGENT)
                    .header("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8")
                    .header("Accept-Language", "en-GB,en;q=0.9")
                    .followRedirects(true)
                    .sslSocketFactory(TRUST_ALL_SSL)
                    .get();
            return EmailExtractor.extractFromDocument(doc, domain, url);
        } catch (Exception e) {
            log.debug("Could not fetch {}: {}", url, e.getMessage());
        }
        return null;
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
