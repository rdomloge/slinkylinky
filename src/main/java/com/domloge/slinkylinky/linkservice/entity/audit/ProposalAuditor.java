package com.domloge.slinkylinky.linkservice.entity.audit;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.rest.core.annotation.HandleAfterCreate;
import org.springframework.data.rest.core.annotation.HandleBeforeSave;
import org.springframework.data.rest.core.annotation.RepositoryEventHandler;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.linkservice.entity.DemandSite;
import com.domloge.slinkylinky.linkservice.entity.Proposal;
import com.domloge.slinkylinky.linkservice.repo.AuditRecordRepo;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
@RepositoryEventHandler({Proposal.class})
public class ProposalAuditor {

    @Autowired
    private AuditRecordRepo auditRecordRepo;

    private ObjectMapper objectMapper = new ObjectMapper();


    public ProposalAuditor() {
        objectMapper.registerModule(new JavaTimeModule());
        objectMapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        objectMapper.setSerializationInclusion(Include.NON_NULL);
    }
    
    @HandleBeforeSave
    public void handleBeforeSave(Proposal proposal) {
        AuditRecord auditRecord = new AuditRecord();
        auditRecord.setWho(proposal.getUpdatedBy());
        auditRecord.setWhat("update proposal");
        common(auditRecord, proposal);
    }

    @HandleAfterCreate
    public void handleAfterCreate(Proposal proposal) {
        AuditRecord auditRecord = new AuditRecord();
        auditRecord.setWho(proposal.getCreatedBy());
        auditRecord.setWhat("create proposal");
        common(auditRecord, proposal);
    }

    private void common(AuditRecord ar, Proposal p) {
        ar.setEntityId(p.getId());
        ar.setEntityType(p.getClass().getSimpleName());
        try {
            ar.setDetail(objectMapper.writeValueAsString(p));
        } catch (Exception e) {
            log.error("Failed to serialize proposal", e);
        }
        ar.setEventTime(LocalDateTime.now());
        auditRecordRepo.save(ar);
    }
}
