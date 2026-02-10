package com.domloge.slinkylinky.linkservice.entity;

import org.springframework.data.rest.core.config.Projection;

@Projection(name="fullCategory", types = {Category.class})
public interface FullCategoryProjection {
    
    String getName();

    boolean isDisabled();

    long getId();
}
