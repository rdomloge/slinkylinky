package com.domloge.slinkylinky.linkservice.entity.audit;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.rest.core.annotation.HandleAfterCreate;
import org.springframework.data.rest.core.annotation.HandleBeforeSave;
import org.springframework.data.rest.core.annotation.RepositoryEventHandler;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.linkservice.entity.DemandSite;
import com.domloge.slinkylinky.linkservice.repo.AuditRecordRepo;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
@RepositoryEventHandler({DemandSite.class})
public class DemandSiteAuditor {

    private AuditRecordRepo auditRecordRepo;

    private ObjectMapper objectMapper = new ObjectMapper();


    public DemandSiteAuditor() {
        objectMapper.registerModule(new JavaTimeModule());
        objectMapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        objectMapper.setSerializationInclusion(Include.NON_NULL);
    }

    @Autowired
    public void setAuditRecordRepo(AuditRecordRepo auditRecordRepo) {
        this.auditRecordRepo = auditRecordRepo;
    }

    @HandleBeforeSave
    public void handleBeforeSave(DemandSite demandSite) {
        AuditRecord auditRecord = new AuditRecord();
        auditRecord.setWho(demandSite.getUpdatedBy());
        auditRecord.setWhat("update demand site");
        common(auditRecord, demandSite);
    }

    @HandleAfterCreate
    public void handleAfterCreate(DemandSite demandSite) {
        AuditRecord auditRecord = new AuditRecord();
        auditRecord.setWho(demandSite.getCreatedBy());
        auditRecord.setWhat("create demand site");
        common(auditRecord, demandSite);
    }

    private void common(AuditRecord auditRecord, DemandSite demandSite) {
        auditRecord.setEventTime(LocalDateTime.now());
        auditRecord.setEntityId(demandSite.getId());
        auditRecord.setEntityType(DemandSite.class.getSimpleName());
        try {
            auditRecord.setDetail(objectMapper.writeValueAsString(demandSite));
        } catch (JsonProcessingException e) {
            log.error("Error writing to JSON..."+demandSite.toString(), e);
            auditRecord.setDetail("Err::"+demandSite.getClass().getSimpleName());
        }
        auditRecordRepo.save(auditRecord);
    }
}
