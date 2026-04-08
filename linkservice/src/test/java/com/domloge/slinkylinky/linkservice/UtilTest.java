package com.domloge.slinkylinky.linkservice;

import static org.junit.jupiter.api.Assertions.assertEquals;

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
}
