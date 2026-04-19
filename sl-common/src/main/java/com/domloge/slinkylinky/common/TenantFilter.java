package com.domloge.slinkylinky.common;

import java.util.Optional;
import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;

import jakarta.servlet.http.HttpServletRequest;

/**
 * Helper methods for enforcing tenant isolation in controllers.
 * All methods throw {@link ResponseStatusException} (403) rather than returning null
 * so callers can treat the result as non-null without defensive checks.
 */
public class TenantFilter {

    private TenantFilter() {}

    /**
     * Returns the effective organisation UUID for the current request.
     * For global_admin callers a valid X-Tenant-Override header is honoured;
     * for everyone else the org_id from the JWT is returned.
     *
     * @throws ResponseStatusException 403 if no org_id is available
     */
    public static UUID requireOrgId(HttpServletRequest request) {
        Optional<UUID> orgId = TenantContext.getEffectiveOrgId(request);
        return orgId.orElseThrow(() ->
            new ResponseStatusException(HttpStatus.FORBIDDEN, "No organisation ID in JWT"));
    }

    /**
     * Asserts that the current caller has the {@code global_admin} realm role.
     *
     * @throws ResponseStatusException 403 if the caller is not a global_admin
     */
    public static void requireGlobalAdmin() {
        if (!TenantContext.isGlobalAdmin()) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN,
                "This operation requires the global_admin role");
        }
    }
}
