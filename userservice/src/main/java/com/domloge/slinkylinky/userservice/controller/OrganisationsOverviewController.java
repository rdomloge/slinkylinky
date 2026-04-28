package com.domloge.slinkylinky.userservice.controller;

import java.time.Instant;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import com.domloge.slinkylinky.common.TenantContext;
import com.domloge.slinkylinky.common.TenantFilter;
import com.domloge.slinkylinky.events.AuditEvent;
import com.domloge.slinkylinky.userservice.dto.OrgOverviewDto;
import com.domloge.slinkylinky.userservice.dto.UserOverviewDto;
import com.domloge.slinkylinky.userservice.entity.Organisation;
import com.domloge.slinkylinky.userservice.keycloak.KeycloakAdminClient;
import com.domloge.slinkylinky.userservice.repo.OrganisationRepo;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/.rest/accounts/admin")
public class OrganisationsOverviewController {

    @Autowired
    private OrganisationRepo organisationRepo;

    @Autowired
    private KeycloakAdminClient keycloakAdminClient;

    @Autowired
    private AmqpTemplate auditRabbitTemplate;

    private volatile List<OrgOverviewDto> cachedOverview;
    private volatile Instant overviewExpiry = Instant.EPOCH;

    @GetMapping("/organisations-overview")
    public ResponseEntity<List<OrgOverviewDto>> overview() {
        TenantFilter.requireGlobalAdmin();
        checkConfigured();

        if (cachedOverview != null && Instant.now().isBefore(overviewExpiry)) {
            return ResponseEntity.ok(cachedOverview);
        }

        List<Organisation> orgs = (List<Organisation>) organisationRepo.findAll();
        List<OrgOverviewDto> result = orgs.stream()
            .map(this::buildOrgDto)
            .toList();

        cachedOverview = result;
        overviewExpiry = Instant.now().plusSeconds(60);

        emitAudit(result.size());
        return ResponseEntity.ok(result);
    }

    private void checkConfigured() {
        if (!keycloakAdminClient.isConfigured()) {
            throw new ResponseStatusException(HttpStatus.SERVICE_UNAVAILABLE, "KEYCLOAK_NOT_CONFIGURED");
        }
    }

    private OrgOverviewDto buildOrgDto(Organisation org) {
        List<Map<String, Object>> kcUsers;
        try {
            kcUsers = keycloakAdminClient.listUsersByOrgId(org.getId().toString());
        } catch (Exception e) {
            log.warn("Keycloak user list failed for org {}: {}", org.getId(), e.getMessage());
            kcUsers = List.of();
        }

        List<UserOverviewDto> users = kcUsers.stream()
            .map(this::buildUserDto)
            .toList();

        return new OrgOverviewDto(
            org.getId(),
            org.getName(),
            org.getSlug(),
            org.getCreatedAt(),
            users
        );
    }

    private UserOverviewDto buildUserDto(Map<String, Object> u) {
        String userId = (String) u.get("id");

        List<String> roles;
        try {
            roles = keycloakAdminClient.getUserRealmRoles(userId);
        } catch (Exception e) {
            log.warn("Roles fetch failed for user {}: {}", userId, e.getMessage());
            roles = List.of();
        }

        LocalDateTime lastLogin;
        try {
            lastLogin = keycloakAdminClient.getLastLoginTime(userId);
        } catch (Exception e) {
            log.warn("Events fetch failed for user {}: {}", userId, e.getMessage());
            lastLogin = null;
        }

        return new UserOverviewDto(
            userId,
            (String) u.get("email"),
            (String) u.get("firstName"),
            (String) u.get("lastName"),
            Boolean.TRUE.equals(u.get("emailVerified")),
            roles,
            lastLogin
        );
    }

    private void emitAudit(int orgCount) {
        try {
            AuditEvent ae = new AuditEvent();
            ae.setWho(TenantContext.getUsername());
            ae.setWhat("list organisations overview");
            ae.setEventTime(LocalDateTime.now());
            try {
                ae.setDetail(new ObjectMapper().writeValueAsString(Map.of("orgCount", orgCount)));
            } catch (Exception ignored) {
                ae.setDetail("orgCount:" + orgCount);
            }
            auditRabbitTemplate.convertAndSend(ae);
        } catch (Exception e) {
            log.warn("Audit emit failed: {}", e.getMessage());
        }
    }
}
