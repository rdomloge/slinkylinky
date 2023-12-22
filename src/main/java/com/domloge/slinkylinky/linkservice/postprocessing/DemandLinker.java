package com.domloge.slinkylinky.linkservice.postprocessing;

import java.time.LocalDateTime;
import java.util.LinkedList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.rest.core.annotation.HandleAfterCreate;
import org.springframework.data.rest.core.annotation.RepositoryEventHandler;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.linkservice.entity.Demand;
import com.domloge.slinkylinky.linkservice.entity.DemandSite;
import com.domloge.slinkylinky.linkservice.entity.audit.AuditRecord;
import com.domloge.slinkylinky.linkservice.repo.AuditRecordRepo;
import com.domloge.slinkylinky.linkservice.repo.DemandSiteRepo;

@Component
@RepositoryEventHandler(Demand.class)
public class DemandLinker {
    
    @Autowired
    private DemandSiteRepo demandSiteRepo;

    @Autowired
    private AuditRecordRepo auditRecordRepo;

    @HandleAfterCreate
    public void handleAfterCreate(Demand demand) {
        DemandSite demandSite = demandSiteRepo.findByDomainIgnoreCase(demand.getDomain());
        if(null == demandSite) {
            AuditRecord auditRecord = new AuditRecord();
            auditRecord.setEntityId(demand.getId());
            auditRecord.setEntityType(Demand.class.getSimpleName());
            auditRecord.setEventTime(LocalDateTime.now());
            auditRecord.setWho(demand.getCreatedBy());
            auditRecord.setWhat("bad user behaviour");
            auditRecord.setDetail("User "+demand.getCreatedBy()+" is creating a demand with domain "
                + demand.getDomain() + " but there is no demand site with that domain which means that they selected a demand site and the changed the domain");
            auditRecordRepo.save(auditRecord);
            return;
        }
        LinkedList<Demand> newList = new LinkedList<>();
        newList.addAll(demandSite.getDemands());
        newList.add(demand);
        demandSite.setDemands(newList);
        demandSiteRepo.save(demandSite);
    }
}
