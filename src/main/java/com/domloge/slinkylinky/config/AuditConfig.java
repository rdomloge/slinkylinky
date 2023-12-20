package com.domloge.slinkylinky.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.domloge.slinkylinky.linkservice.entity.audit.DemandSiteAuditor;

@Configuration
public class AuditConfig {
    
    @Bean
    DemandSiteAuditor demandSiteEventHandler() {
        return new DemandSiteAuditor();
    }
}
