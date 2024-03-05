package com.domloge.slinkylinky.woocommerce.sync;

import java.io.IOException;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.events.ProposalUpdateEvent;
import com.domloge.slinkylinky.woocommerce.dto.DemandDto;
import com.domloge.slinkylinky.woocommerce.dto.proposal.PaidLink;
import com.domloge.slinkylinky.woocommerce.dto.proposal.PaidLinksResponseWrapper;
import com.domloge.slinkylinky.woocommerce.dto.proposal.ProposalFlagsResponse;
import com.domloge.slinkylinky.woocommerce.entity.OrderEntity;
import com.domloge.slinkylinky.woocommerce.entity.OrderLineItemEntity;
import com.domloge.slinkylinky.woocommerce.repo.OrderLineItemRepo;
import com.domloge.slinkylinky.woocommerce.repo.OrderRepo;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class ProposalEventProcessor {

    @Value("${linkservice_url}")
    private String linkService_base;

    @Autowired
    private HttpUtils httpUtils;

    private ObjectMapper mapper = new ObjectMapper();

    @Autowired
    private OrderLineItemRepo lineItemRepo;

    @Autowired
    private OrderRepo orderRepo;

    @Autowired
    private CommercePortalFacade commercePortalFacade;

    @Autowired
    private LinkDetailsSender linkDetailsSender;
    


    public ProposalEventProcessor() {
        mapper.registerModule(new JavaTimeModule());
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        mapper.setSerializationInclusion(Include.NON_NULL);
        mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
    }

    public void processProposalCreatedEvent(ProposalUpdateEvent event) throws IOException {
        log.info("Proposal created: " + event.getProposalId());
        // fetch the demand IDs and see if we need to track this proposal
        String url = linkService_base + "/proposals/" + event.getProposalId() + "/paidLinks";
        String response = httpUtils.get(url);
        if(null == response) {
            log.error("Error fetching paid links for proposal {}", event.getProposalId());
            return;
        }
        PaidLinksResponseWrapper mo = mapper.readValue(response, PaidLinksResponseWrapper.class);
        List<PaidLink> paidlinks = mo.get_embedded().getPaidlinks();
        for (PaidLink pl : paidlinks) {
            // check if we are tracking this demand
            String href = pl.get_links().getDemand().getHref(); //http://localhost:8080/.rest/paidlinks/1252/demand{?projection}
            // remove the section in braces
            href = href.substring(0, href.indexOf("{"));
            DemandDto demand = mapper.readValue(httpUtils.get(href), DemandDto.class);
            Optional<OrderLineItemEntity> lineItemOptional = lineItemRepo.findByDemandId(demand.getId());
            if(lineItemOptional.isPresent()) {
                OrderLineItemEntity li = lineItemOptional.get();
                //  we are tracking this demand, so store proposal ID to the line item and save it
                log.info("A proposal {} containing demand {} has been created that is tracking a line item of a LinkSync order", 
                    event.getProposalId(), li.getDemandId());
                li.setLinkedProposalId(event.getProposalId());
                lineItemRepo.save(li);
            }
            else log.debug("Demand {} is not linked to a line item of a LinkSync order", demand.getId());
        }
    }
    

    @Transactional
    public void processProposalUpdatedEvent(ProposalUpdateEvent event) throws IOException {
        // see if we are tracking this proposal and if we are and the proposal is live, set the order to complete
        OrderLineItemEntity[] orderLineItemsInProposal = lineItemRepo.findByLinkedProposalId(event.getProposalId());
        if(orderLineItemsInProposal.length < 1) {
            log.debug("Proposal " + event.getProposalId() + " is not linked to a line item of a LinkSync order");
            return;
        }
        else log.debug("Proposal {} is linked to {} line item(s) of a LinkSync order", event.getProposalId(), orderLineItemsInProposal.length);

        ProposalFlagsResponse pfr = getProposal(event);
        if(null == pfr) return;

        for(OrderLineItemEntity olie : orderLineItemsInProposal) {
            
            if(pfr.isBlogLive()) {
                log.info("Proposal {} is now live, setting line item {} to complete", event.getProposalId(), olie.getId());
                olie.setProposalComplete(true);
                lineItemRepo.save(olie);

                // have to see if all the demands of the same order are complete and update LinkSync if they are
                OrderEntity linkedOrder = orderRepo.findByLineItems_demandIdEquals(olie.getDemandId());
                List<OrderLineItemEntity> incompleteLineItems = linkedOrder.getLineItems()
                    .stream()
                    .filter(li ->  ! li.isProposalComplete() )
                    .collect(Collectors.toList());
                
                if(incompleteLineItems.isEmpty()) {
                    log.info("All line items of order {} are complete, setting order to complete", linkedOrder.getId());
                    // set the order to complete in LinkSync
                    String responseJson = commercePortalFacade.completeOrder(linkedOrder.getExternalId());
                    log.info("Order {} (order {} in LinkSync) marked as complete: {}", linkedOrder.getId(), linkedOrder.getExternalId(), responseJson);
                    // send the link details email
                    linkDetailsSender.send(linkedOrder);
                }
                else {
                    log.debug("Order {} still has {} incomplete line items", linkedOrder.getId(), incompleteLineItems.size());
                }
            }
            else {
                
                if(olie.isProposalComplete()) {
                    log.info("Proposal {} is no longer live, setting line item {} to incomplete", event.getProposalId(), olie.getId());
                    olie.setProposalComplete(false);
                    lineItemRepo.save(olie);
                }
                else {
                    log.debug("Proposal {} is still not live", event.getProposalId());
                }
            }
        }
    }

    private ProposalFlagsResponse getProposal(ProposalUpdateEvent event) throws IOException {
        String url = linkService_base + "/proposals/" + event.getProposalId();
        String response = httpUtils.get(url);
        if(null == response) {
            log.error("Error fetching proposal {}", event.getProposalId());
            return null;
        }
        ProposalFlagsResponse pfr = mapper.readValue(response, ProposalFlagsResponse.class);
        return pfr;
    }
}
