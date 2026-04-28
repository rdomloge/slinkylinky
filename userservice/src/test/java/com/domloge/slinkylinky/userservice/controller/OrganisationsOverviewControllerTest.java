package com.domloge.slinkylinky.userservice.controller;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.web.server.ResponseStatusException;

import com.domloge.slinkylinky.userservice.dto.OrgOverviewDto;
import com.domloge.slinkylinky.userservice.entity.Organisation;
import com.domloge.slinkylinky.userservice.keycloak.KeycloakAdminClient;
import com.domloge.slinkylinky.userservice.repo.OrganisationRepo;

@ExtendWith(MockitoExtension.class)
class OrganisationsOverviewControllerTest {

    @Mock
    private KeycloakAdminClient keycloakAdminClient;

    @Mock
    private OrganisationRepo organisationRepo;

    @InjectMocks
    private OrganisationsOverviewController controller;

    @AfterEach
    void clearContext() {
        SecurityContextHolder.clearContext();
    }

    private void setUpAsGlobalAdmin() {
        Jwt jwt = Jwt.withTokenValue("token")
            .header("alg", "RS256")
            .claim("realm_access", Map.of("roles", List.of("global_admin")))
            .claim("preferred_username", "admin@test.com")
            .build();
        SecurityContextHolder.getContext().setAuthentication(new JwtAuthenticationToken(jwt));
    }

    private void setUpAsNonAdmin() {
        Jwt jwt = Jwt.withTokenValue("token")
            .header("alg", "RS256")
            .claim("realm_access", Map.of("roles", List.of("tenant_admin")))
            .build();
        SecurityContextHolder.getContext().setAuthentication(new JwtAuthenticationToken(jwt));
    }

    @Test
    void overview_nonAdmin_returns403() {
        setUpAsNonAdmin();
        assertThatThrownBy(() -> controller.overview())
            .isInstanceOf(ResponseStatusException.class)
            .extracting(e -> ((ResponseStatusException) e).getStatusCode())
            .isEqualTo(HttpStatus.FORBIDDEN);
    }

    @Test
    void overview_happyPath_returnsExpectedShape() {
        setUpAsGlobalAdmin();
        when(keycloakAdminClient.isConfigured()).thenReturn(true);

        Organisation org = new Organisation();
        org.setId(UUID.fromString("00000000-0000-0000-0000-000000000001"));
        org.setName("Acme");
        org.setSlug("acme");
        org.setCreatedAt(LocalDateTime.of(2026, 4, 1, 10, 0));

        when(organisationRepo.findAll()).thenReturn(List.of(org));

        Map<String, Object> kcUser = Map.of(
            "id", "user-1",
            "email", "alice@acme.com",
            "firstName", "Alice",
            "lastName", "Smith",
            "emailVerified", true
        );
        when(keycloakAdminClient.listUsersByOrgId("00000000-0000-0000-0000-000000000001"))
            .thenReturn(List.of(kcUser));
        when(keycloakAdminClient.getUserRealmRoles("user-1")).thenReturn(List.of("tenant_admin"));
        when(keycloakAdminClient.getLastLoginTime("user-1"))
            .thenReturn(LocalDateTime.of(2026, 4, 1, 10, 0));

        ResponseEntity<List<OrgOverviewDto>> response = controller.overview();

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        List<OrgOverviewDto> body = response.getBody();
        assertThat(body).hasSize(1);
        assertThat(body.get(0).orgName()).isEqualTo("Acme");
        assertThat(body.get(0).users()).hasSize(1);
        assertThat(body.get(0).users().get(0).email()).isEqualTo("alice@acme.com");
        assertThat(body.get(0).users().get(0).roles()).contains("tenant_admin");
        assertThat(body.get(0).users().get(0).lastLogin()).isEqualTo(LocalDateTime.of(2026, 4, 1, 10, 0));
    }

    @Test
    void overview_rolesFetchFails_returnsEmptyRoles() {
        setUpAsGlobalAdmin();
        when(keycloakAdminClient.isConfigured()).thenReturn(true);

        Organisation org = new Organisation();
        org.setId(UUID.fromString("00000000-0000-0000-0000-000000000001"));
        org.setName("Acme");
        org.setSlug("acme");
        org.setCreatedAt(LocalDateTime.of(2026, 4, 1, 10, 0));

        when(organisationRepo.findAll()).thenReturn(List.of(org));

        Map<String, Object> kcUser = Map.of(
            "id", "user-1",
            "email", "alice@acme.com",
            "firstName", "Alice",
            "lastName", "Smith",
            "emailVerified", true
        );
        when(keycloakAdminClient.listUsersByOrgId(any())).thenReturn(List.of(kcUser));
        when(keycloakAdminClient.getUserRealmRoles("user-1")).thenThrow(new RuntimeException("Keycloak error"));
        when(keycloakAdminClient.getLastLoginTime("user-1")).thenReturn(null);

        ResponseEntity<List<OrgOverviewDto>> response = controller.overview();

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        List<OrgOverviewDto> body = response.getBody();
        assertThat(body).hasSize(1);
        assertThat(body.get(0).users().get(0).roles()).isEmpty();
    }

    @Test
    void overview_eventsFetchFails_returnsNullLastLogin() {
        setUpAsGlobalAdmin();
        when(keycloakAdminClient.isConfigured()).thenReturn(true);

        Organisation org = new Organisation();
        org.setId(UUID.fromString("00000000-0000-0000-0000-000000000001"));
        org.setName("Acme");
        org.setSlug("acme");
        org.setCreatedAt(LocalDateTime.of(2026, 4, 1, 10, 0));

        when(organisationRepo.findAll()).thenReturn(List.of(org));

        Map<String, Object> kcUser = Map.of(
            "id", "user-1",
            "email", "alice@acme.com",
            "firstName", "Alice",
            "lastName", "Smith",
            "emailVerified", true
        );
        when(keycloakAdminClient.listUsersByOrgId(any())).thenReturn(List.of(kcUser));
        when(keycloakAdminClient.getUserRealmRoles("user-1")).thenReturn(List.of());
        when(keycloakAdminClient.getLastLoginTime("user-1")).thenThrow(new RuntimeException("Events unavailable"));

        ResponseEntity<List<OrgOverviewDto>> response = controller.overview();

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        List<OrgOverviewDto> body = response.getBody();
        assertThat(body).hasSize(1);
        assertThat(body.get(0).users().get(0).lastLogin()).isNull();
    }
}
