package com.domloge.slinkylinky.common;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;

import jakarta.servlet.http.HttpServletRequest;

/**
 * Utility for extracting tenant and user identity from the current request's JWT.
 *
 * All methods read from {@link SecurityContextHolder} — never from HTTP headers.
 * Use {@link #getEffectiveOrgId(HttpServletRequest)} for the organisation to use in queries:
 * it respects the X-Tenant-Override header for global_admin callers.
 */
public class TenantContext {

    public static final String TENANT_OVERRIDE_HEADER = "X-Tenant-Override";

    private static final String ORG_ID_CLAIM      = "org_id";
    private static final String USERNAME_CLAIM     = "preferred_username";
    private static final String REALM_ACCESS_CLAIM = "realm_access";
    private static final String ROLES_KEY          = "roles";
    private static final String GLOBAL_ADMIN_ROLE  = "global_admin";
    private static final String TENANT_ADMIN_ROLE  = "tenant_admin";

    private TenantContext() {}

    /** Returns the org_id claim from the JWT, if present. */
    public static Optional<String> getOrganisationId() {
        return getJwt().map(jwt -> jwt.getClaimAsString(ORG_ID_CLAIM));
    }

    /** Returns the preferred_username claim from the JWT, or "unknown" if not available. */
    public static String getUsername() {
        return getJwt()
            .map(jwt -> jwt.getClaimAsString(USERNAME_CLAIM))
            .orElse("unknown");
    }

    /** Returns true if the current caller has the global_admin realm role. */
    public static boolean isGlobalAdmin() {
        return hasRole(GLOBAL_ADMIN_ROLE);
    }

    /** Returns true if the current caller has the tenant_admin realm role. */
    public static boolean isTenantAdmin() {
        return hasRole(TENANT_ADMIN_ROLE);
    }

    /**
     * Resolves the effective organisation UUID for the current request.
     *
     * <ul>
     *   <li>global_admin with a valid {@code X-Tenant-Override} header → uses the override UUID</li>
     *   <li>Everyone else → returns the org_id from the JWT claim</li>
     * </ul>
     *
     * Returns empty if no org_id is available (e.g. anonymous/actuator requests).
     */
    public static Optional<UUID> getEffectiveOrgId(HttpServletRequest request) {
        if (isGlobalAdmin() && request != null) {
            String override = request.getHeader(TENANT_OVERRIDE_HEADER);
            if (override != null && !override.isBlank()) {
                try {
                    return Optional.of(UUID.fromString(override.trim()));
                } catch (IllegalArgumentException ignored) {
                    // Invalid UUID in override header — fall through to JWT org_id
                }
            }
        }
        return getOrganisationId().map(id -> {
            try {
                return UUID.fromString(id);
            } catch (IllegalArgumentException e) {
                return null;
            }
        });
    }

    // ── private helpers ─────────────────────────────────────────────────────

    private static boolean hasRole(String role) {
        return getJwt().map(jwt -> {
            Map<String, Object> realmAccess = jwt.getClaimAsMap(REALM_ACCESS_CLAIM);
            if (realmAccess == null) return false;
            Object roles = realmAccess.get(ROLES_KEY);
            return roles instanceof List<?> list && list.contains(role);
        }).orElse(false);
    }

    private static Optional<Jwt> getJwt() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth instanceof JwtAuthenticationToken jwtAuth) {
            return Optional.of(jwtAuth.getToken());
        }
        return Optional.empty();
    }
}
