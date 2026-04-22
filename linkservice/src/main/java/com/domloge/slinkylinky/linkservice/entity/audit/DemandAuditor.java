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
import com.domloge.slinkylinky.linkservice.entity.Demand;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
@RepositoryEventHandler({Demand.class})
public class DemandAuditor {
 
    private ObjectMapper objectMapper = new ObjectMapper();

    @Autowired
    private AmqpTemplate auditRabbitTemplate;

    
    public DemandAuditor() {
        objectMapper.registerModule(new JavaTimeModule());
        objectMapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        objectMapper.setSerializationInclusion(Include.NON_NULL);
    }

    @HandleBeforeSave
    public void handleBeforeSave(Demand demand) {
        AuditEvent auditEvent = new AuditEvent();
        auditEvent.setWho(demand.getUpdatedBy());
        auditEvent.setWhat("update demand");
        common(auditEvent, demand);
    }

    @HandleAfterCreate
    public void handleAfterCreate(Demand demand) {
        AuditEvent auditEvent = new AuditEvent();
        auditEvent.setWho(demand.getCreatedBy());
        auditEvent.setWhat("create demand");
        common(auditEvent, demand);
    }

    @HandleAfterDelete
    public void handleAfterDelete(Demand demand) {
        AuditEvent auditEvent = new AuditEvent();
        auditEvent.setWho(demand.getUpdatedBy());
        auditEvent.setWhat("delete demand");
        common(auditEvent, demand);
    }

    private void common(AuditEvent auditEvent, Demand demand) {
        auditEvent.setEventTime(LocalDateTime.now());
        auditEvent.setEntityId(String.valueOf(demand.getId()));
        auditEvent.setEntityType(Demand.class.getSimpleName());
        auditEvent.setOrganisationId(demand.getOrganisationId());
        try {
            auditEvent.setDetail(objectMapper.writeValueAsString(demand));
        } catch (JsonProcessingException e) {
            log.error("Could not write Demand to JSON", e);
            auditEvent.setDetail("Error writing to JSON..."+demand.toString());
        }
        auditRabbitTemplate.convertAndSend(auditEvent);
        log.info("Sent audit record {}", auditEvent);
    }
}
