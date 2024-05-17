package com.domloge.slinkylinky.woocommerce.entity;

import org.springframework.data.rest.core.config.Projection;

@Projection(name="fullLineItem", types = {OrderLineItemEntity.class})
public interface OrderLineItemProjection {

    long getId();
    long getDemandId();
    Long getLinkedProposalId();
    boolean getProposalComplete();
    double getPrice();
}
