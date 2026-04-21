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
import com.domloge.slinkylinky.linkservice.entity.audit.AuditRecord;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/.rest/loginEvent")
public class LoginEventController {

    @Autowired
    private AmqpTemplate auditRabbitTemplate;

    @PostMapping
    public ResponseEntity<Void> recordLogin() {
        AuditRecord ar = new AuditRecord();
        ar.setWho(TenantContext.getUsername());
        ar.setWhat("login");
        ar.setEventTime(LocalDateTime.now());
        ar.setDetail(TenantContext.getUsername());
        TenantContext.getOrganisationId()
            .map(UUID::fromString)
            .ifPresent(ar::setOrganisationId);
        auditRabbitTemplate.convertAndSend(ar);
        log.info("Recorded login for user {}", ar.getWho());
        return ResponseEntity.ok().build();
    }
}
