package com.domloge.slinkylinky.linkservice.entity.audit;

import java.time.LocalDateTime;
import java.util.UUID;

import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.rest.core.annotation.HandleAfterCreate;
import org.springframework.data.rest.core.annotation.HandleBeforeSave;
import org.springframework.data.rest.core.annotation.RepositoryEventHandler;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.common.TenantContext;
import com.domloge.slinkylinky.events.AuditEvent;
import com.domloge.slinkylinky.linkservice.entity.Supplier;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
@RepositoryEventHandler({Supplier.class})
public class SupplierAuditor {
    
    @Autowired
    private AmqpTemplate auditRabbitTemplate;

    private ObjectMapper objectMapper = new ObjectMapper();


    public SupplierAuditor() {
        objectMapper.registerModule(new JavaTimeModule());
        objectMapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        objectMapper.setSerializationInclusion(Include.NON_NULL);
    }

    @HandleBeforeSave
    public void handleBeforeSave(Supplier supplier) {
        AuditEvent auditEvent = new AuditEvent();
        auditEvent.setWho(supplier.getUpdatedBy());
        auditEvent.setWhat("update supplier");
        common(auditEvent, supplier);
    }

    @HandleAfterCreate
    public void handleAfterCreate(Supplier supplier) {
        AuditEvent auditEvent = new AuditEvent();
        auditEvent.setWho(supplier.getCreatedBy());
        auditEvent.setWhat("create supplier");
        common(auditEvent, supplier);
    }

    private void common(AuditEvent ae, Supplier s) {
        ae.setEntityId(String.valueOf(s.getId()));
        ae.setEntityType(s.getClass().getSimpleName());
        try {
            ae.setDetail(objectMapper.writeValueAsString(s));
        } catch (Exception e) {
            log.error("Failed to serialize supplier", e);
        }
        ae.setEventTime(LocalDateTime.now());
        TenantContext.getOrganisationId()
            .map(UUID::fromString)
            .ifPresent(ae::setOrganisationId);
        auditRabbitTemplate.convertAndSend(ae);
        log.info("Sent audit record {}", ae);
    }
}
