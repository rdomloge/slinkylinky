package com.domloge.slinkylinky.linkservice.postprocessing;

import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.rest.core.annotation.HandleAfterCreate;
import org.springframework.data.rest.core.annotation.RepositoryEventHandler;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.events.SupplierEvent;
import com.domloge.slinkylinky.events.SupplierEvent.EventType;
import com.domloge.slinkylinky.linkservice.entity.Supplier;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
@RepositoryEventHandler(Supplier.class)
public class SupplierEventDispatcher {
    
    @Autowired
    private AmqpTemplate supplierRabbitTemplate;

    
 
    @HandleAfterCreate
    public void handleAfterCreate(Supplier s) throws JsonProcessingException {
        log.info("Supplier {} has been saved", s.getId());
        ObjectMapper mapper = new ObjectMapper();
        mapper.registerModule(new JavaTimeModule());
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        mapper.setSerializationInclusion(Include.NON_NULL);

        SupplierEvent event = SupplierEvent.buildForCreated(EventType.CREATED, s.getDomain(), s.getId());
        supplierRabbitTemplate.convertAndSend(event);
    }
}
