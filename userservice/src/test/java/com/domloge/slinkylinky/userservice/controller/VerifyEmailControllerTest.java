package com.domloge.slinkylinky.userservice.controller;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyBoolean;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import com.domloge.slinkylinky.userservice.entity.EmailVerificationToken;
import com.domloge.slinkylinky.userservice.keycloak.KeycloakAdminClient;
import com.domloge.slinkylinky.userservice.repo.EmailVerificationTokenRepo;
import com.domloge.slinkylinky.userservice.token.TokenHasher;

@ExtendWith(MockitoExtension.class)
class VerifyEmailControllerTest {

    @Mock private EmailVerificationTokenRepo tokenRepo;
    @Mock private KeycloakAdminClient keycloakAdminClient;
    @Mock private TokenHasher tokenHasher;
    @Mock private AmqpTemplate auditRabbitTemplate;

    @InjectMocks
    private VerifyEmailController controller;

    private static final String RAW_TOKEN = "rawtoken123";
    private static final String HASHED_TOKEN = "a".repeat(64);

    @BeforeEach
    void setUp() {
        when(tokenHasher.hash(RAW_TOKEN)).thenReturn(HASHED_TOKEN);
    }

    @Test
    void verifyEmail_validToken_returns200AndMarksUsed() {
        EmailVerificationToken token = validToken();
        when(tokenRepo.findByTokenHashAndUsedFalseAndExpiresAtAfter(eq(HASHED_TOKEN), any()))
            .thenReturn(Optional.of(token));

        ResponseEntity<Map<String, String>> resp = controller.verifyEmail(RAW_TOKEN);

        assertEquals(HttpStatus.OK, resp.getStatusCode());
        verify(keycloakAdminClient).setEmailVerified(token.getUserId(), true);
        verify(tokenRepo).save(token);
    }

    @Test
    void verifyEmail_tokenNotFound_returns400() {
        when(tokenRepo.findByTokenHashAndUsedFalseAndExpiresAtAfter(eq(HASHED_TOKEN), any()))
            .thenReturn(Optional.empty());

        ResponseEntity<Map<String, String>> resp = controller.verifyEmail(RAW_TOKEN);

        assertEquals(HttpStatus.BAD_REQUEST, resp.getStatusCode());
        assertEquals("INVALID_OR_EXPIRED", resp.getBody().get("code"));
        verify(keycloakAdminClient, never()).setEmailVerified(anyString(), anyBoolean());
    }

    @Test
    void verifyEmail_keycloakFails_returns503AndTokenNotMarkedUsed() {
        EmailVerificationToken token = validToken();
        when(tokenRepo.findByTokenHashAndUsedFalseAndExpiresAtAfter(eq(HASHED_TOKEN), any()))
            .thenReturn(Optional.of(token));
        doThrow(new RuntimeException("keycloak down")).when(keycloakAdminClient)
            .setEmailVerified(anyString(), anyBoolean());

        ResponseEntity<Map<String, String>> resp = controller.verifyEmail(RAW_TOKEN);

        assertEquals(HttpStatus.SERVICE_UNAVAILABLE, resp.getStatusCode());
        assertEquals("VERIFICATION_FAILED", resp.getBody().get("code"));
        verify(tokenRepo, never()).save(any());
    }

    @Test
    void verifyEmail_emitsAuditEvent() {
        EmailVerificationToken token = validToken();
        when(tokenRepo.findByTokenHashAndUsedFalseAndExpiresAtAfter(eq(HASHED_TOKEN), any()))
            .thenReturn(Optional.of(token));

        controller.verifyEmail(RAW_TOKEN);

        verify(auditRabbitTemplate).convertAndSend(any());
    }

    private EmailVerificationToken validToken() {
        EmailVerificationToken t = new EmailVerificationToken();
        t.setTokenHash(HASHED_TOKEN);
        t.setUserId("keycloak-user-id");
        t.setEmail("alice@example.com");
        t.setOrgId(UUID.randomUUID());
        t.setExpiresAt(LocalDateTime.now().plusHours(1));
        t.setCreatedAt(LocalDateTime.now());
        return t;
    }
}
