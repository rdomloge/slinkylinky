package com.domloge.slinkylinky.linkservice.entity;

import java.time.LocalDateTime;

import org.springframework.data.rest.core.config.Projection;

/**
 * A light weight projection of a demand, missing categories, but with everything else
 */
@Projection(name="liteDemand", types = {Demand.class})
public interface LiteDemandProjection {
    long getId();
    
    String getName();

    String getUrl();

    Integer getDaNeeded();

    String getAnchorText();

    String getDomain();

    LocalDateTime getRequested();

    // String getCreatedBy();

    String getSource();

    int getWordCount();
}
