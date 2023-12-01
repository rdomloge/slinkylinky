package com.domloge.slinkylinky.linkservice.entity;

import org.springframework.data.rest.core.config.Projection;

@Projection(name="fullPaidlink", types = {PaidLink.class})
public interface FullPaidLinkProjection {
    
    FullBloggerProjection getBlogger();

    
    FullLinkDemandProjection getLinkDemand();
}
