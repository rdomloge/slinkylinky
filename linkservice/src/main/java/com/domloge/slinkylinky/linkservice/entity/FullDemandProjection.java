package com.domloge.slinkylinky.linkservice.entity;

import java.time.LocalDateTime;

import org.springframework.data.rest.core.config.Projection;

@Projection(name="fullDemand", types = {Demand.class})
public interface FullDemandProjection {
    
    long getId();
    
    String getName();

    String getUrl();

    Integer getDaNeeded();

    String getAnchorText();

    String getDomain();

    LocalDateTime getRequested();

    String getCreatedBy();

    String getSource();

    int getWordCount();

    FullCategoryProjection[] getCategories();
}
