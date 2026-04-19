package com.domloge.slinkylinky.common;

import java.time.Instant;
import java.util.List;
import java.util.Map;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;

/**
 * Test helper for setting up a JWT-backed security context.
 * Intended for use in unit tests across services.
 */
public class TenantTestHelper {

    private TenantTestHelper() {}

    public static void setSecurityContext(String username, String orgId, List<String> roles) {
        Jwt jwt = Jwt.withTokenValue("test-token")
            .header("alg", "none")
            .claim("preferred_username", username)
            .claim("org_id", orgId)
            .claim("realm_access", Map.of("roles", roles))
            .issuedAt(Instant.now())
            .expiresAt(Instant.now().plusSeconds(3600))
            .build();
        SecurityContextHolder.getContext().setAuthentication(new JwtAuthenticationToken(jwt));
    }

    /** Sets up a JWT with no org_id claim — simulates a user whose token lacks tenant binding. */
    public static void setSecurityContextNoOrg(String username, List<String> roles) {
        Jwt jwt = Jwt.withTokenValue("test-token")
            .header("alg", "none")
            .claim("preferred_username", username)
            .claim("realm_access", Map.of("roles", roles))
            .issuedAt(Instant.now())
            .expiresAt(Instant.now().plusSeconds(3600))
            .build();
        SecurityContextHolder.getContext().setAuthentication(new JwtAuthenticationToken(jwt));
    }
}
