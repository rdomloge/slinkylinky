package com.domloge.slinkylinky.linkservice.entity;

import org.springframework.data.rest.core.config.Projection;

/**
 * Full supplier projection for global_admin callers only — includes sensitive fields email and source.
 * Access is enforced by GlobalAdminProjectionInterceptor; this projection must not be exposed to other roles.
 */
@Projection(name = "globalAdminSupplier", types = {Supplier.class})
public interface GlobalAdminSupplierProjection {

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

    long getVersion();
}
