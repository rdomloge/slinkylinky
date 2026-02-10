package com.domloge.slinkylinky.linkservice.entity;

import org.springframework.data.rest.core.config.Projection;

/**
 * A light weight projection of a supplier, missing categories, but with everything else
 */
@Projection(name="liteSupplier", types = {Supplier.class})
public interface LiteSupplierProjection {
    
    long getId();

    String getName();

    String getEmail();

    Integer getDa();

    String getWebsite();

    String getDomain();

    Integer getWeWriteFee();

    boolean isThirdParty();

    boolean isDisabled();

    String getWeWriteFeeCurrency();
}
