package com.domloge.slinkylinky.linkservice;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

import java.time.LocalDateTime;

import org.junit.jupiter.api.Test;

public class UtilTest {

    @Test
    void stripDomain_fullHttpsUrlWithWww_returnsRegistrableDomain() {
        assertEquals("example.com", Util.stripDomain("https://www.example.com"));
    }

    @Test
    void stripDomain_urlWithoutScheme_prefixesHttpsAndStrips() {
        // No scheme → code prepends "https://" before parsing
        assertEquals("example.com", Util.stripDomain("www.example.com"));
    }

    @Test
    void stripDomain_urlWithPathAndQuery_returnsJustDomain() {
        assertEquals("example.com", Util.stripDomain("https://www.example.com/some/path?q=1"));
    }

    @Test
    void stripDomain_multiPartTld_preservesFullPublicSuffix() {
        assertEquals("bbc.co.uk", Util.stripDomain("https://www.bbc.co.uk"));
    }

    @Test
    void stripDomain_subdomain_stripsToRegistrableDomain() {
        assertEquals("example.com", Util.stripDomain("https://blog.example.com"));
    }

    @Test
    void stripDomain_noWwwPrefix_returnsRegistrableDomain() {
        assertEquals("tesco.com", Util.stripDomain("http://tesco.com"));
    }

    @Test
    void stripDomain_localhostHasNoPublicSuffix_returnsHostAsIs() {
        // localhost has no public suffix; topPrivateDomain() throws IllegalStateException
        // which is caught and the bare host is returned unchanged
        assertEquals("localhost", Util.stripDomain("http://localhost:8080/app"));
    }

    @Test
    void parse_validDate_returnsStartOfDay() {
        assertEquals(LocalDateTime.of(2024, 3, 15, 0, 0), Util.parse("15/03/2024"));
    }

    @Test
    void parse_startOfMonth_returnsStartOfDay() {
        assertEquals(LocalDateTime.of(2024, 1, 1, 0, 0), Util.parse("01/01/2024"));
    }

    @Test
    void parse_endOfMonth_returnsStartOfDay() {
        assertEquals(LocalDateTime.of(2024, 1, 31, 0, 0), Util.parse("31/01/2024"));
    }

    @Test
    void parse_leapYearDate_returnsStartOfDay() {
        assertEquals(LocalDateTime.of(2024, 2, 29, 0, 0), Util.parse("29/02/2024"));
    }

    @Test
    void parse_invalidFormat_throwsDateTimeParseException() {
        assertThrows(Exception.class, () -> Util.parse("15-03-2024"));
    }

    @Test
    void parse_invalidDay_throwsDateTimeParseException() {
        assertThrows(Exception.class, () -> Util.parse("32/01/2024"));
    }
}
