package com.domloge.slinkylinky.linkservice.postprocessing;

import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.rest.core.annotation.HandleAfterSave;
import org.springframework.data.rest.core.annotation.RepositoryEventHandler;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.linkservice.entity.Proposal;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
@RepositoryEventHandler(Proposal.class)
public class EventDispatcher {

    @Autowired
    private AmqpTemplate proposalsRabbitTemplate;

    enum ProposalEventType {
        CREATED, UPDATED, DELETED
    }

    @Getter
    @Setter
    @AllArgsConstructor
    class ProposalEvent {

        private ProposalEventType type;
        private Proposal proposal;
    }
 
    @HandleAfterSave
    public void handleAfterSave(Proposal proposal) throws JsonProcessingException {
        log.info("Proposal {} has been saved", proposal.getId());
        ObjectMapper mapper = new ObjectMapper();
        mapper.registerModule(new JavaTimeModule());
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        mapper.setSerializationInclusion(Include.NON_NULL);

        proposalsRabbitTemplate.convertAndSend(new ProposalEvent(ProposalEventType.UPDATED, proposal));
    }
}
