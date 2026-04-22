package com.domloge.slinkylinky.linkservice.entity.audit;

import java.time.LocalDateTime;

import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.rest.core.annotation.HandleAfterCreate;
import org.springframework.data.rest.core.annotation.HandleAfterDelete;
import org.springframework.data.rest.core.annotation.HandleBeforeSave;
import org.springframework.data.rest.core.annotation.RepositoryEventHandler;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.events.AuditEvent;
import com.domloge.slinkylinky.linkservice.entity.Proposal;
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
    private AmqpTemplate auditRabbitTemplate;

    private ObjectMapper objectMapper = new ObjectMapper();


    public ProposalAuditor() {
        objectMapper.registerModule(new JavaTimeModule());
        objectMapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        objectMapper.setSerializationInclusion(Include.NON_NULL);
    }

    @HandleAfterDelete
    public void handleAfterDelete(Proposal proposal) {
        AuditEvent auditEvent = new AuditEvent();
        auditEvent.setWho(proposal.getUpdatedBy());
        auditEvent.setWhat("delete proposal");
        common(auditEvent, proposal);
    }

    @HandleBeforeSave
    public void handleBeforeSave(Proposal proposal) {
        AuditEvent auditEvent = new AuditEvent();
        auditEvent.setWho(proposal.getUpdatedBy());
        auditEvent.setWhat("update proposal");
        common(auditEvent, proposal);
    }

    @HandleAfterCreate
    public void handleAfterCreate(Proposal proposal) {
        AuditEvent auditEvent = new AuditEvent();
        auditEvent.setWho(proposal.getCreatedBy());
        auditEvent.setWhat("create proposal");
        common(auditEvent, proposal);
    }

    private void common(AuditEvent ae, Proposal p) {
        ae.setEntityId(String.valueOf(p.getId()));
        ae.setEntityType(p.getClass().getSimpleName());
        ae.setOrganisationId(p.getOrganisationId());
        try {
            ae.setDetail(objectMapper.writeValueAsString(p));
        } catch (Exception e) {
            log.error("Failed to serialize proposal", e);
        }
        ae.setEventTime(LocalDateTime.now());
        auditRabbitTemplate.convertAndSend(ae);
        log.info("Sent audit record {}", ae);
    }
}
