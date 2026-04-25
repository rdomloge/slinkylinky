package com.domloge.slinkylinky.userservice.controller;

import java.time.LocalDateTime;
import java.util.Map;

import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.domloge.slinkylinky.events.AuditEvent;
import com.domloge.slinkylinky.userservice.entity.EmailVerificationToken;
import com.domloge.slinkylinky.userservice.keycloak.KeycloakAdminClient;
import com.domloge.slinkylinky.userservice.repo.EmailVerificationTokenRepo;
import com.domloge.slinkylinky.userservice.token.TokenHasher;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/.rest/accounts")
public class VerifyEmailController {

    @Autowired private EmailVerificationTokenRepo tokenRepo;
    @Autowired private KeycloakAdminClient keycloakAdminClient;
    @Autowired private TokenHasher tokenHasher;
    @Autowired private AmqpTemplate auditRabbitTemplate;

    @GetMapping("/verify-email")
    public ResponseEntity<Map<String, String>> verifyEmail(@RequestParam("token") String rawToken) {
        String hash = tokenHasher.hash(rawToken);
        EmailVerificationToken token = tokenRepo
            .findByTokenHashAndUsedFalseAndExpiresAtAfter(hash, LocalDateTime.now())
            .orElse(null);

        if (token == null) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(Map.of("code", "INVALID_OR_EXPIRED",
                             "message", "This verification link is invalid or has expired."));
        }

        try {
            keycloakAdminClient.setEmailVerified(token.getUserId(), true);
        } catch (Exception e) {
            log.error("Keycloak setEmailVerified failed for user {}", token.getUserId(), e);
            return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE)
                .body(Map.of("code", "VERIFICATION_FAILED",
                             "message", "Could not complete verification. Please try again."));
        }

        token.setUsed(true);
        try {
            tokenRepo.save(token);
        } catch (Exception e) {
            log.error("Token mark-used failed for user {} — Keycloak already updated", token.getUserId(), e);
        }

        emitAudit(token);

        return ResponseEntity.ok(Map.of("message", "Email verified successfully. You can now sign in."));
    }

    private void emitAudit(EmailVerificationToken token) {
        try {
            AuditEvent event = new AuditEvent();
            event.setWho(token.getEmail());
            event.setWhat("email verified");
            event.setEntityType("User");
            event.setEntityId(token.getUserId());
            event.setOrganisationId(token.getOrgId());
            event.setEventTime(LocalDateTime.now());
            try {
                event.setDetail(new com.fasterxml.jackson.databind.ObjectMapper()
                    .writeValueAsString(Map.of("userId", token.getUserId(), "email", token.getEmail())));
            } catch (Exception e) {
                event.setDetail("userId:" + token.getUserId());
            }
            auditRabbitTemplate.convertAndSend(event);
        } catch (Exception e) {
            log.warn("Audit emit failed for email verification of {} — continuing", token.getEmail(), e);
        }
    }
}
