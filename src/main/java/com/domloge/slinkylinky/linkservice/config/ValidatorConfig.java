package com.domloge.slinkylinky.linkservice.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.domloge.slinkylinky.linkservice.entity.validator.CategoryValidator;
import com.domloge.slinkylinky.linkservice.entity.validator.DemandSiteValidator;
import com.domloge.slinkylinky.linkservice.entity.validator.DemandValidator;
import com.domloge.slinkylinky.linkservice.entity.validator.ProposalValidator;
import com.domloge.slinkylinky.linkservice.entity.validator.SupplierValidator;

@Configuration
public class ValidatorConfig {
    
    @Bean
    public CategoryValidator beforeCreateCategoryValidator() {
        return new CategoryValidator();
    }

    @Bean CategoryValidator beforeSaveCategoryValidator() {
        return new CategoryValidator();
    }

    @Bean DemandValidator beforeCreateDemandValidator() {
        return new DemandValidator();
    }

    @Bean DemandValidator beforeSaveDemandValidator() {
        return new DemandValidator();
    }

    @Bean DemandSiteValidator beforeCreateDemandSiteValidator() {
        return new DemandSiteValidator();
    }

    @Bean DemandSiteValidator beforeSaveDemandSiteValidator() {
        return new DemandSiteValidator();
    }

    @Bean ProposalValidator beforeCreateProposalValidator() {
        return new ProposalValidator();
    }

    @Bean ProposalValidator beforeSaveProposalValidator() {
        return new ProposalValidator();
    }

    @Bean SupplierValidator beforeCreateSupplierValidator() {
        return new SupplierValidator();
    }

    @Bean SupplierValidator beforeSaveSupplierValidator() {
        return new SupplierValidator();
    }
}
