package com.domloge.slinkylinky.linkservice.entity;

import org.springframework.data.rest.core.config.Projection;

@Projection(name="fullSupplier", types = {Supplier.class})
public interface FullSupplierProjection {

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

    String getSource();

    String getCreatedBy();

    String getUpdatedBy();

    FullCategoryProjection[] getCategories();

}