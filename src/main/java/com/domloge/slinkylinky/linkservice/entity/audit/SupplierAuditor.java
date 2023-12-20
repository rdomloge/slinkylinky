package com.domloge.slinkylinky.linkservice.entity.audit;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.rest.core.annotation.HandleAfterCreate;
import org.springframework.data.rest.core.annotation.HandleBeforeSave;
import org.springframework.data.rest.core.annotation.RepositoryEventHandler;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.linkservice.entity.Supplier;
import com.domloge.slinkylinky.linkservice.repo.AuditRecordRepo;
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
    private AuditRecordRepo auditRecordRepo;

    private ObjectMapper objectMapper = new ObjectMapper();


    public SupplierAuditor() {
        objectMapper.registerModule(new JavaTimeModule());
        objectMapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        objectMapper.setSerializationInclusion(Include.NON_NULL);
    }

    @HandleBeforeSave
    public void handleBeforeSave(Supplier supplier) {
        AuditRecord auditRecord = new AuditRecord();
        auditRecord.setWho(supplier.getUpdatedBy());
        auditRecord.setWhat("update supplier");
        common(auditRecord, supplier);
    }

    @HandleAfterCreate
    public void handleAfterCreate(Supplier supplier) {
        AuditRecord auditRecord = new AuditRecord();
        auditRecord.setWho(supplier.getCreatedBy());
        auditRecord.setWhat("create supplier");
        common(auditRecord, supplier);
    }

    private void common(AuditRecord ar, Supplier s) {
        ar.setEntityId(s.getId());
        ar.setEntityType(s.getClass().getSimpleName());
        try {
            ar.setDetail(objectMapper.writeValueAsString(s));
        } catch (Exception e) {
            log.error("Failed to serialize supplier", e);
        }
        ar.setEventTime(LocalDateTime.now());
        auditRecordRepo.save(ar);
    }
}
