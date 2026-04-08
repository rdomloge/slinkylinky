package com.domloge.slinkylinky.linkservice.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.domloge.slinkylinky.linkservice.config.TenantContext;

import com.domloge.slinkylinky.linkservice.entity.DemandSite;
import com.domloge.slinkylinky.linkservice.entity.DemandSiteCountProjection;
import com.domloge.slinkylinky.linkservice.entity.audit.DemandSiteAuditor;
import com.domloge.slinkylinky.linkservice.repo.DemandSiteRepo;

import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping(".rest/demandssitesupport")
@Slf4j
public class DemandSiteSupportController {

    @Autowired
    private DemandSiteRepo demandSiteRepo;
    
    @Autowired
    private DemandSiteAuditor demandSiteAuditor;
    
    @GetMapping(path = "/topbydemands", produces = "application/json")
    public ResponseEntity<List<DemandSiteCountProjection>> topByDemands(@RequestParam(defaultValue = "5") int limit) {
        return ResponseEntity.ok(demandSiteRepo.findTopByDemandCount(limit));
    }

    @DeleteMapping(path = "/delete", produces = "text/HTML")
    @Transactional
    public ResponseEntity<Object> delete(@RequestParam long demandSiteId) {
        String user = TenantContext.getUsername();
        DemandSite demand = demandSiteRepo.findById(demandSiteId).get();
        demand.setUpdatedBy(user);
        demandSiteRepo.delete(demand);
        demandSiteAuditor.handleAfterDelete(demand);
        log.info(user + " deleted demandSite " + demandSiteId);
        return ResponseEntity.ok().build();
    }
}
