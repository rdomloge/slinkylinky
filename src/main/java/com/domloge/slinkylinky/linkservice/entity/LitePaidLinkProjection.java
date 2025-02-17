package com.domloge.slinkylinky.linkservice.entity;

import org.springframework.data.rest.core.config.Projection;

/**
 * A light weight projection of a paid link, missing categories, but with everything else
 */
@Projection(name="litePaidLink", types = {PaidLink.class, LiteDemandProjection.class})
public interface LitePaidLinkProjection {
    
    long getId();
    
    LiteSupplierProjection getSupplier();

    LiteDemandProjection getDemand();

}
