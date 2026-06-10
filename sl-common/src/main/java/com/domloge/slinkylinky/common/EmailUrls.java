package com.domloge.slinkylinky.common;

/**
 * Helpers for building absolute URLs embedded in outbound emails.
 */
public final class EmailUrls {

    private EmailUrls() {
    }

    /**
     * Ensures a configured base URL is absolute (has a scheme) and has no trailing slash.
     *
     * <p>A scheme-less href such as {@code "www.slinkylinky.uk/..."} is treated as a relative
     * link by mail clients, which resolve it against their own internal base (Gmail/Apple Mail
     * render it as {@code "x-msg://..."}), producing a dead link. When no scheme is present we
     * default to {@code https}.
     *
     * @param domain the configured base URL/host (may be {@code null} or blank)
     * @return an absolute, trailing-slash-free base URL, or {@code ""} if {@code domain} is blank
     */
    public static String normaliseBaseUrl(String domain) {
        if (domain == null || domain.isBlank()) {
            return "";
        }
        String trimmed = domain.strip();
        if (!trimmed.matches("(?i)^[a-z][a-z0-9+.-]*://.*")) {
            trimmed = "https://" + trimmed;
        }
        while (trimmed.endsWith("/")) {
            trimmed = trimmed.substring(0, trimmed.length() - 1);
        }
        return trimmed;
    }
}
