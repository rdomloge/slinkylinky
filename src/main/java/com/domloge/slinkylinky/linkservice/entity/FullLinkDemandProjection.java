package com.domloge.slinkylinky.linkservice.entity;

import java.time.LocalDate;
import java.time.LocalDateTime;

import org.springframework.data.rest.core.config.Projection;

@Projection(name="fullLinkDemand", types = {LinkDemand.class})
public interface FullLinkDemandProjection {
    
    String getName();

    String getUrl();

    Integer getDaNeeded();

    String getAnchorText();

    String getDomain();

    LocalDateTime getRequested();

    String getCreatedBy();

    FullCategoryProjection[] getCategories();
}
