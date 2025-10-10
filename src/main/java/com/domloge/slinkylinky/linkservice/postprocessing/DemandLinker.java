package com.domloge.slinkylinky.linkservice.postprocessing;

import java.time.LocalDateTime;
import java.util.LinkedList;

import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.rest.core.annotation.HandleAfterCreate;
import org.springframework.data.rest.core.annotation.HandleBeforeSave;
import org.springframework.data.rest.core.annotation.RepositoryEventHandler;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.linkservice.Util;
import com.domloge.slinkylinky.linkservice.entity.Demand;
import com.domloge.slinkylinky.linkservice.entity.DemandSite;
import com.domloge.slinkylinky.linkservice.entity.audit.AuditRecord;
import com.domloge.slinkylinky.linkservice.repo.DemandSiteRepo;

import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
@RepositoryEventHandler(Demand.class)
public class DemandLinker {
    
    @Autowired
    private DemandSiteRepo demandSiteRepo;

    @Autowired
    private AmqpTemplate auditRabbitTemplate;


    // method to handle demand being updated to parse the demand domain and set it in the domain field
    @HandleBeforeSave
    public void handleBeforeSave(Demand demand) {
        
        if( ! demand.getDomain().equals(Util.stripDomain(demand.getUrl()))) {
            log.warn("Demand domain {} does not match URL domain {} for demand id {}. Aligning them.",
                demand.getDomain(), Util.stripDomain(demand.getUrl()), demand.getId());
            demand.setDomain(Util.stripDomain(demand.getUrl()));
        }
        
    }

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
            auditRabbitTemplate.convertAndSend(auditRecord);
            return;
        }
        LinkedList<Demand> newList = new LinkedList<>();
        newList.addAll(demandSite.getDemands());
        newList.add(demand);
        demandSite.setDemands(newList);
        demandSiteRepo.save(demandSite);
    }
}
