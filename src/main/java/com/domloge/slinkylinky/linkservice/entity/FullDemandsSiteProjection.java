package com.domloge.slinkylinky.linkservice.entity;

import org.springframework.data.rest.core.config.Projection;

@Projection(name="fullDemandSite", types = {DemandSite.class})
public interface FullDemandsSiteProjection {
    
    long getId();
    
    String getName();

    String getUrl();

    String getDomain();

    String getEmail();

    String getCreatedBy();

    FullCategoryProjection[] getCategories();
}
