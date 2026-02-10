package com.domloge.slinkylinky.linkservice.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.domloge.slinkylinky.linkservice.entity.Demand;
import com.domloge.slinkylinky.linkservice.entity.audit.DemandAuditor;
import com.domloge.slinkylinky.linkservice.repo.DemandRepo;

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
    
    @DeleteMapping(path = "/delete", produces = "text/HTML")
    @Transactional
    public ResponseEntity<Object> delete(@RequestParam long demandId, @RequestHeader String user) {
        Demand demand = demandRepo.findById(demandId).get();
        demand.setUpdatedBy(user);
        demandRepo.delete(demand);
        demandAuditor.handleAfterDelete(demand);
        log.info(user + " deleted demand " + demandId);
        return ResponseEntity.ok().build();
    }
}
