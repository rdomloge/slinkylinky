package com.domloge.slinkylinky.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.data.rest.core.config.RepositoryRestConfiguration;
import org.springframework.data.rest.webmvc.config.RepositoryRestConfigurer;
import org.springframework.web.servlet.config.annotation.CorsRegistry;

import com.domloge.slinkylinky.linkservice.entity.Supplier;
import com.domloge.slinkylinky.linkservice.entity.Category;
import com.domloge.slinkylinky.linkservice.entity.FullCategoryProjection;
import com.domloge.slinkylinky.linkservice.entity.FullDemandProjection;
import com.domloge.slinkylinky.linkservice.entity.FullPaidLinkProjection;
import com.domloge.slinkylinky.linkservice.entity.FullProposalProjection;
import com.domloge.slinkylinky.linkservice.entity.FullSupplierProjection;
import com.domloge.slinkylinky.linkservice.entity.Demand;
import com.domloge.slinkylinky.linkservice.entity.PaidLink;
import com.domloge.slinkylinky.linkservice.entity.Proposal;

@Configuration
public class RestConfig implements RepositoryRestConfigurer {
 
    @Override
    public void configureRepositoryRestConfiguration(RepositoryRestConfiguration config, CorsRegistry cors) {
        
        config.getProjectionConfiguration()
            .addProjection(FullProposalProjection.class)
            .addProjection(FullPaidLinkProjection.class)
            .addProjection(FullSupplierProjection.class)
            .addProjection(FullDemandProjection.class)
            .addProjection(FullCategoryProjection.class);
        
        config.exposeIdsFor(
          Demand.class, 
          Supplier.class, 
          Proposal.class, 
          PaidLink.class, 
          Category.class,
          FullDemandProjection.class,
          FullSupplierProjection.class,
          FullProposalProjection.class,
          FullPaidLinkProjection.class,
          FullCategoryProjection.class);
    }
}
