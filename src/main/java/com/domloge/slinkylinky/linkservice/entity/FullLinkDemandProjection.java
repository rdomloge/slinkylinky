package com.domloge.slinkylinky.linkservice.entity;

import java.time.LocalDate;

import org.springframework.data.rest.core.config.Projection;

@Projection(name="fullLinkDemand", types = {LinkDemand.class})
public interface FullLinkDemandProjection {
    
    String getName();

    String getUrl();

    Integer getDaNeeded();

    String getAnchorText();

    String getDomain();

    String getRequested();

    String getCreatedBy();

    FullCategoryProjection[] getCategories();

    LocalDate getRequestedDate();
}
