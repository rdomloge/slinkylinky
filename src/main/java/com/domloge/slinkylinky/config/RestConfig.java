package com.domloge.slinkylinky.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.data.rest.core.config.RepositoryRestConfiguration;
import org.springframework.data.rest.webmvc.config.RepositoryRestConfigurer;
import org.springframework.web.servlet.config.annotation.CorsRegistry;

import com.domloge.slinkylinky.linkservice.entity.Blogger;
import com.domloge.slinkylinky.linkservice.entity.Category;
import com.domloge.slinkylinky.linkservice.entity.FullBloggerProjection;
import com.domloge.slinkylinky.linkservice.entity.FullCategoryProjection;
import com.domloge.slinkylinky.linkservice.entity.FullLinkDemandProjection;
import com.domloge.slinkylinky.linkservice.entity.FullPaidLinkProjection;
import com.domloge.slinkylinky.linkservice.entity.FullProposalProjection;
import com.domloge.slinkylinky.linkservice.entity.LinkDemand;
import com.domloge.slinkylinky.linkservice.entity.PaidLink;
import com.domloge.slinkylinky.linkservice.entity.Proposal;

@Configuration
public class RestConfig implements RepositoryRestConfigurer {
 
    @Override
    public void configureRepositoryRestConfiguration(RepositoryRestConfiguration config, CorsRegistry cors) {
        
        config.getProjectionConfiguration()
            .addProjection(FullProposalProjection.class)
            .addProjection(FullPaidLinkProjection.class)
            .addProjection(FullBloggerProjection.class)
            .addProjection(FullLinkDemandProjection.class)
            .addProjection(FullCategoryProjection.class);
        
        config.exposeIdsFor(
          LinkDemand.class, 
          Blogger.class, 
          Proposal.class, 
          PaidLink.class, 
          Category.class,
          FullLinkDemandProjection.class);
    }
}
