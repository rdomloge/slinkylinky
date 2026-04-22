package com.domloge.slinkylinky.linkservice.entity.audit;

import java.time.LocalDateTime;

import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.rest.core.annotation.HandleAfterCreate;
import org.springframework.data.rest.core.annotation.HandleBeforeSave;
import org.springframework.data.rest.core.annotation.RepositoryEventHandler;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.events.AuditEvent;
import com.domloge.slinkylinky.linkservice.entity.BlackListedSupplier;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
@RepositoryEventHandler({BlackListedSupplier.class})
public class BlackListedSupplierAuditor {
    
    private ObjectMapper objectMapper = new ObjectMapper();

    @Autowired
    private AmqpTemplate auditRabbitTemplate;

    public BlackListedSupplierAuditor() {
        objectMapper.registerModule(new JavaTimeModule());
        objectMapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        objectMapper.setSerializationInclusion(Include.NON_NULL);
    }

    @HandleBeforeSave
    public void handleBeforeSave(BlackListedSupplier supplier) {
        throw new UnsupportedOperationException("Cannot update a blacklisted supplier");
    }

    @HandleAfterCreate
    public void handleAfterCreate(BlackListedSupplier supplier) {
        AuditEvent auditEvent = new AuditEvent();
        auditEvent.setWho(supplier.getCreatedBy());
        auditEvent.setWhat("create blacklisted supplier");
        common(auditEvent, supplier);
    }

    private void common(AuditEvent auditEvent, BlackListedSupplier supplier) {
        auditEvent.setEventTime(LocalDateTime.now());
        auditEvent.setEntityId(String.valueOf(supplier.getId()));
        auditEvent.setEntityType(BlackListedSupplier.class.getSimpleName());
        try {
            auditEvent.setDetail(objectMapper.writeValueAsString(supplier));
        } catch (JsonProcessingException e) {
            log.error("Could not write BlackListedSupplier to JSON", e);
            auditEvent.setDetail("Error writing to JSON..."+supplier.toString());
        }
        auditRabbitTemplate.convertAndSend(auditEvent);
        log.info("Sent audit record {}", auditEvent);
    }
}
