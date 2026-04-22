package com.domloge.slinkylinky.linkservice.postprocessing;

import java.time.LocalDateTime;
import java.util.LinkedList;

import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.rest.core.annotation.HandleAfterCreate;
import org.springframework.data.rest.core.annotation.HandleBeforeCreate;
import org.springframework.data.rest.core.annotation.HandleBeforeSave;
import org.springframework.data.rest.core.annotation.RepositoryEventHandler;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.domloge.slinkylinky.common.TenantFilter;
import com.domloge.slinkylinky.events.AuditEvent;
import com.domloge.slinkylinky.linkservice.entity.Demand;
import com.domloge.slinkylinky.linkservice.entity.DemandSite;
import com.domloge.slinkylinky.linkservice.repo.DemandSiteRepo;

import jakarta.servlet.http.HttpServletRequest;


@Component
@RepositoryEventHandler(Demand.class)
public class DemandLinker {
    
    @Autowired
    private DemandSiteRepo demandSiteRepo;

    @Autowired
    private AmqpTemplate auditRabbitTemplate;


    @HandleBeforeCreate
    public void handleBeforeCreate(Demand demand) {
        HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
        demand.setOrganisationId(TenantFilter.requireOrgId(request));
    }

    @HandleBeforeSave
    public void handleBeforeSave(Demand demand) {
        if (demand.getOrganisationId() == null) {
            HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
            demand.setOrganisationId(TenantFilter.requireOrgId(request));
        }
    }

    @HandleAfterCreate
    public void handleAfterCreate(Demand demand) {
        DemandSite demandSite = demand.getOrganisationId() != null
            ? demandSiteRepo.findByDomainIgnoreCaseAndOrganisationId(demand.getDomain(), demand.getOrganisationId())
            : demandSiteRepo.findByDomainIgnoreCase(demand.getDomain());
        if(null == demandSite) {
            AuditEvent auditEvent = new AuditEvent();
            auditEvent.setEntityId(String.valueOf(demand.getId()));
            auditEvent.setEntityType(Demand.class.getSimpleName());
            auditEvent.setEventTime(LocalDateTime.now());
            auditEvent.setWho(demand.getCreatedBy());
            auditEvent.setWhat("bad user behaviour");
            auditEvent.setDetail("User "+demand.getCreatedBy()+" is creating a demand with domain "
                + demand.getDomain() + " but there is no demand site with that domain which means that they selected a demand site and the changed the domain");
            auditEvent.setOrganisationId(demand.getOrganisationId());
            auditRabbitTemplate.convertAndSend(auditEvent);
            return;
        }
        LinkedList<Demand> newList = new LinkedList<>();
        newList.addAll(demandSite.getDemands());
        newList.add(demand);
        demandSite.setDemands(newList);
        demandSiteRepo.save(demandSite);
    }
}
