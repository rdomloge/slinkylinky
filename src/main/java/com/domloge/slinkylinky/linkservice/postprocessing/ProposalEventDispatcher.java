package com.domloge.slinkylinky.linkservice.postprocessing;

import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.rest.core.annotation.HandleAfterCreate;
import org.springframework.data.rest.core.annotation.HandleAfterDelete;
import org.springframework.data.rest.core.annotation.HandleAfterSave;
import org.springframework.data.rest.core.annotation.RepositoryEventHandler;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.events.ProposalUpdateEvent;
import com.domloge.slinkylinky.events.ProposalUpdateEvent.ProposalEventType;
import com.domloge.slinkylinky.linkservice.entity.Proposal;
import com.domloge.slinkylinky.linkservice.entity.Supplier;
import com.fasterxml.jackson.core.JsonProcessingException;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
@RepositoryEventHandler(Proposal.class)
public class ProposalEventDispatcher {

    @Autowired
    private AmqpTemplate proposalsRabbitTemplate;

 
    @HandleAfterSave
    public void handleAfterSave(Proposal proposal) throws JsonProcessingException {
        log.info("Proposal {} has been updated", proposal.getId());
        
        doCommon(proposal, new ProposalUpdateEvent(ProposalEventType.UPDATED));
    }

    @HandleAfterDelete
    public void handleAfterDelete(Proposal proposal) throws JsonProcessingException {
        log.info("Proposal {} has been deleted", proposal.getId());
        
        doCommon(proposal, new ProposalUpdateEvent(ProposalEventType.DELETED));
    }

    @HandleAfterCreate
    public void handleAfterCreate(Proposal proposal) throws JsonProcessingException {
        log.info("Proposal {} has been created", proposal.getId());
        
        doCommon(proposal, new ProposalUpdateEvent(ProposalEventType.CREATED));
    }

    private void doCommon(Proposal proposal, ProposalUpdateEvent event) {
        Supplier supplier = proposal.getPaidLinks().get(0).getSupplier();
        event.setProposalDetails(proposal.getArticle(), proposal.getId());
        event.setSupplierDetails(supplier.getName(), supplier.getEmail(), supplier.getWebsite(), supplier.getWeWriteFee(), 
            supplier.getWeWriteFeeCurrency(), supplier.isThirdParty());
        proposalsRabbitTemplate.convertAndSend(event);
    }
}
