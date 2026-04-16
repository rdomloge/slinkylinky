package com.domloge.slinkylinky.linkservice.controller;

import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import com.domloge.slinkylinky.linkservice.config.TenantContext;
import com.domloge.slinkylinky.linkservice.config.TenantFilter;
import com.domloge.slinkylinky.linkservice.keycloak.KeycloakAdminClient;

import lombok.extern.slf4j.Slf4j;

/**
 * Proxies Keycloak Admin REST API for per-tenant user management.
 * Requires KEYCLOAK_ADMIN_URL / KEYCLOAK_ADMIN_CLIENT_ID / KEYCLOAK_ADMIN_CLIENT_SECRET env vars.
 */
@Slf4j
@RestController
@RequestMapping("/.rest/keycloak/users")
public class KeycloakUserController {

    @Autowired
    private KeycloakAdminClient keycloakAdminClient;

    private void checkConfigured() {
        if (!keycloakAdminClient.isConfigured()) {
            throw new ResponseStatusException(HttpStatus.SERVICE_UNAVAILABLE,
                "Keycloak Admin API is not configured on this instance");
        }
    }

    /**
     * List users for a given org. global_admin can query any org; tenant_admin
     * can only query their own.
     */
    @GetMapping
    public ResponseEntity<List<Map<String, Object>>> listUsers(@RequestParam String orgId) {
        checkConfigured();

        if (!TenantContext.isGlobalAdmin()) {
            if (!TenantContext.isTenantAdmin()) {
                throw new ResponseStatusException(HttpStatus.FORBIDDEN);
            }
            String callerOrgId = TenantContext.getOrganisationId().orElse(null);
            if (!orgId.equals(callerOrgId)) {
                throw new ResponseStatusException(HttpStatus.FORBIDDEN);
            }
        }

        List<Map<String, Object>> users = keycloakAdminClient.listUsersByOrgId(orgId);
        return ResponseEntity.ok(users);
    }

    /**
     * Create a user in Keycloak for a given org. global_admin can create for any org;
     * tenant_admin for their own org only.
     */
    @PostMapping
    public ResponseEntity<Void> createUser(@RequestBody Map<String, Object> userRepresentation) {
        checkConfigured();

        @SuppressWarnings("unchecked")
        Map<String, List<String>> attrs = (Map<String, List<String>>) userRepresentation.get("attributes");
        List<String> orgIdAttr = attrs != null ? attrs.get("org_id") : null;
        String targetOrgId = (orgIdAttr != null && !orgIdAttr.isEmpty()) ? orgIdAttr.get(0) : null;

        if (!TenantContext.isGlobalAdmin()) {
            if (!TenantContext.isTenantAdmin()) {
                throw new ResponseStatusException(HttpStatus.FORBIDDEN);
            }
            String callerOrgId = TenantContext.getOrganisationId().orElse(null);
            if (!Objects.equals(callerOrgId, targetOrgId)) {
                throw new ResponseStatusException(HttpStatus.FORBIDDEN);
            }
        }

        keycloakAdminClient.createUser(userRepresentation);
        log.info("Created Keycloak user for org {}", targetOrgId);
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }

    /**
     * Disable a Keycloak user. global_admin only (user management across orgs
     * is a root operation to avoid accidental cross-tenant impact).
     */
    @DeleteMapping("/{userId}")
    public ResponseEntity<Void> disableUser(@PathVariable String userId) {
        checkConfigured();
        TenantFilter.requireGlobalAdmin();
        keycloakAdminClient.disableUser(userId);
        log.info("Disabled Keycloak user {}", userId);
        return ResponseEntity.noContent().build();
    }
}
