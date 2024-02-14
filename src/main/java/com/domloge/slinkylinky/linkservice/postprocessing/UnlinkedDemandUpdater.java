package com.domloge.slinkylinky.linkservice.postprocessing;

import java.util.HashSet;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.rest.core.annotation.HandleBeforeSave;
import org.springframework.data.rest.core.annotation.RepositoryEventHandler;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.linkservice.entity.Category;
import com.domloge.slinkylinky.linkservice.entity.DemandSite;
import com.domloge.slinkylinky.linkservice.repo.DemandRepo;

import lombok.extern.slf4j.Slf4j;

@Component
@RepositoryEventHandler(DemandSite.class)
@Slf4j
public class UnlinkedDemandUpdater {
    
    @Autowired
    private DemandRepo demandRepo;

    @HandleBeforeSave
    public void handleAfterSave(DemandSite demandSite) {
        if(null == demandSite) {
            throw new IllegalStateException("demand site is null");
        }

        demandSite.getDemands().forEach(demand -> {
            Set<Category> newCats = new HashSet<>();
            demandSite.getCategories().forEach(newCats::add);
            demand.setCategories(newCats);
            // what do we do if the demand site domain no longer matches the demand domain?
            if ( ! demand.getDomain().equals(demandSite.getDomain())) {
                log.warn("Demand site domain {} no longer matches demand domain {}", demandSite.getDomain(), demand.getDomain());                
            }
            demandRepo.save(demand);
        });
    }
}