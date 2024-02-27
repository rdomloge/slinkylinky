package com.domloge.slinkylinky.woocommerce.sync;

import java.io.IOException;
import java.io.UnsupportedEncodingException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.MessagingException;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.events.ProposalUpdateEvent;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class ProposalEventReceiver {

    @Autowired
    private ObjectMapper mapper;

    @Autowired
    private ProposalEventProcessor processor;

    
    public void receiveMessage(String message) throws MessagingException, IOException {
        log.info("Received <" + message + ">");
        
        ProposalUpdateEvent event = mapper.readValue(message, ProposalUpdateEvent.class);
        switch(event.getType()) {
            case CREATED:
                log.info("Proposal created: " + event.getProposalId());
                // fetch the demand IDs and see if we need to track this proposal
                try {
                    processor.processProposalCreatedEvent(event);
                } 
                catch (IOException e) {
                    log.error("Error processing proposal created event", e);
                }
                break;
            case UPDATED:
                log.info("Proposal updated: " + event.getProposalId());
                // see if we are tracking this proposal and if we are and the proposal is live, set the order to complete
                processor.processProposalUpdatedEvent(event);
                break;
            case DELETED:
                log.info("Proposal deleted: " + event.getProposalId());
                break;
            default:
                log.error("Unknown event type: " + event.getType());
        }
    }

    public void receiveMessage(byte[] message) throws MessagingException, IOException {
        try {
            receiveMessage(new String(message, "utf-8"));
        } 
        catch (UnsupportedEncodingException e) {
            receiveMessage(new String(message));
        }
    }   
}
