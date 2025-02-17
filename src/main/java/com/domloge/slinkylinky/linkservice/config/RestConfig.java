package com.domloge.slinkylinky.linkservice.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.data.rest.core.config.RepositoryRestConfiguration;
import org.springframework.data.rest.webmvc.config.RepositoryRestConfigurer;
import org.springframework.web.servlet.config.annotation.CorsRegistry;

import com.domloge.slinkylinky.linkservice.entity.Supplier;
import com.domloge.slinkylinky.linkservice.entity.Category;
import com.domloge.slinkylinky.linkservice.entity.FullCategoryProjection;
import com.domloge.slinkylinky.linkservice.entity.FullDemandProjection;
import com.domloge.slinkylinky.linkservice.entity.FullDemandsSiteProjection;
import com.domloge.slinkylinky.linkservice.entity.FullPaidLinkProjection;
import com.domloge.slinkylinky.linkservice.entity.FullProposalProjection;
import com.domloge.slinkylinky.linkservice.entity.FullSupplierProjection;
import com.domloge.slinkylinky.linkservice.entity.LiteDemandProjection;
import com.domloge.slinkylinky.linkservice.entity.LitePaidLinkProjection;
import com.domloge.slinkylinky.linkservice.entity.LiteProposalProjection;
import com.domloge.slinkylinky.linkservice.entity.LiteSupplierProjection;
import com.domloge.slinkylinky.linkservice.entity.Demand;
import com.domloge.slinkylinky.linkservice.entity.DemandSite;
import com.domloge.slinkylinky.linkservice.entity.PaidLink;
import com.domloge.slinkylinky.linkservice.entity.Proposal;

@Configuration
public class RestConfig implements RepositoryRestConfigurer {
 
    @Override
    public void configureRepositoryRestConfiguration(RepositoryRestConfiguration config, CorsRegistry cors) {
        
        // This isn't needed as long as the projection interfaces are in the same package as the entities
        // config.getProjectionConfiguration()
        //     .addProjection(FullProposalProjection.class)
        //     .addProjection(FullPaidLinkProjection.class)
        //     .addProjection(FullSupplierProjection.class)
        //     .addProjection(FullDemandProjection.class)
        //     .addProjection(FullCategoryProjection.class)
        //     .addProjection(FullDemandsSiteProjection.class)
        //     .addProjection(LitePaidLinkProjection.class)
        //     .addProjection(LiteDemandProjection.class)
        //     .addProjection(LiteDemandProjection.class);
        
        config.exposeIdsFor(
          Demand.class, 
          DemandSite.class,
          Supplier.class, 
          Proposal.class, 
          PaidLink.class, 
          Category.class,
          FullDemandProjection.class,
          FullDemandsSiteProjection.class,
          FullSupplierProjection.class,
          FullProposalProjection.class,
          FullPaidLinkProjection.class,
          FullCategoryProjection.class,
          LitePaidLinkProjection.class,
          LiteDemandProjection.class,
          LiteSupplierProjection.class,
          LiteProposalProjection.class
          );
    }
}
