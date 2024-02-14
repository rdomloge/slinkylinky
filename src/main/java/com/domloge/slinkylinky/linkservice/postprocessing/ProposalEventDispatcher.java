package com.domloge.slinkylinky.linkservice.postprocessing;

import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.rest.core.annotation.HandleAfterSave;
import org.springframework.data.rest.core.annotation.RepositoryEventHandler;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.events.ProposalUpdateEvent;
import com.domloge.slinkylinky.events.ProposalUpdateEvent.ProposalEventType;
import com.domloge.slinkylinky.linkservice.entity.Proposal;
import com.domloge.slinkylinky.linkservice.entity.Supplier;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
@RepositoryEventHandler(Proposal.class)
public class ProposalEventDispatcher {

    @Autowired
    private AmqpTemplate proposalsRabbitTemplate;

    
 
    @HandleAfterSave
    public void handleAfterSave(Proposal proposal) throws JsonProcessingException {
        log.info("Proposal {} has been saved", proposal.getId());
        ObjectMapper mapper = new ObjectMapper();
        mapper.registerModule(new JavaTimeModule());
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        mapper.setSerializationInclusion(Include.NON_NULL);

        Supplier supplier = proposal.getPaidLinks().get(0).getSupplier();
        ProposalUpdateEvent event = new ProposalUpdateEvent(ProposalEventType.UPDATED);
        event.setProposalDetails(proposal.getArticle(), proposal.getId());
        event.setSupplierDetails(supplier.getName(), supplier.getEmail(), supplier.getWebsite(), supplier.getWeWriteFee(), 
            supplier.getWeWriteFeeCurrency(), supplier.isThirdParty());
        proposalsRabbitTemplate.convertAndSend(event);
    }
}
