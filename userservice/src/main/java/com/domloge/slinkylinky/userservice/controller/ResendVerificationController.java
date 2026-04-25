package com.domloge.slinkylinky.userservice.controller;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.domloge.slinkylinky.events.AuditEvent;
import com.domloge.slinkylinky.userservice.email.EmailSender;
import com.domloge.slinkylinky.userservice.entity.EmailVerificationToken;
import com.domloge.slinkylinky.userservice.keycloak.KeycloakAdminClient;
import com.domloge.slinkylinky.userservice.rate.RateLimitFilter;
import com.domloge.slinkylinky.userservice.repo.EmailVerificationTokenRepo;
import com.domloge.slinkylinky.userservice.token.TokenHasher;

import io.github.bucket4j.Bandwidth;
import io.github.bucket4j.Bucket;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/.rest/accounts")
public class ResendVerificationController {

    private static final long RESEND_CAPACITY = 3;
    private static final Duration RESEND_WINDOW = Duration.ofHours(1);

    @Autowired private EmailVerificationTokenRepo tokenRepo;
    @Autowired private KeycloakAdminClient keycloakAdminClient;
    @Autowired private EmailSender emailSender;
    @Autowired private TokenHasher tokenHasher;
    @Autowired private AmqpTemplate auditRabbitTemplate;
    @Autowired private RateLimitFilter rateLimitFilter;

    private final ConcurrentHashMap<String, Bucket> userIdBuckets = new ConcurrentHashMap<>();
    private final ConcurrentHashMap<String, Bucket> emailBuckets  = new ConcurrentHashMap<>();

    /** Authenticated resend — caller must be signed in but email need not be verified. */
    @PostMapping("/resend-verification")
    public ResponseEntity<Map<String, String>> resendAuthenticated(HttpServletRequest request) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!(auth instanceof JwtAuthenticationToken jwtAuth)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(Map.of("code", "UNAUTHENTICATED"));
        }

        Jwt jwt = jwtAuth.getToken();
        String userId = jwt.getSubject();
        String email  = jwt.getClaimAsString("email");
        String orgIdStr = jwt.getClaimAsString("org_id");

        if (userId == null || email == null || orgIdStr == null) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(Map.of("code", "MISSING_CLAIMS",
                             "message", "JWT is missing required claims."));
        }

        Bucket userBucket = userIdBuckets.computeIfAbsent(userId, k -> buildBucket());
        if (!userBucket.tryConsume(1)) {
            return ResponseEntity.status(HttpStatus.TOO_MANY_REQUESTS)
                .body(Map.of("code", "RATE_LIMITED",
                             "message", "Too many resend attempts. Please try again in an hour."));
        }

        UUID orgId;
        try {
            orgId = UUID.fromString(orgIdStr);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(Map.of("code", "INVALID_ORG_ID"));
        }

        tokenRepo.invalidateAllForUser(userId);

        String rawToken = tokenHasher.generateRawToken();
        EmailVerificationToken tokenEntity = buildToken(rawToken, userId, email, orgId);
        try {
            tokenRepo.save(tokenEntity);
        } catch (Exception e) {
            log.error("Failed to save resend token for user {}", userId, e);
            return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE)
                .body(Map.of("code", "TOKEN_SAVE_FAILED"));
        }

        try {
            emailSender.sendVerificationEmail(email, rawToken);
        } catch (Exception e) {
            log.error("Resend email failed for {} — token is persisted", email, e);
        }

        emitResendAudit(userId, email, orgId, jwt.getClaimAsString("preferred_username"), false);

        return ResponseEntity.ok(Map.of("message", "Verification email sent. Please check your inbox."));
    }

    /** Public resend — enumeration-safe; always returns 200. */
    @PostMapping("/resend-verification/public")
    public ResponseEntity<Map<String, String>> resendPublic(
            @RequestBody Map<String, String> body,
            HttpServletRequest request) {

        String email = body == null ? null : body.get("email");
        if (email == null || email.isBlank()) {
            return ResponseEntity.ok(Map.of("message", "If that email exists and is unverified, a new link has been sent."));
        }
        email = email.trim().toLowerCase();

        String ip = rateLimitFilter.resolveClientIp(request);
        Bucket ipBucket    = userIdBuckets.computeIfAbsent("ip:" + ip, k -> buildBucket());
        Bucket emailBucket = emailBuckets.computeIfAbsent(email, k -> buildBucket());
        if (!ipBucket.tryConsume(1) || !emailBucket.tryConsume(1)) {
            return ResponseEntity.status(HttpStatus.TOO_MANY_REQUESTS)
                .body(Map.of("code", "RATE_LIMITED",
                             "message", "Too many attempts. Please try again in an hour."));
        }

        Optional<Map<String, Object>> userOpt;
        try {
            userOpt = keycloakAdminClient.getUserByEmail(email);
        } catch (Exception e) {
            log.warn("Keycloak lookup failed for public resend of {} — returning 200", email, e);
            return ResponseEntity.ok(Map.of("message", "If that email exists and is unverified, a new link has been sent."));
        }

        if (userOpt.isEmpty()) {
            return ResponseEntity.ok(Map.of("message", "If that email exists and is unverified, a new link has been sent."));
        }

        Map<String, Object> user = userOpt.get();
        Boolean emailVerified = (Boolean) user.get("emailVerified");
        if (Boolean.TRUE.equals(emailVerified)) {
            return ResponseEntity.ok(Map.of("message", "If that email exists and is unverified, a new link has been sent."));
        }

        String userId = (String) user.get("id");
        Object orgIdObj = null;
        Object attrs = user.get("attributes");
        if (attrs instanceof Map<?, ?> attrMap) {
            Object orgList = attrMap.get("org_id");
            if (orgList instanceof java.util.List<?> list && !list.isEmpty()) {
                orgIdObj = list.get(0);
            }
        }

        UUID orgId = null;
        if (orgIdObj != null) {
            try {
                orgId = UUID.fromString(orgIdObj.toString());
            } catch (IllegalArgumentException ignored) {}
        }
        if (orgId == null) {
            log.warn("Public resend: no org_id for user {} — skipping", userId);
            return ResponseEntity.ok(Map.of("message", "If that email exists and is unverified, a new link has been sent."));
        }

        tokenRepo.invalidateAllForUser(userId);

        String rawToken = tokenHasher.generateRawToken();
        EmailVerificationToken tokenEntity = buildToken(rawToken, userId, email, orgId);
        try {
            tokenRepo.save(tokenEntity);
        } catch (Exception e) {
            log.error("Failed to save public resend token for user {}", userId, e);
            return ResponseEntity.ok(Map.of("message", "If that email exists and is unverified, a new link has been sent."));
        }

        try {
            emailSender.sendVerificationEmail(email, rawToken);
        } catch (Exception e) {
            log.error("Public resend email failed for {} — token persisted", email, e);
        }

        emitResendAudit(userId, email, orgId, email, true);

        return ResponseEntity.ok(Map.of("message", "If that email exists and is unverified, a new link has been sent."));
    }

    private EmailVerificationToken buildToken(String rawToken, String userId, String email, UUID orgId) {
        String hashedToken = tokenHasher.hash(rawToken);
        EmailVerificationToken t = new EmailVerificationToken();
        t.setTokenHash(hashedToken);
        t.setUserId(userId);
        t.setEmail(email);
        t.setOrgId(orgId);
        t.setExpiresAt(LocalDateTime.now().plusHours(24));
        t.setCreatedAt(LocalDateTime.now());
        return t;
    }

    private void emitResendAudit(String userId, String email, UUID orgId, String who, boolean isPublic) {
        try {
            AuditEvent event = new AuditEvent();
            event.setWho(who);
            event.setWhat("send verification email");
            event.setEntityType("User");
            event.setEntityId(userId);
            event.setOrganisationId(orgId);
            event.setEventTime(LocalDateTime.now());
            try {
                Map<String, Object> detail = isPublic
                    ? Map.of("userId", userId, "source", "public")
                    : Map.of("userId", userId);
                event.setDetail(new com.fasterxml.jackson.databind.ObjectMapper().writeValueAsString(detail));
            } catch (Exception e) {
                event.setDetail("userId:" + userId);
            }
            auditRabbitTemplate.convertAndSend(event);
        } catch (Exception e) {
            log.warn("Audit emit failed for resend verification of {} — continuing", email, e);
        }
    }

    private Bucket buildBucket() {
        Bandwidth limit = Bandwidth.builder()
            .capacity(RESEND_CAPACITY)
            .refillIntervally(RESEND_CAPACITY, RESEND_WINDOW)
            .build();
        return Bucket.builder().addLimit(limit).build();
    }
}
