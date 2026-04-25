package com.domloge.slinkylinky.userservice.controller;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.Map;
import java.util.UUID;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;
import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.test.util.ReflectionTestUtils;
import org.springframework.web.client.HttpClientErrorException;

import com.domloge.slinkylinky.userservice.captcha.CaptchaVerifier;
import com.domloge.slinkylinky.userservice.dto.RegistrationRequest;
import com.domloge.slinkylinky.userservice.email.EmailSender;
import com.domloge.slinkylinky.userservice.entity.EmailVerificationToken;
import com.domloge.slinkylinky.userservice.entity.Organisation;
import com.domloge.slinkylinky.userservice.keycloak.KeycloakAdminClient;
import com.domloge.slinkylinky.userservice.rate.RateLimitFilter;
import com.domloge.slinkylinky.userservice.repo.EmailVerificationTokenRepo;
import com.domloge.slinkylinky.userservice.repo.OrganisationRepo;
import com.domloge.slinkylinky.userservice.token.TokenHasher;

import jakarta.servlet.http.HttpServletRequest;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
class RegistrationControllerTest {

    @Mock private OrganisationRepo organisationRepo;
    @Mock private EmailVerificationTokenRepo tokenRepo;
    @Mock private KeycloakAdminClient keycloakAdminClient;
    @Mock private EmailSender emailSender;
    @Mock private TokenHasher tokenHasher;
    @Mock private CaptchaVerifier captchaVerifier;
    @Mock private RateLimitFilter rateLimitFilter;
    @Mock private AmqpTemplate auditRabbitTemplate;

    @InjectMocks
    private RegistrationController controller;

    private HttpServletRequest request;

    @BeforeEach
    void setUp() {
        request = mock(HttpServletRequest.class);
        ReflectionTestUtils.setField(controller, "registrationEnabled", true);
        when(captchaVerifier.verify(any())).thenReturn(true);
        when(rateLimitFilter.tryAcquire(any(), any())).thenReturn(true);
        when(tokenHasher.generateRawToken()).thenReturn("rawtoken");
        when(tokenHasher.hash(anyString())).thenReturn("a".repeat(64));
        when(tokenRepo.save(any())).thenAnswer(inv -> inv.getArgument(0));
    }

    @Test
    void register_returnsCreated_onHappyPath() throws Exception {
        Organisation saved = new Organisation();
        saved.setId(UUID.randomUUID());
        saved.setName("Acme Ltd");
        saved.setSlug("acme-ltd");
        when(organisationRepo.save(any())).thenReturn(saved);
        when(keycloakAdminClient.createUser(any())).thenReturn("keycloak-user-id");
        when(keycloakAdminClient.getRoleByName("tenant_admin")).thenReturn(Map.of("id", "role-id", "name", "tenant_admin"));

        ResponseEntity<Map<String, String>> resp = controller.register(validRequest(), request);

        assertEquals(HttpStatus.CREATED, resp.getStatusCode());
        verify(keycloakAdminClient).assignRealmRole(anyString(), any());
        verify(tokenRepo).save(any(EmailVerificationToken.class));
        verify(emailSender).sendVerificationEmail(anyString(), anyString());
    }

    @Test
    void register_returns503_whenFlagOff() {
        ReflectionTestUtils.setField(controller, "registrationEnabled", false);
        ResponseEntity<Map<String, String>> resp = controller.register(validRequest(), request);
        assertEquals(HttpStatus.SERVICE_UNAVAILABLE, resp.getStatusCode());
        assertEquals("REGISTRATION_DISABLED", resp.getBody().get("code"));
    }

    @Test
    void register_returns429_whenRateLimited() {
        when(rateLimitFilter.tryAcquire(any(), any())).thenReturn(false);
        ResponseEntity<Map<String, String>> resp = controller.register(validRequest(), request);
        assertEquals(HttpStatus.TOO_MANY_REQUESTS, resp.getStatusCode());
    }

    @Test
    void register_returns409_onDuplicateEmail() {
        Organisation saved = new Organisation();
        saved.setId(UUID.randomUUID());
        saved.setName("Acme Ltd");
        saved.setSlug("acme-ltd");
        when(organisationRepo.save(any())).thenReturn(saved);
        when(keycloakAdminClient.createUser(any()))
            .thenThrow(HttpClientErrorException.Conflict.class);

        ResponseEntity<Map<String, String>> resp = controller.register(validRequest(), request);

        assertEquals(HttpStatus.CONFLICT, resp.getStatusCode());
        assertEquals("EMAIL_EXISTS", resp.getBody().get("code"));
        verify(organisationRepo).deleteById(any());
    }

    @Test
    void register_returns503_whenOrgSlugExhausted() {
        when(organisationRepo.save(any())).thenThrow(DataIntegrityViolationException.class);

        ResponseEntity<Map<String, String>> resp = controller.register(validRequest(), request);

        assertEquals(HttpStatus.SERVICE_UNAVAILABLE, resp.getStatusCode());
        assertEquals("SLUG_EXHAUSTED", resp.getBody().get("code"));
        verify(organisationRepo, times(10)).save(any());
    }

    @Test
    void register_compensatesOnRoleAssignFailure() throws Exception {
        Organisation saved = new Organisation();
        saved.setId(UUID.randomUUID());
        saved.setName("Acme");
        saved.setSlug("acme");
        when(organisationRepo.save(any())).thenReturn(saved);
        when(keycloakAdminClient.createUser(any())).thenReturn("user-id");
        when(keycloakAdminClient.getRoleByName("tenant_admin")).thenReturn(Map.of("id", "r"));
        doThrow(new RuntimeException("role error"))
            .when(keycloakAdminClient).assignRealmRole(anyString(), any());

        ResponseEntity<Map<String, String>> resp = controller.register(validRequest(), request);

        assertEquals(HttpStatus.SERVICE_UNAVAILABLE, resp.getStatusCode());
        verify(keycloakAdminClient).disableUser("user-id");
        verify(organisationRepo).deleteById(saved.getId());
    }

    @Test
    void register_compensatesOnTokenSaveFailure() throws Exception {
        Organisation saved = new Organisation();
        saved.setId(UUID.randomUUID());
        saved.setName("Acme");
        saved.setSlug("acme");
        when(organisationRepo.save(any())).thenReturn(saved);
        when(keycloakAdminClient.createUser(any())).thenReturn("user-id");
        when(keycloakAdminClient.getRoleByName("tenant_admin")).thenReturn(Map.of("id", "r"));
        when(tokenRepo.save(any())).thenThrow(new RuntimeException("db error"));

        ResponseEntity<Map<String, String>> resp = controller.register(validRequest(), request);

        assertEquals(HttpStatus.SERVICE_UNAVAILABLE, resp.getStatusCode());
        verify(keycloakAdminClient).disableUser("user-id");
        verify(organisationRepo).deleteById(saved.getId());
    }

    @Test
    void register_returns201_evenWhenEmailFails() throws Exception {
        Organisation saved = new Organisation();
        saved.setId(UUID.randomUUID());
        saved.setName("Acme");
        saved.setSlug("acme");
        when(organisationRepo.save(any())).thenReturn(saved);
        when(keycloakAdminClient.createUser(any())).thenReturn("user-id");
        when(keycloakAdminClient.getRoleByName("tenant_admin")).thenReturn(Map.of("id", "r"));
        doThrow(new RuntimeException("smtp error")).when(emailSender).sendVerificationEmail(anyString(), anyString());

        ResponseEntity<Map<String, String>> resp = controller.register(validRequest(), request);

        // Email failure is non-fatal — user can resend
        assertEquals(HttpStatus.CREATED, resp.getStatusCode());
        verify(keycloakAdminClient, never()).disableUser(anyString());
    }

    @Test
    void register_usesSecondSlug_onFirstCollision() throws Exception {
        Organisation savedWithSuffix = new Organisation();
        savedWithSuffix.setId(UUID.randomUUID());
        savedWithSuffix.setName("Acme");
        savedWithSuffix.setSlug("acme-2");

        when(organisationRepo.save(any()))
            .thenThrow(new DataIntegrityViolationException("slug taken"))
            .thenReturn(savedWithSuffix);
        when(keycloakAdminClient.createUser(any())).thenReturn("user-id");
        when(keycloakAdminClient.getRoleByName("tenant_admin")).thenReturn(Map.of("id", "r"));

        ResponseEntity<Map<String, String>> resp = controller.register(validRequest(), request);

        assertEquals(HttpStatus.CREATED, resp.getStatusCode());

        ArgumentCaptor<Organisation> captor = ArgumentCaptor.forClass(Organisation.class);
        verify(organisationRepo, times(2)).save(captor.capture());
        assertEquals("acme", captor.getAllValues().get(0).getSlug());
        assertEquals("acme-2", captor.getAllValues().get(1).getSlug());
    }

    private RegistrationRequest validRequest() {
        RegistrationRequest req = new RegistrationRequest();
        req.setFirstName("Alice");
        req.setLastName("Smith");
        req.setEmail("alice@example.com");
        req.setPassword("Password1");
        req.setCompanyName("Acme");
        return req;
    }
}
