package com.domloge.slinkylinky.userservice.controller;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.HttpClientErrorException;

import com.domloge.slinkylinky.events.AuditEvent;
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
import jakarta.validation.Valid;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/.rest/accounts/registration")
public class RegistrationController {

    @Value("${accounts.registration.enabled:false}")
    private boolean registrationEnabled;

    @Autowired private OrganisationRepo organisationRepo;
    @Autowired private EmailVerificationTokenRepo tokenRepo;
    @Autowired private KeycloakAdminClient keycloakAdminClient;
    @Autowired private EmailSender emailSender;
    @Autowired private TokenHasher tokenHasher;
    @Autowired private CaptchaVerifier captchaVerifier;
    @Autowired private RateLimitFilter rateLimitFilter;
    @Autowired private AmqpTemplate auditRabbitTemplate;

    @PostMapping
    public ResponseEntity<Map<String, String>> register(
            @Valid @RequestBody RegistrationRequest body,
            HttpServletRequest request) {

        if (!registrationEnabled) {
            return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE)
                .body(Map.of("code", "REGISTRATION_DISABLED"));
        }

        String email = body.getEmail().trim().toLowerCase();

        if (!rateLimitFilter.tryAcquire(request, email)) {
            return ResponseEntity.status(HttpStatus.TOO_MANY_REQUESTS)
                .body(Map.of("code", "RATE_LIMITED", "message", "Too many attempts. Please try again in an hour."));
        }

        // Captcha stub — always passes until hCaptcha is integrated
        if (!captchaVerifier.verify(null)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                .body(Map.of("code", "CAPTCHA_FAILED"));
        }

        // Step 1: Insert Organisation (retry slug collisions up to 10 times)
        String baseSlug = slugify(body.getCompanyName());
        Organisation savedOrg = null;
        for (int attempt = 1; attempt <= 10; attempt++) {
            String slug = attempt == 1 ? baseSlug : baseSlug + "-" + attempt;
            Organisation org = new Organisation();
            org.setId(UUID.randomUUID());
            org.setName(body.getCompanyName().trim());
            org.setSlug(slug);
            org.setCreatedAt(LocalDateTime.now());
            try {
                savedOrg = organisationRepo.save(org);
                break;
            } catch (DataIntegrityViolationException e) {
                log.debug("Slug collision on '{}', attempt {}/10", slug, attempt);
                if (attempt == 10) {
                    log.error("Slug exhausted for company name '{}'", body.getCompanyName());
                    return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE)
                        .body(Map.of("code", "SLUG_EXHAUSTED"));
                }
            }
        }

        final UUID orgId = savedOrg.getId();

        // Step 2: Create Keycloak user
        String newUserId;
        try {
            Map<String, Object> userRep = Map.of(
                "firstName", body.getFirstName().trim(),
                "lastName",  body.getLastName().trim(),
                "email",     email,
                "username",  email,
                "enabled",   true,
                "emailVerified", false,
                "attributes", Map.of("org_id", List.of(orgId.toString())),
                "credentials", List.of(Map.of(
                    "type", "password",
                    "value", body.getPassword(),
                    "temporary", false
                ))
            );
            newUserId = keycloakAdminClient.createUser(userRep);
        } catch (HttpClientErrorException.Conflict e) {
            log.info("Registration rejected: email already exists in Keycloak: {}", email);
            organisationRepo.deleteById(orgId);
            return ResponseEntity.status(HttpStatus.CONFLICT)
                .body(Map.of("code", "EMAIL_EXISTS",
                             "message", "An account with this email already exists."));
        } catch (Exception e) {
            log.error("Keycloak user creation failed for {}", email, e);
            organisationRepo.deleteById(orgId);
            return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE)
                .body(Map.of("code", "KEYCLOAK_ERROR"));
        }

        // Step 3: Assign tenant_admin role
        try {
            Map<String, Object> role = keycloakAdminClient.getRoleByName("tenant_admin");
            keycloakAdminClient.assignRealmRole(newUserId, role);
        } catch (Exception e) {
            log.error("Role assignment failed for user {}, compensating", newUserId, e);
            silentlyDisableUser(newUserId);
            organisationRepo.deleteById(orgId);
            return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE)
                .body(Map.of("code", "ROLE_ASSIGNMENT_FAILED"));
        }

        // Step 4: Persist hashed verification token
        String rawToken = tokenHasher.generateRawToken();
        String hashedToken = tokenHasher.hash(rawToken);
        EmailVerificationToken tokenEntity = new EmailVerificationToken();
        tokenEntity.setTokenHash(hashedToken);
        tokenEntity.setUserId(newUserId);
        tokenEntity.setEmail(email);
        tokenEntity.setOrgId(orgId);
        tokenEntity.setExpiresAt(LocalDateTime.now().plusHours(24));
        tokenEntity.setCreatedAt(LocalDateTime.now());
        try {
            tokenRepo.save(tokenEntity);
        } catch (Exception e) {
            log.error("Token persistence failed for user {}, compensating", newUserId, e);
            silentlyDisableUser(newUserId);
            organisationRepo.deleteById(orgId);
            return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE)
                .body(Map.of("code", "TOKEN_SAVE_FAILED"));
        }

        // Step 5: Send verification email (failure is non-fatal; user can resend)
        try {
            emailSender.sendVerificationEmail(email, rawToken);
        } catch (Exception e) {
            log.error("Verification email failed for {} — token is persisted, user can resend", email, e);
        }

        // Step 6: Emit audit events (best-effort)
        emitRegistrationAuditEvents(email, savedOrg, newUserId, orgId,
            body.getFirstName().trim(), body.getLastName().trim());

        return ResponseEntity.status(HttpStatus.CREATED)
            .body(Map.of("message", "Account created. Please check your email to verify before signing in."));
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, Object>> handleValidationErrors(MethodArgumentNotValidException ex) {
        Map<String, String> fieldErrors = new java.util.LinkedHashMap<>();
        for (FieldError fe : ex.getBindingResult().getFieldErrors()) {
            fieldErrors.put(fe.getField(), fe.getDefaultMessage());
        }
        return ResponseEntity.badRequest().body(Map.of("errors", fieldErrors));
    }

    private String slugify(String companyName) {
        String slug = companyName.trim().toLowerCase()
            .replaceAll("[^a-z0-9]+", "-")
            .replaceAll("^-+|-+$", "");
        return slug.isBlank() ? "org" : slug;
    }

    private void silentlyDisableUser(String userId) {
        try {
            keycloakAdminClient.disableUser(userId);
        } catch (Exception e) {
            log.warn("Could not disable Keycloak user {} during compensation: {}", userId, e.getMessage());
        }
    }

    private void emitRegistrationAuditEvents(String email, Organisation org,
                                              String newUserId, UUID orgId,
                                              String firstName, String lastName) {
        try {
            AuditEvent orgEvent = new AuditEvent();
            orgEvent.setWho(email);
            orgEvent.setWhat("create organisation " + org.getName());
            orgEvent.setEventTime(LocalDateTime.now());
            orgEvent.setEntityType("Organisation");
            orgEvent.setEntityId(orgId.toString());
            orgEvent.setOrganisationId(orgId);
            try {
                com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
                orgEvent.setDetail(mapper.writeValueAsString(Map.of("id", orgId, "name", org.getName(), "slug", org.getSlug())));
            } catch (Exception e) {
                orgEvent.setDetail("org:" + orgId);
            }
            auditRabbitTemplate.convertAndSend(orgEvent);

            AuditEvent userEvent = new AuditEvent();
            userEvent.setWho(email);
            userEvent.setWhat("register user");
            userEvent.setEventTime(LocalDateTime.now());
            userEvent.setEntityType("User");
            userEvent.setEntityId(newUserId);
            userEvent.setOrganisationId(orgId);
            try {
                com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
                userEvent.setDetail(mapper.writeValueAsString(Map.of(
                    "email", email,
                    "firstName", firstName,
                    "lastName", lastName,
                    "orgId", orgId
                )));
            } catch (Exception e) {
                userEvent.setDetail("user:" + newUserId + ",org:" + orgId);
            }
            auditRabbitTemplate.convertAndSend(userEvent);
        } catch (Exception e) {
            log.warn("Audit event emission failed for registration of {} — continuing", email, e);
        }
    }
}
