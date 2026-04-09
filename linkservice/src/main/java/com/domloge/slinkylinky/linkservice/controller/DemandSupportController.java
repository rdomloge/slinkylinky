package com.domloge.slinkylinky.linkservice.controller;

import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.domloge.slinkylinky.linkservice.config.TenantContext;
import com.domloge.slinkylinky.linkservice.config.TenantFilter;
import com.domloge.slinkylinky.linkservice.entity.Demand;
import com.domloge.slinkylinky.linkservice.entity.audit.DemandAuditor;
import com.domloge.slinkylinky.linkservice.repo.DemandRepo;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping(".rest/demandsupport")
@Slf4j
public class DemandSupportController {

    @Autowired
    private DemandRepo demandRepo;

    @Autowired
    private DemandAuditor demandAuditor;
    
    /**
     * Org-scoped unsatisfied demand listing. Replaces the unfiltered Spring Data REST
     * search endpoints. Sort: "requested" (default) or "daNeeded".
     */
    @GetMapping(path = "/findUnsatisfied", produces = "application/json")
    @ResponseBody
    @Transactional
    public ResponseEntity<Demand[]> findUnsatisfied(
            @RequestParam(defaultValue = "requested") String sort,
            HttpServletRequest request) {
        UUID orgId = TenantFilter.requireOrgId(request);
        Demand[] demands = "daNeeded".equals(sort)
            ? demandRepo.findUnsatisfiedDemandOrderedByDaNeeded(orgId)
            : demandRepo.findUnsatisfiedDemandOrderedByRequested(orgId);
        // Force-initialize lazy categories within the transaction so Jackson can
        // serialize them after the session closes.
        for (Demand d : demands) {
            d.getCategories().size();
        }
        return ResponseEntity.ok(demands);
    }

    @DeleteMapping(path = "/delete", produces = "text/HTML")
    @Transactional
    public ResponseEntity<Object> delete(@RequestParam long demandId, HttpServletRequest request) {
        String user = TenantContext.getUsername();
        UUID orgId = TenantFilter.requireOrgId(request);
        Demand demand = demandRepo.findById(demandId).get();
        if (!orgId.equals(demand.getOrganisationId())) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        demand.setUpdatedBy(user);
        demandRepo.delete(demand);
        demandAuditor.handleAfterDelete(demand);
        log.info(user + " deleted demand " + demandId);
        return ResponseEntity.ok().build();
    }
}
