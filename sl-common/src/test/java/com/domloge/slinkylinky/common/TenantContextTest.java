package com.domloge.slinkylinky.common;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;

/**
 * Unit tests for TenantContext — verifies JWT claim extraction and tenant override logic.
 * No Spring Boot context needed; uses SecurityContextHolder directly.
 */
public class TenantContextTest {

    private static final String TEST_ORG_ID = "00000000-0000-0000-0000-000000000001";
    private static final String TEST_USERNAME = "testuser@example.com";

    @AfterEach
    void clearSecurityContext() {
        SecurityContextHolder.clearContext();
    }

    // ── getUsername ──────────────────────────────────────────────────────────

    @Test
    void getUsername_jwtPresent_returnsPreferredUsername() {
        setSecurityContext(TEST_USERNAME, TEST_ORG_ID, List.of());

        assertEquals(TEST_USERNAME, TenantContext.getUsername());
    }

    @Test
    void getUsername_noAuthentication_returnsUnknown() {
        SecurityContextHolder.clearContext();

        assertEquals("unknown", TenantContext.getUsername());
    }

    // ── getOrganisationId ────────────────────────────────────────────────────

    @Test
    void getOrganisationId_jwtWithOrgId_returnsOrgId() {
        setSecurityContext(TEST_USERNAME, TEST_ORG_ID, List.of());

        Optional<String> orgId = TenantContext.getOrganisationId();
        assertTrue(orgId.isPresent());
        assertEquals(TEST_ORG_ID, orgId.get());
    }

    @Test
    void getOrganisationId_jwtWithoutOrgId_returnsEmpty() {
        Jwt jwt = Jwt.withTokenValue("test")
            .header("alg", "none")
            .claim("preferred_username", TEST_USERNAME)
            .issuedAt(Instant.now())
            .expiresAt(Instant.now().plusSeconds(3600))
            .build();
        SecurityContextHolder.getContext().setAuthentication(new JwtAuthenticationToken(jwt));

        assertTrue(TenantContext.getOrganisationId().isEmpty());
    }

    // ── isGlobalAdmin ────────────────────────────────────────────────────────

    @Test
    void isGlobalAdmin_jwtWithGlobalAdminRole_returnsTrue() {
        setSecurityContext(TEST_USERNAME, TEST_ORG_ID, List.of("global_admin"));

        assertTrue(TenantContext.isGlobalAdmin());
    }

    @Test
    void isGlobalAdmin_jwtWithoutGlobalAdminRole_returnsFalse() {
        setSecurityContext(TEST_USERNAME, TEST_ORG_ID, List.of("tenant_admin"));

        assertFalse(TenantContext.isGlobalAdmin());
    }

    @Test
    void isGlobalAdmin_noAuthentication_returnsFalse() {
        SecurityContextHolder.clearContext();

        assertFalse(TenantContext.isGlobalAdmin());
    }

    // ── isTenantAdmin ────────────────────────────────────────────────────────

    @Test
    void isTenantAdmin_jwtWithTenantAdminRole_returnsTrue() {
        setSecurityContext(TEST_USERNAME, TEST_ORG_ID, List.of("tenant_admin"));

        assertTrue(TenantContext.isTenantAdmin());
    }

    @Test
    void isTenantAdmin_jwtWithGlobalAdminOnly_returnsFalse() {
        setSecurityContext(TEST_USERNAME, TEST_ORG_ID, List.of("global_admin"));

        assertFalse(TenantContext.isTenantAdmin());
    }

    // ── getEffectiveOrgId ────────────────────────────────────────────────────

    @Test
    void getEffectiveOrgId_regularUser_returnsJwtOrgId() {
        setSecurityContext(TEST_USERNAME, TEST_ORG_ID, List.of("tenant_admin"));
        MockHttpServletRequest request = new MockHttpServletRequest();

        Optional<UUID> orgId = TenantContext.getEffectiveOrgId(request);

        assertTrue(orgId.isPresent());
        assertEquals(UUID.fromString(TEST_ORG_ID), orgId.get());
    }

    @Test
    void getEffectiveOrgId_globalAdminWithOverrideHeader_returnsOverride() {
        String overrideOrgId = "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee";
        setSecurityContext(TEST_USERNAME, TEST_ORG_ID, List.of("global_admin"));
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.addHeader(TenantContext.TENANT_OVERRIDE_HEADER, overrideOrgId);

        Optional<UUID> orgId = TenantContext.getEffectiveOrgId(request);

        assertTrue(orgId.isPresent());
        assertEquals(UUID.fromString(overrideOrgId), orgId.get());
    }

    @Test
    void getEffectiveOrgId_regularUserWithOverrideHeader_ignoresOverrideReturnsJwtOrgId() {
        String overrideOrgId = "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee";
        setSecurityContext(TEST_USERNAME, TEST_ORG_ID, List.of("tenant_admin"));
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.addHeader(TenantContext.TENANT_OVERRIDE_HEADER, overrideOrgId);

        Optional<UUID> orgId = TenantContext.getEffectiveOrgId(request);

        assertTrue(orgId.isPresent());
        assertEquals(UUID.fromString(TEST_ORG_ID), orgId.get(), "Non-global_admin must not use override");
    }

    @Test
    void getEffectiveOrgId_globalAdminWithInvalidOverrideUuid_fallsBackToJwtOrgId() {
        setSecurityContext(TEST_USERNAME, TEST_ORG_ID, List.of("global_admin"));
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.addHeader(TenantContext.TENANT_OVERRIDE_HEADER, "not-a-valid-uuid");

        Optional<UUID> orgId = TenantContext.getEffectiveOrgId(request);

        assertTrue(orgId.isPresent());
        assertEquals(UUID.fromString(TEST_ORG_ID), orgId.get(), "Invalid override UUID must fall back to JWT org_id");
    }

    @Test
    void getEffectiveOrgId_globalAdminNoOverrideHeader_returnsJwtOrgId() {
        setSecurityContext(TEST_USERNAME, TEST_ORG_ID, List.of("global_admin"));
        MockHttpServletRequest request = new MockHttpServletRequest();

        Optional<UUID> orgId = TenantContext.getEffectiveOrgId(request);

        assertTrue(orgId.isPresent());
        assertEquals(UUID.fromString(TEST_ORG_ID), orgId.get());
    }

    // ── TenantFilter ─────────────────────────────────────────────────────────

    @Test
    void requireOrgId_userWithOrgId_returnsOrgId() {
        setSecurityContext(TEST_USERNAME, TEST_ORG_ID, List.of());
        MockHttpServletRequest request = new MockHttpServletRequest();

        UUID orgId = TenantFilter.requireOrgId(request);

        assertEquals(UUID.fromString(TEST_ORG_ID), orgId);
    }

    @Test
    void requireOrgId_noOrgId_throws403() {
        Jwt jwt = Jwt.withTokenValue("test")
            .header("alg", "none")
            .claim("preferred_username", TEST_USERNAME)
            .issuedAt(Instant.now())
            .expiresAt(Instant.now().plusSeconds(3600))
            .build();
        SecurityContextHolder.getContext().setAuthentication(new JwtAuthenticationToken(jwt));
        MockHttpServletRequest request = new MockHttpServletRequest();

        org.springframework.web.server.ResponseStatusException ex =
            org.junit.jupiter.api.Assertions.assertThrows(
                org.springframework.web.server.ResponseStatusException.class,
                () -> TenantFilter.requireOrgId(request)
            );
        assertEquals(org.springframework.http.HttpStatus.FORBIDDEN, ex.getStatusCode());
    }

    @Test
    void requireGlobalAdmin_globalAdmin_doesNotThrow() {
        setSecurityContext(TEST_USERNAME, TEST_ORG_ID, List.of("global_admin"));

        org.junit.jupiter.api.Assertions.assertDoesNotThrow(TenantFilter::requireGlobalAdmin);
    }

    @Test
    void requireGlobalAdmin_regularUser_throws403() {
        setSecurityContext(TEST_USERNAME, TEST_ORG_ID, List.of("tenant_admin"));

        org.springframework.web.server.ResponseStatusException ex =
            org.junit.jupiter.api.Assertions.assertThrows(
                org.springframework.web.server.ResponseStatusException.class,
                TenantFilter::requireGlobalAdmin
            );
        assertEquals(org.springframework.http.HttpStatus.FORBIDDEN, ex.getStatusCode());
    }

    // ── helper ───────────────────────────────────────────────────────────────

    private static void setSecurityContext(String username, String orgId, List<String> roles) {
        TenantTestHelper.setSecurityContext(username, orgId, roles);
    }
}
