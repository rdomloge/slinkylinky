package com.domloge.slinkylinky.linkservice.entity;

import java.util.LinkedList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.rest.core.annotation.HandleAfterCreate;
import org.springframework.data.rest.core.annotation.RepositoryEventHandler;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.linkservice.repo.DemandSiteRepo;

@Component
@RepositoryEventHandler(Demand.class)
public class DemandLinker {
    
    @Autowired
    private DemandSiteRepo demandSiteRepo;

    @HandleAfterCreate
    public void handleAfterCreate(Demand demand) {
        DemandSite demandSite = demandSiteRepo.findByDomainIgnoreCase(demand.getDomain());
        LinkedList<Demand> newList = new LinkedList<>();
        newList.addAll(demandSite.getDemands());
        newList.add(demand);
        demandSite.setDemands(newList);
        demandSiteRepo.save(demandSite);
    }
}
