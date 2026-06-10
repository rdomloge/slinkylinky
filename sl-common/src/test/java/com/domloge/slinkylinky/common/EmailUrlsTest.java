package com.domloge.slinkylinky.common;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

class EmailUrlsTest {

    @Test
    void prependsHttpsWhenNoSchemePresent() {
        // The bug that shipped a dead link: a scheme-less host renders as a relative href.
        assertEquals("https://www.slinkylinky.uk",
                EmailUrls.normaliseBaseUrl("www.slinkylinky.uk"));
    }

    @Test
    void leavesExistingHttpsSchemeUntouched() {
        assertEquals("https://www.slinkylinky.uk",
                EmailUrls.normaliseBaseUrl("https://www.slinkylinky.uk"));
    }

    @Test
    void leavesExistingHttpSchemeUntouched() {
        assertEquals("http://localhost:5173",
                EmailUrls.normaliseBaseUrl("http://localhost:5173"));
    }

    @Test
    void stripsTrailingSlashSoPathDoesNotDoubleUp() {
        assertEquals("https://www.slinkylinky.uk",
                EmailUrls.normaliseBaseUrl("https://www.slinkylinky.uk/"));
    }

    @Test
    void stripsMultipleTrailingSlashes() {
        assertEquals("https://www.slinkylinky.uk",
                EmailUrls.normaliseBaseUrl("www.slinkylinky.uk///"));
    }

    @Test
    void trimsSurroundingWhitespace() {
        assertEquals("https://www.slinkylinky.uk",
                EmailUrls.normaliseBaseUrl("  www.slinkylinky.uk  "));
    }

    @Test
    void schemeDetectionIsCaseInsensitive() {
        assertEquals("HTTPS://www.slinkylinky.uk",
                EmailUrls.normaliseBaseUrl("HTTPS://www.slinkylinky.uk"));
    }

    @Test
    void returnsEmptyStringForNull() {
        assertEquals("", EmailUrls.normaliseBaseUrl(null));
    }

    @Test
    void returnsEmptyStringForBlank() {
        assertEquals("", EmailUrls.normaliseBaseUrl("   "));
    }
}
