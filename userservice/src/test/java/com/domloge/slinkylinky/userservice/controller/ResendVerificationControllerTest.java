package com.domloge.slinkylinky.userservice.controller;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.time.Instant;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;
import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;

import com.domloge.slinkylinky.userservice.email.EmailSender;
import com.domloge.slinkylinky.userservice.entity.EmailVerificationToken;
import com.domloge.slinkylinky.userservice.keycloak.KeycloakAdminClient;
import com.domloge.slinkylinky.userservice.rate.RateLimitFilter;
import com.domloge.slinkylinky.userservice.repo.EmailVerificationTokenRepo;
import com.domloge.slinkylinky.userservice.token.TokenHasher;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
class ResendVerificationControllerTest {

    @Mock private EmailVerificationTokenRepo tokenRepo;
    @Mock private KeycloakAdminClient keycloakAdminClient;
    @Mock private EmailSender emailSender;
    @Mock private TokenHasher tokenHasher;
    @Mock private AmqpTemplate auditRabbitTemplate;
    @Mock private RateLimitFilter rateLimitFilter;

    @InjectMocks
    private ResendVerificationController controller;

    private static final String USER_ID  = "keycloak-user-id";
    private static final String EMAIL    = "alice@example.com";
    private static final UUID   ORG_ID   = UUID.randomUUID();

    @BeforeEach
    void setUp() {
        when(tokenHasher.generateRawToken()).thenReturn("rawtoken");
        when(tokenHasher.hash(anyString())).thenReturn("a".repeat(64));
        when(tokenRepo.save(any())).thenAnswer(inv -> inv.getArgument(0));
        when(rateLimitFilter.resolveClientIp(any())).thenReturn("1.2.3.4");
    }

    // ── Authenticated resend ─────────────────────────────────────────────────

    @Test
    void resendAuthenticated_happyPath_returns200AndSendsEmail() throws Exception {
        setJwtContext(USER_ID, EMAIL, ORG_ID.toString());

        ResponseEntity<Map<String, String>> resp = controller.resendAuthenticated(new MockHttpServletRequest());

        assertEquals(HttpStatus.OK, resp.getStatusCode());
        verify(tokenRepo).invalidateAllForUser(USER_ID);
        verify(tokenRepo).save(any(EmailVerificationToken.class));
        verify(emailSender).sendVerificationEmail(eq(EMAIL), anyString());
    }

    @Test
    void resendAuthenticated_noJwt_returns401() throws Exception {
        SecurityContextHolder.clearContext();

        ResponseEntity<Map<String, String>> resp = controller.resendAuthenticated(new MockHttpServletRequest());

        assertEquals(HttpStatus.UNAUTHORIZED, resp.getStatusCode());
        verify(emailSender, never()).sendVerificationEmail(anyString(), anyString());
    }

    @Test
    void resendAuthenticated_emailSendFails_stillReturns200() throws Exception {
        setJwtContext(USER_ID, EMAIL, ORG_ID.toString());
        org.mockito.Mockito.doThrow(new RuntimeException("smtp error"))
            .when(emailSender).sendVerificationEmail(anyString(), anyString());

        ResponseEntity<Map<String, String>> resp = controller.resendAuthenticated(new MockHttpServletRequest());

        assertEquals(HttpStatus.OK, resp.getStatusCode());
    }

    // ── Public resend ────────────────────────────────────────────────────────

    @Test
    void resendPublic_unknownEmail_returns200WithNoEmailSent() throws Exception {
        when(keycloakAdminClient.getUserByEmail(EMAIL)).thenReturn(Optional.empty());

        ResponseEntity<Map<String, String>> resp =
            controller.resendPublic(Map.of("email", EMAIL), new MockHttpServletRequest());

        assertEquals(HttpStatus.OK, resp.getStatusCode());
        verify(emailSender, never()).sendVerificationEmail(anyString(), anyString());
    }

    @Test
    void resendPublic_verifiedUser_returns200WithNoEmailSent() throws Exception {
        Map<String, Object> user = Map.of("id", USER_ID, "emailVerified", true,
            "attributes", Map.of("org_id", List.of(ORG_ID.toString())));
        when(keycloakAdminClient.getUserByEmail(EMAIL)).thenReturn(Optional.of(user));

        ResponseEntity<Map<String, String>> resp =
            controller.resendPublic(Map.of("email", EMAIL), new MockHttpServletRequest());

        assertEquals(HttpStatus.OK, resp.getStatusCode());
        verify(emailSender, never()).sendVerificationEmail(anyString(), anyString());
    }

    @Test
    void resendPublic_unverifiedUser_sends200AndEmail() throws Exception {
        Map<String, Object> user = Map.of("id", USER_ID, "emailVerified", false,
            "attributes", Map.of("org_id", List.of(ORG_ID.toString())));
        when(keycloakAdminClient.getUserByEmail(EMAIL)).thenReturn(Optional.of(user));

        ResponseEntity<Map<String, String>> resp =
            controller.resendPublic(Map.of("email", EMAIL), new MockHttpServletRequest());

        assertEquals(HttpStatus.OK, resp.getStatusCode());
        verify(emailSender).sendVerificationEmail(eq(EMAIL), anyString());
    }

    @Test
    void resendPublic_blankEmail_returns200Immediately() throws Exception {
        ResponseEntity<Map<String, String>> resp =
            controller.resendPublic(Map.of("email", "  "), new MockHttpServletRequest());

        assertEquals(HttpStatus.OK, resp.getStatusCode());
        verify(keycloakAdminClient, never()).getUserByEmail(anyString());
    }

    // ── helper ───────────────────────────────────────────────────────────────

    private static void setJwtContext(String subject, String email, String orgId) {
        Jwt jwt = Jwt.withTokenValue("test-token")
            .header("alg", "none")
            .subject(subject)
            .claim("email", email)
            .claim("org_id", orgId)
            .claim("preferred_username", email)
            .issuedAt(Instant.now())
            .expiresAt(Instant.now().plusSeconds(3600))
            .build();
        SecurityContextHolder.getContext()
            .setAuthentication(new JwtAuthenticationToken(jwt));
    }
}
