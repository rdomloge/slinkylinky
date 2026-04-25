package com.domloge.slinkylinky.userservice.rate;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import jakarta.servlet.http.HttpServletRequest;

class RateLimitFilterTest {

    private RateLimitFilter filter;

    @BeforeEach
    void setUp() {
        filter = new RateLimitFilter();
    }

    @Test
    void resolveClientIp_usesLastXForwardedForEntry() {
        HttpServletRequest req = mock(HttpServletRequest.class);
        when(req.getHeader("X-Forwarded-For")).thenReturn("10.0.0.1, 10.0.0.2, 1.2.3.4");
        assertEquals("1.2.3.4", filter.resolveClientIp(req));
    }

    @Test
    void resolveClientIp_fallsBackToRemoteAddr_whenNoHeader() {
        HttpServletRequest req = mock(HttpServletRequest.class);
        when(req.getHeader("X-Forwarded-For")).thenReturn(null);
        when(req.getRemoteAddr()).thenReturn("192.168.1.1");
        assertEquals("192.168.1.1", filter.resolveClientIp(req));
    }

    @Test
    void resolveClientIp_fallsBackToRemoteAddr_whenHeaderIsBlank() {
        HttpServletRequest req = mock(HttpServletRequest.class);
        when(req.getHeader("X-Forwarded-For")).thenReturn("  ");
        when(req.getRemoteAddr()).thenReturn("192.168.1.1");
        assertEquals("192.168.1.1", filter.resolveClientIp(req));
    }

    @Test
    void perIpLimit_triggersAfter5Requests() {
        HttpServletRequest req = mockRequest("10.0.0.1");
        for (int i = 0; i < 5; i++) {
            assertTrue(filter.tryAcquire(req, "unique-email-" + i + "@test.com"),
                "Request " + (i + 1) + " should be allowed");
        }
        // 6th request from the same IP should be blocked
        assertFalse(filter.tryAcquire(req, "another@test.com"), "6th request from same IP should be rate-limited");
    }

    @Test
    void perEmailLimit_triggersAfter5Requests() {
        String email = "repeated@test.com";
        for (int i = 0; i < 5; i++) {
            HttpServletRequest req = mockRequest("ip-" + i);
            assertTrue(filter.tryAcquire(req, email), "Request " + (i + 1) + " should be allowed");
        }
        HttpServletRequest req = mockRequest("ip-6");
        assertFalse(filter.tryAcquire(req, email), "6th request with same email should be rate-limited");
    }

    @Test
    void differentIps_haveIndependentBuckets() {
        // Fill up IP 1
        for (int i = 0; i < 5; i++) {
            filter.tryAcquire(mockRequest("1.1.1.1"), "e" + i + "@test.com");
        }
        // IP 2 should still be allowed
        assertTrue(filter.tryAcquire(mockRequest("2.2.2.2"), "fresh@test.com"),
            "Different IP should have its own bucket");
    }

    private HttpServletRequest mockRequest(String ip) {
        HttpServletRequest req = mock(HttpServletRequest.class);
        when(req.getHeader("X-Forwarded-For")).thenReturn(ip);
        when(req.getRemoteAddr()).thenReturn(ip);
        return req;
    }

    // Helper duplicated here to avoid coupling to prod code static method
    private void assertEquals(String expected, String actual) {
        org.junit.jupiter.api.Assertions.assertEquals(expected, actual);
    }
}
