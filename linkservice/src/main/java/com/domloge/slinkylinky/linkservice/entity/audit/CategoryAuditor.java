package com.domloge.slinkylinky.linkservice.entity.audit;

import java.time.LocalDateTime;

import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.rest.core.annotation.HandleAfterCreate;
import org.springframework.data.rest.core.annotation.HandleBeforeSave;
import org.springframework.data.rest.core.annotation.RepositoryEventHandler;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.events.AuditEvent;
import com.domloge.slinkylinky.linkservice.entity.Category;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
@RepositoryEventHandler({Category.class})
public class CategoryAuditor {
    
    private ObjectMapper objectMapper = new ObjectMapper();

    @Autowired
    private AmqpTemplate auditRabbitTemplate;

    public CategoryAuditor() {
        objectMapper.registerModule(new JavaTimeModule());
        objectMapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        objectMapper.setSerializationInclusion(Include.NON_NULL);
    }

    @HandleBeforeSave
    public void handleBeforeSave(Category category) {
        AuditEvent auditEvent = new AuditEvent();
        auditEvent.setWho(category.getUpdatedBy());
        auditEvent.setWhat("update category");
        common(auditEvent, category);
    }

    @HandleAfterCreate
    public void handleAfterCreate(Category category) {
        AuditEvent auditEvent = new AuditEvent();
        auditEvent.setWho(category.getCreatedBy());
        auditEvent.setWhat("create category");
        common(auditEvent, category);
    }

    private void common(AuditEvent auditEvent, Category category) {
        auditEvent.setEventTime(LocalDateTime.now());
        auditEvent.setEntityId(String.valueOf(category.getId()));
        auditEvent.setEntityType(Category.class.getSimpleName());
        try {
            auditEvent.setDetail(objectMapper.writeValueAsString(category));
        } catch (JsonProcessingException e) {
            log.error("Could not write Category to JSON", e);
            auditEvent.setDetail("Error writing to JSON..."+category.toString());
        }
        auditRabbitTemplate.convertAndSend(auditEvent);
        log.info("Sent audit record {}", auditEvent);
    }
}
