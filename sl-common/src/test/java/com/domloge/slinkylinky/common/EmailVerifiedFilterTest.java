package com.domloge.slinkylinky.common;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.time.Instant;
import java.util.List;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.mock.web.MockFilterChain;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;

import jakarta.servlet.FilterChain;

class EmailVerifiedFilterTest {

    private static final List<String> EXEMPT = List.of("/actuator/**", "/public/**");
    private EmailVerifiedFilter filter;

    @BeforeEach
    void setUp() {
        filter = new EmailVerifiedFilter(EXEMPT);
    }

    @AfterEach
    void clear() {
        SecurityContextHolder.clearContext();
    }

    @Test
    void verifiedUser_passesThrough() throws Exception {
        setJwt(true);
        MockHttpServletRequest req = new MockHttpServletRequest("GET", "/api/data");
        MockHttpServletResponse resp = new MockHttpServletResponse();
        MockFilterChain chain = new MockFilterChain();

        filter.doFilter(req, resp, chain);

        assertEquals(200, resp.getStatus());
        // chain was invoked — request/response are set on the chain
    }

    @Test
    void unverifiedUser_receives403WithCode() throws Exception {
        setJwt(false);
        MockHttpServletRequest req = new MockHttpServletRequest("GET", "/api/data");
        MockHttpServletResponse resp = new MockHttpServletResponse();
        FilterChain chain = mock(FilterChain.class);

        filter.doFilter(req, resp, chain);

        assertEquals(403, resp.getStatus());
        assertEquals("application/json", resp.getContentType());
        org.junit.jupiter.api.Assertions.assertTrue(
            resp.getContentAsString().contains("EMAIL_NOT_VERIFIED"));
    }

    @Test
    void missingEmailVerifiedClaim_receives403() throws Exception {
        Jwt jwt = Jwt.withTokenValue("token")
            .header("alg", "none")
            .claim("preferred_username", "user@test.com")
            .issuedAt(Instant.now())
            .expiresAt(Instant.now().plusSeconds(3600))
            .build();
        SecurityContextHolder.getContext().setAuthentication(new JwtAuthenticationToken(jwt));

        MockHttpServletRequest req = new MockHttpServletRequest("GET", "/api/data");
        MockHttpServletResponse resp = new MockHttpServletResponse();
        FilterChain chain = mock(FilterChain.class);

        filter.doFilter(req, resp, chain);

        assertEquals(403, resp.getStatus());
    }

    @Test
    void whitelistedPath_passesThrough_regardlessOfVerification() throws Exception {
        setJwt(false);
        MockHttpServletRequest req = new MockHttpServletRequest("GET", "/actuator/health");
        MockHttpServletResponse resp = new MockHttpServletResponse();
        MockFilterChain chain = new MockFilterChain();

        filter.doFilter(req, resp, chain);

        assertEquals(200, resp.getStatus());
    }

    @Test
    void publicPath_passesThrough() throws Exception {
        setJwt(false);
        MockHttpServletRequest req = new MockHttpServletRequest("GET", "/public/signup");
        MockHttpServletResponse resp = new MockHttpServletResponse();
        MockFilterChain chain = new MockFilterChain();

        filter.doFilter(req, resp, chain);

        assertEquals(200, resp.getStatus());
    }

    @Test
    void serviceToken_withInternalServiceScope_passesThrough() throws Exception {
        // client_credentials tokens carry SCOPE_internal_service — the filter must let them through
        // regardless of email_verified, since they represent machines not human users
        Jwt jwt = Jwt.withTokenValue("token")
            .header("alg", "none")
            .claim("sub", "service-account-slinkylinky-internal")
            .claim("scope", "internal_service")
            .issuedAt(Instant.now())
            .expiresAt(Instant.now().plusSeconds(3600))
            .build();
        var authorities = List.of(new SimpleGrantedAuthority("SCOPE_internal_service"));
        SecurityContextHolder.getContext().setAuthentication(new JwtAuthenticationToken(jwt, authorities));

        MockHttpServletRequest req = new MockHttpServletRequest("GET", "/api/data");
        MockHttpServletResponse resp = new MockHttpServletResponse();
        MockFilterChain chain = new MockFilterChain();

        filter.doFilter(req, resp, chain);

        assertEquals(200, resp.getStatus());
    }

    @Test
    void unauthenticatedRequest_receives403() throws Exception {
        // Fail-closed: a non-exempt request without a verified JWT is blocked here.
        // Spring Security handles the 401 path for properly configured routes;
        // this defence-in-depth check ensures misconfigured routes also fail safely.
        SecurityContextHolder.clearContext();
        MockHttpServletRequest req = new MockHttpServletRequest("GET", "/api/data");
        MockHttpServletResponse resp = new MockHttpServletResponse();
        FilterChain chain = mock(FilterChain.class);

        filter.doFilter(req, resp, chain);

        assertEquals(403, resp.getStatus());
    }

    private static void setJwt(boolean emailVerified) {
        Jwt jwt = Jwt.withTokenValue("token")
            .header("alg", "none")
            .claim("preferred_username", "user@test.com")
            .claim("email_verified", emailVerified)
            .issuedAt(Instant.now())
            .expiresAt(Instant.now().plusSeconds(3600))
            .build();
        SecurityContextHolder.getContext().setAuthentication(new JwtAuthenticationToken(jwt));
    }
}
