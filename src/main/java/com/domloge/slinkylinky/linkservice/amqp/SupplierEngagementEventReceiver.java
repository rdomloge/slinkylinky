package com.domloge.slinkylinky.linkservice.amqp;

import java.io.UnsupportedEncodingException;
import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.events.SupplierEngagementEvent;
import com.domloge.slinkylinky.linkservice.entity.Proposal;
import com.domloge.slinkylinky.linkservice.repo.ProposalRepo;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class SupplierEngagementEventReceiver {

    @Autowired
    private ProposalRepo proposalRepo;

    private ObjectMapper mapper = new ObjectMapper();

    public SupplierEngagementEventReceiver() {
        mapper.registerModule(new JavaTimeModule());
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        mapper.setSerializationInclusion(Include.NON_NULL);
    }

    public void receiveMessage(String message)  {
        log.info("Received <" + message + ">");
        
        try {
            SupplierEngagementEvent event = mapper.readValue(message, SupplierEngagementEvent.class);
            Proposal proposal = proposalRepo.findById(event.getProposalId()).orElse(null);
            if(proposal == null) {
                log.error("Proposal {} not found", event.getProposalId());
                return;
            }

            switch (event.getType()) {
                case PROPOSAL_SENT:
                    handleProposalSent(event, proposal);
                    break;
                case RECEIVED_RESPONSE:
                    handleSupplierResponse(event, proposal);
                    break;
                default:
                    break;
            }
        } 
        catch (JsonProcessingException e) {
            log.error("Error processing message", e);
        }
    }

    private void handleProposalSent(SupplierEngagementEvent event, Proposal proposal) {
        proposal.setProposalSent(true);
        proposal.setDateSentToSupplier(LocalDateTime.now());
        proposalRepo.save(proposal);
    }

    private void handleSupplierResponse(SupplierEngagementEvent event, Proposal proposal) {

        if(event.getResponse() == SupplierEngagementEvent.Response.ACCEPTED) {
            proposal.setDateAcceptedBySupplier(LocalDateTime.now());
            proposal.setProposalAccepted(true);

            if(event.isInvoiceUploaded()) {
                log.info("Invoice uploaded");
                // set invoice received flag to true
                proposal.setInvoiceReceived(true);
                proposal.setDateInvoiceReceived(LocalDateTime.now());
            }
            else {
                log.info("Invoice not uploaded");
            }
            proposal.setBlogLive(true);
            proposal.setDateBlogLive(LocalDateTime.now());
            proposal.setLiveLinkTitle(event.getBlogTitle());
            proposal.setLiveLinkUrl(event.getBlogUrl());
            proposalRepo.save(proposal);
        }
    }

    public void receiveMessage(byte[] message)  {
        try {
            receiveMessage(new String(message, "utf-8"));
        } 
        catch (UnsupportedEncodingException e) {
            receiveMessage(new String(message));
        }
    }
}
