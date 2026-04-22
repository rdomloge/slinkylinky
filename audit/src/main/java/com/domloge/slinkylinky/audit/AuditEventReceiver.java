package com.domloge.slinkylinky.audit;

import java.io.UnsupportedEncodingException;

import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.MessagingException;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.events.AuditEvent;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;
import org.springframework.validation.BeanPropertyBindingResult;

@Slf4j
@Component
public class AuditEventReceiver {

    private ObjectMapper mapper;

    @Autowired
    private AuditRecordRepo repo;

    @Autowired
    private AuditValidator validator;

    @PostConstruct
    public void init() {
        mapper = new ObjectMapper();
        mapper.registerModule(new JavaTimeModule());
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        mapper.setSerializationInclusion(Include.NON_NULL);
    }

    public void receiveMessage(String message) {
        try {
            AuditEvent auditEvent = mapper.readValue(message, AuditEvent.class);
            AuditRecord auditRecord = new AuditRecord();
            auditRecord.setWho(auditEvent.getWho());
            auditRecord.setWhat(auditEvent.getWhat());
            auditRecord.setEntityType(auditEvent.getEntityType());
            auditRecord.setEntityId(auditEvent.getEntityId());
            auditRecord.setEventTime(auditEvent.getEventTime());
            auditRecord.setDetail(auditEvent.getDetail());
            auditRecord.setOrganisationId(auditEvent.getOrganisationId());

            BeanPropertyBindingResult errors = new BeanPropertyBindingResult(auditRecord, "auditRecord");
            validator.validate(auditRecord, errors);
            if (errors.hasErrors()) {
                log.error("Rejecting invalid audit record — validation errors: {} — message: {}",
                    errors.getAllErrors(), message);
                return;
            }
            repo.save(auditRecord);
            log.debug("Received audit record: {}", message);
        } catch (JsonProcessingException e) {
            log.error("Failed to parse message: " + message, e);
        }
    }

    @RabbitListener(queues = "${rabbitmq.audit.queue}")
    public void receiveMessage(byte[] message) throws MessagingException {
        try {
            receiveMessage(new String(message, "utf-8"));
        } 
        catch (UnsupportedEncodingException e) {
            receiveMessage(new String(message));
        }
    }  
}
