package com.domloge.slinkylinky.linkservice.entity.audit;

import java.time.LocalDateTime;

import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.rest.core.annotation.HandleAfterCreate;
import org.springframework.data.rest.core.annotation.HandleBeforeSave;
import org.springframework.data.rest.core.annotation.RepositoryEventHandler;
import org.springframework.stereotype.Component;

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
        AuditRecord auditRecord = new AuditRecord();
        auditRecord.setWho(supplier.getCreatedBy());
        auditRecord.setWhat("create blacklisted supplier");
        common(auditRecord, supplier);
    }

    private void common(AuditRecord auditRecord, BlackListedSupplier supplier) {
        auditRecord.setEventTime(LocalDateTime.now());
        auditRecord.setEntityId(supplier.getId());
        auditRecord.setEntityType(BlackListedSupplier.class.getSimpleName());
        try {
            auditRecord.setDetail(objectMapper.writeValueAsString(supplier));
        } catch (JsonProcessingException e) {
            log.error("Could not write Demand to JSON", e);
            auditRecord.setDetail("Error writing to JSON..."+supplier.toString());
        }
        auditRabbitTemplate.convertAndSend(auditRecord);
        log.info("Sent audit record {}", auditRecord);
    }
}
