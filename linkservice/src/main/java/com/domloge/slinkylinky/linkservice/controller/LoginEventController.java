package com.domloge.slinkylinky.linkservice.controller;

import java.time.LocalDateTime;
import java.util.UUID;

import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
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
        ae.setOrganisationId(UUID.fromString(TenantContext.getOrganisationId()
            .orElseThrow(() -> new IllegalStateException("Organisation context is required for login audit"))));
        auditRabbitTemplate.convertAndSend(ae);
        log.info("Recorded login for user {}", ae.getWho());
        return ResponseEntity.ok().build();
    }
}
