package com.domloge.slinkylinky.woocommerce.sync;

import java.io.IOException;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.woocommerce.dto.BillingDto;
import com.domloge.slinkylinky.woocommerce.dto.OrderDto;
import com.domloge.slinkylinky.woocommerce.dto.ShippingDto;
import com.domloge.slinkylinky.woocommerce.entity.OrderEntity;
import com.domloge.slinkylinky.woocommerce.entity.OrderLineItemEntity;
import com.domloge.slinkylinky.woocommerce.sync.dto.Proposal;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class LinkResolver {
    
    @Value("${linkservice_url}")
    private String linkService_base;

    @Autowired
    private HttpUtils httpUtils;

    private ObjectMapper mapper = new ObjectMapper();

    public LinkResolver() {
        mapper.registerModule(new JavaTimeModule());
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        mapper.setSerializationInclusion(Include.NON_NULL);
        mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
    }

    

    public void add(OrderLineItemEntity lineItem, Map<DemandLite, LinkDetails> map) {
        Long demandId = lineItem.getDemandId();
        Long linkedProposalId = lineItem.getLinkedProposalId();
        try {
            Proposal proposal = getProposal(linkedProposalId);
            
            Optional<DemandLite> dl = proposal.getPaidLinks().stream()
                .filter(pl -> pl.getDemand().getId() == demandId)       // find the specific demand for this line item
                .findFirst()                                            // get the first one (there should only be one anyway)
                .map(pl -> {                                            // convert to a DemandLite
                    DemandLite demandLite = new DemandLite();
                    demandLite.setAnchorText(pl.getDemand().getAnchorText());
                    demandLite.setUrl(pl.getDemand().getUrl());
                    demandLite.setDaNeeded(pl.getDemand().getDaNeeded());
                    demandLite.setWordCount(lineItem.getWordCount());
                    return demandLite;
                });
            if(dl.isEmpty()) { throw new RuntimeException("Proposal does not contain demand"); }

            LinkDetails ld = new LinkDetails();
            ld.setLiveLinkTitle(proposal.getLiveLinkTitle());
            ld.setLiveLinkUrl(proposal.getLiveLinkUrl());
            ld.setSupplierDa(proposal.getPaidLinks().get(0).getSupplier().getDa());
            ld.setPrice(lineItem.getPrice());
            ld.setTax(lineItem.getTax());
            ld.setTotal(lineItem.getTax() + lineItem.getPrice());
            map.put(dl.get(), ld);
        } 
        catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    private Proposal getProposal(Long linkedProposalId) throws IOException {
        String url = linkService_base + "/proposals/" + linkedProposalId + "?projection=fullProposal";
        String response = httpUtils.get(url);
        if(null == response) {
            log.error("Error fetching proposal {}", linkedProposalId);
            throw new RuntimeException("Could not find proposal " + linkedProposalId);
        }
        return mapper.readValue(response, Proposal.class);
    }

    
}
