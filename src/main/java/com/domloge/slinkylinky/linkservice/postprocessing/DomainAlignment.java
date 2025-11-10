package com.domloge.slinkylinky.linkservice.postprocessing;

import org.springframework.data.rest.core.annotation.HandleBeforeSave;
import org.springframework.data.rest.core.annotation.RepositoryEventHandler;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.linkservice.Util;
import com.domloge.slinkylinky.linkservice.entity.Demand;

import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
@RepositoryEventHandler(Demand.class)
public class DomainAlignment {
    

    // method to handle demand being updated to parse the demand domain and set it in the domain field
    @HandleBeforeSave
    public void handleBeforeSave(Demand demand) {
        
        if( ! demand.getDomain().equals(Util.stripDomain(demand.getUrl()))) {
            log.warn("Demand domain {} does not match URL domain {} for demand id {}. Aligning them.",
                demand.getDomain(), Util.stripDomain(demand.getUrl()), demand.getId());
            demand.setDomain(Util.stripDomain(demand.getUrl()));
        }
        
    }
}
