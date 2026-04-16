package com.domloge.slinkylinky.supplierengagement.scraper;

import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.slf4j.Slf4j;

/**
 * Shared email extraction logic used by both HTTP-based and headless-browser-based
 * contact discovery. Operates on a pre-fetched Jsoup {@link Document}.
 */
@Slf4j
class EmailExtractor {

    private static final ObjectMapper MAPPER = new ObjectMapper();

    static final Pattern EMAIL_PATTERN = Pattern.compile(
            "[a-zA-Z0-9._%+\\-]+@[a-zA-Z0-9.\\-]+\\.[a-zA-Z]{2,}");

    static final Set<String> IGNORED_PREFIXES = Set.of("noreply", "no-reply");

    static final List<String> PREFERRED_PREFIXES = List.of(
            "info", "contact", "hello", "enquiries", "enquiry",
            "inquiries", "inquiry", "office", "admin", "general",
            "mail", "support", "editorial", "press", "editor");

    static final List<String> CONTACT_PATHS = List.of(
            "", "/contact", "/contact-us", "/about", "/about-us", "/get-in-touch", "/contacts");

    static final String USER_AGENT =
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 " +
            "(KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36";

    private EmailExtractor() {}

    /**
     * Extracts the best contact email from a fully-parsed HTML document.
     *
     * @param doc    Jsoup document (may be from HTTP or headless browser)
     * @param domain the site's domain (used for domain-match scoring)
     * @param url    the URL that was fetched (used only for log messages)
     * @return the best email found, or {@code null}
     */
    static String extractFromDocument(Document doc, String domain, String url) {
        Set<String> candidates = new LinkedHashSet<>();

        // Priority 1: mailto: href attributes
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
    }

    private static String selectBest(Set<String> candidates, String domain, String url) {
        String normDomain = domain.toLowerCase().replaceFirst("^www\\.", "");

        List<String> domainMatches = candidates.stream()
                .filter(e -> {
                    String emailDomain = e.substring(e.indexOf('@') + 1).replaceFirst("^www\\.", "");
                    return emailDomain.equals(normDomain);
                })
                .toList();

        if (domainMatches.isEmpty()) {
            // Single non-Gmail candidate on any page, or single candidate on a non-root page: use it
            if (candidates.size() == 1) {
                String only = candidates.iterator().next();
                if (!only.endsWith("@gmail.com") || !isRootPage(url)) {
                    log.debug("No @{} email at {}; using only candidate: {}", domain, url, only);
                    return only;
                }
            }
            // On contact/about pages, a Gmail address is plausible for small sites
            if (!isRootPage(url)) {
                List<String> gmailCandidates = candidates.stream()
                        .filter(e -> e.endsWith("@gmail.com"))
                        .toList();
                if (gmailCandidates.size() == 1) {
                    log.debug("No @{} email at {}; using Gmail address on non-root page: {}", domain, url, gmailCandidates.get(0));
                    return gmailCandidates.get(0);
                }
                if (gmailCandidates.size() > 1) {
                    log.info("Found {} Gmail addresses at {} but cannot disambiguate — candidates: {}",
                            gmailCandidates.size(), url, gmailCandidates);
                }
            }
            log.info("Found {} emails at {} but none match domain {} — candidates: {}",
                    candidates.size(), url, domain, candidates);
            return null;
        }

        if (domainMatches.size() == 1) {
            log.debug("Single @{} email at {}: {}", domain, url, domainMatches.get(0));
            return domainMatches.get(0);
        }

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

    private static String decodeCfEmail(String hex) {
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

    private static void collectJsonLdEmails(Document doc, Set<String> candidates) {
        for (Element script : doc.select("script[type=application/ld+json]")) {
            try {
                JsonNode root = MAPPER.readTree(script.html());
                collectJsonLdEmails(root, candidates);
            } catch (Exception e) {
                log.debug("Could not parse JSON-LD: {}", e.getMessage());
            }
        }
    }

    private static void collectJsonLdEmails(JsonNode node, Set<String> candidates) {
        if (node == null) return;
        if (node.has("email")) {
            JsonNode emailNode = node.get("email");
            String email = emailNode.isTextual() ? emailNode.asText() : null;
            if (email != null && isPlausible(email)) candidates.add(email.toLowerCase());
        }
        if (node.isArray()) {
            for (JsonNode item : node) collectJsonLdEmails(item, candidates);
        } else if (node.isObject()) {
            for (JsonNode child : node) collectJsonLdEmails(child, candidates);
        }
    }

    private static boolean isRootPage(String url) {
        try {
            String path = new java.net.URI(url).getPath();
            return path == null || path.isEmpty() || path.equals("/");
        } catch (Exception e) {
            return false;
        }
    }

    static boolean isPlausible(String email) {
        if (email == null || !email.contains("@")) return false;
        String local = email.substring(0, email.indexOf('@')).toLowerCase();
        if (IGNORED_PREFIXES.contains(local)) return false;
        String lower = email.toLowerCase();
        return !lower.contains("example.com")
                && !lower.contains("domain.com")
                && !lower.contains("yourdomain")
                && !lower.equals("[email\u00a0protected]")
                && !lower.contains("email-protection");
    }
}
