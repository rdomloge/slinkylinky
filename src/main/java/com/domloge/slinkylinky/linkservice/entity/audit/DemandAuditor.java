package com.domloge.slinkylinky.linkservice.entity.audit;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.rest.core.annotation.HandleAfterCreate;
import org.springframework.data.rest.core.annotation.HandleBeforeSave;
import org.springframework.data.rest.core.annotation.RepositoryEventHandler;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.linkservice.entity.Demand;
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
public class DemandAuditor {
 
    private ObjectMapper objectMapper = new ObjectMapper();

    @Autowired
    private AuditRecordRepo auditRecordRepo;

    
    public DemandAuditor() {
        objectMapper.registerModule(new JavaTimeModule());
        objectMapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        objectMapper.setSerializationInclusion(Include.NON_NULL);
    }

    @HandleBeforeSave
    public void handleBeforeSave(Demand demand) {
        AuditRecord auditRecord = new AuditRecord();
        auditRecord.setWho(demand.getUpdatedBy());
        auditRecord.setWhat("update demand");
        common(auditRecord, demand);
    }

    @HandleAfterCreate
    public void handleAfterCreate(Demand demand) {
        AuditRecord auditRecord = new AuditRecord();
        auditRecord.setWho(demand.getCreatedBy());
        auditRecord.setWhat("create demand");
        common(auditRecord, demand);
    }

    private void common(AuditRecord auditRecord, Demand demand) {
        auditRecord.setEventTime(LocalDateTime.now());
        auditRecord.setEntityId(demand.getId());
        auditRecord.setEntityType(Demand.class.getSimpleName());
        try {
            auditRecord.setDetail(objectMapper.writeValueAsString(demand));
        } catch (JsonProcessingException e) {
            log.error("Could not write Demand to JSON", e);
            auditRecord.setDetail("Error writing to JSON..."+demand.toString());
        }
        auditRecordRepo.save(auditRecord);
    }
}
