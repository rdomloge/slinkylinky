package com.domloge.slinkylinky.linkservice.controller;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.UUID;

import org.springframework.amqp.core.AmqpTemplate;
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

import com.domloge.slinkylinky.common.TenantContext;
import com.domloge.slinkylinky.common.TenantFilter;
import com.domloge.slinkylinky.events.AuditEvent;
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

    private static final Set<String> ASSIGNABLE_ROLES = Set.of("tenant_admin", "global_admin");

    @Autowired
    private KeycloakAdminClient keycloakAdminClient;

    @Autowired
    private AmqpTemplate auditRabbitTemplate;

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
     * tenant_admin for their own org only. Optionally assigns a realm role.
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

        String requestedRole = (String) userRepresentation.remove("role");
        validateRoleAssignment(requestedRole);

        String newUserId = keycloakAdminClient.createUser(userRepresentation);
        log.info("Created Keycloak user {} for org {}", newUserId, targetOrgId);

        if (requestedRole != null && !requestedRole.isBlank()) {
            try {
                Map<String, Object> roleRep = keycloakAdminClient.getRoleByName(requestedRole);
                keycloakAdminClient.assignRealmRole(newUserId, roleRep);
                log.info("Assigned role '{}' to user {}", requestedRole, newUserId);
            } catch (Exception e) {
                log.error("Role assignment failed for user {}, disabling orphan", newUserId, e);
                keycloakAdminClient.disableUser(newUserId);
                throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR,
                    "User created but role assignment failed; user has been disabled");
            }
        }

        AuditEvent ae = new AuditEvent();
        ae.setWho(TenantContext.getUsername());
        ae.setWhat("create user");
        ae.setEventTime(LocalDateTime.now());
        ae.setEntityType("User");
        ae.setEntityId(newUserId);
        ae.setDetail(newUserId);
        if (targetOrgId != null) {
            ae.setOrganisationId(UUID.fromString(targetOrgId));
        }
        auditRabbitTemplate.convertAndSend(ae);

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

        AuditEvent ae = new AuditEvent();
        ae.setWho(TenantContext.getUsername());
        ae.setWhat("disable user");
        ae.setEventTime(LocalDateTime.now());
        ae.setEntityType("User");
        ae.setEntityId(userId);
        ae.setDetail(userId);
        TenantContext.getOrganisationId()
            .map(UUID::fromString)
            .ifPresent(ae::setOrganisationId);
        auditRabbitTemplate.convertAndSend(ae);

        return ResponseEntity.noContent().build();
    }

    private void validateRoleAssignment(String role) {
        if (role == null || role.isBlank()) return;

        if (!ASSIGNABLE_ROLES.contains(role)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Unknown role: " + role);
        }

        if ("global_admin".equals(role) && !TenantContext.isGlobalAdmin()) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN,
                "Only a global_admin can assign the global_admin role");
        }
    }
}
