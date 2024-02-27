package com.domloge.slinkylinky.woocommerce.entity;

import java.time.LocalDateTime;

import org.springframework.data.rest.core.config.Projection;

@Projection(name="lightOrder", types = {OrderEntity.class})
public interface LightOrderProjection {

    long getId();

    long getExternalId();

    LocalDateTime getDateCreated();

    OrderLineItemProjection[] getLineItems(); 
    
}
