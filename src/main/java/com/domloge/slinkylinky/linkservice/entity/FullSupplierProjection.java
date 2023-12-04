package com.domloge.slinkylinky.linkservice.entity;

import org.springframework.data.rest.core.config.Projection;

@Projection(name="fullSupplier", types = {Supplier.class})
public interface FullSupplierProjection {

    String getName();

    String getEmail();

    Integer getDa();

    String getWebsite();

    String getDomain();

    Integer getWeWriteFee();

    Integer getSemRushAuthorityScore();

    Integer getSemRushUkMonthlyTraffic();

    Integer getSemRushUkJan23Traffic();

    FullCategoryProjection[] getCategories();

}