package com.domloge.slinkylinky.linkservice.controller;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.UUID;

import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.domloge.slinkylinky.common.TenantContext;
import com.domloge.slinkylinky.events.AuditEvent;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/.rest/loginEvent")
public class LoginEventController {

    @Autowired
    private AmqpTemplate auditRabbitTemplate;

    @PostMapping
    public ResponseEntity<Void> recordLogin() {
        AuditEvent ae = new AuditEvent();
        ae.setWho(TenantContext.getUsername());
        ae.setWhat("login");
        ae.setEventTime(LocalDateTime.now());
        ae.setDetail(TenantContext.getUsername());

        Optional<String> orgId = TenantContext.getOrganisationId();
        if (orgId.isEmpty()) {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (auth instanceof JwtAuthenticationToken jwtAuth) {
                log.warn("Login audit: org_id claim missing from JWT. Claims present: {}. User: {}",
                    jwtAuth.getToken().getClaims().keySet(), ae.getWho());
            } else {
                log.warn("Login audit: no JWT in security context. Authentication type: {}. User: {}",
                    auth == null ? "null" : auth.getClass().getSimpleName(), ae.getWho());
            }
            throw new IllegalStateException("Organisation context is required for login audit");
        }

        ae.setOrganisationId(UUID.fromString(orgId.get()));
        auditRabbitTemplate.convertAndSend(ae);
        log.info("Recorded login for user {}", ae.getWho());
        return ResponseEntity.ok().build();
    }
}
