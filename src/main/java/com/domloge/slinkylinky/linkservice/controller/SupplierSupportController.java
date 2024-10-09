package com.domloge.slinkylinky.linkservice.controller;

import java.util.List;
import java.util.Optional;
import java.time.LocalDateTime;

import org.hibernate.envers.AuditReader;
import org.hibernate.envers.AuditReaderFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.context.ApplicationEventPublisherAware;
import org.springframework.data.rest.core.event.AfterCreateEvent;
import org.springframework.data.rest.core.event.AfterSaveEvent;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.domloge.slinkylinky.events.SupplierEngagementEvent;
import com.domloge.slinkylinky.linkservice.ProposalAbortHandler;
import com.domloge.slinkylinky.linkservice.Util;
import com.domloge.slinkylinky.linkservice.entity.Proposal;
import com.domloge.slinkylinky.linkservice.entity.Supplier;
import com.domloge.slinkylinky.linkservice.entity.audit.SupplierAuditor;
import com.domloge.slinkylinky.linkservice.repo.ProposalRepo;
import com.domloge.slinkylinky.linkservice.repo.SupplierRepo;

import jakarta.persistence.EntityManager;
import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;


@Controller
@RequestMapping(".rest/supplierSupport")
@Slf4j
public class SupplierSupportController implements ApplicationEventPublisherAware {

    @Autowired
    private EntityManager entityManager;

    @Autowired
    private SupplierRepo supplierRepo;

    @Autowired
    private SupplierAuditor supplierAuditor;

    @Autowired
    private ProposalRepo proposalRepo;

    private ApplicationEventPublisher applicationEventPublisher;

    @Autowired
    private ProposalAbortHandler proposalAbortHandler;


    @PatchMapping(path = "/updateSupplierDa", produces = "application/json")
    @Transactional
    public ResponseEntity<Supplier> updateSupplierDa(@RequestParam long supplierId, @RequestParam int da) {
        log.info("Updating supplier da for supplierId: " + supplierId + " da: " + da);

        Optional<Supplier> opt = supplierRepo.findById(supplierId);
        if (opt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        Supplier supplier = opt.get();

        supplier.setDa(da);
        supplier.setUpdatedBy("system");
        supplier.setModifiedDate(System.currentTimeMillis());
        supplierRepo.save(supplier);
        supplierAuditor.handleBeforeSave(supplier);

        return ResponseEntity.ok(supplier);
    }
    

    @GetMapping(path = "/getVersion", produces = "application/json")
    @Transactional
    public ResponseEntity<Supplier> getSupplier(@RequestParam long supplierId, @RequestParam long version) {
        log.info("Getting supplier version for supplierId: " + supplierId + " version: " + version);
        AuditReader auditReader = AuditReaderFactory.get(entityManager);
        List<Number> revisions = auditReader.getRevisions(Supplier.class, supplierId);
        if (revisions.size() < version) {
            return ResponseEntity.notFound().build();
        }

        Supplier versionedSupplier = auditReader.find(Supplier.class, supplierId, revisions.get((int) version));
        
        return ResponseEntity.ok(versionedSupplier);
    }

    @GetMapping(path = "/exists", produces = "application/json")
    public ResponseEntity<Boolean> supplierExists(@RequestParam String supplierWebsite) {
        log.info("Checking if supplier exists for supplierWebsite: " + supplierWebsite);
        String domain  = Util.stripDomain(supplierWebsite);
        Supplier s = supplierRepo.findByDomainIgnoreCase(domain);
        log.info("Supplier {} for supplierWebsite {} {}", domain, supplierWebsite, s != null ? "exists" : "does not exist");
        return ResponseEntity.ok(s != null);
    }

    @Transactional
    @PostMapping(path = "/supplierresponse", consumes = "application/json", produces = "application/json")
    public ResponseEntity<Proposal> processSupplierResponse(@RequestBody SupplierEngagementEvent event, 
            @RequestParam(name = "proposalId") long proposalId) {

        Proposal proposal = proposalRepo.findById(proposalId).orElseThrow(null);


        if(event.getResponse() == SupplierEngagementEvent.Response.ACCEPTED) {
            proposal.setDateAcceptedBySupplier(LocalDateTime.now());
            proposal.setProposalAccepted(true);

            // set invoice received flag to true
            proposal.setInvoiceReceived(true);
            proposal.setDateInvoiceReceived(LocalDateTime.now());
            
            proposal.setBlogLive(true);
            proposal.setDateBlogLive(LocalDateTime.now());
            proposal.setLiveLinkTitle(event.getBlogTitle());
            proposal.setLiveLinkUrl(event.getBlogUrl());
            Proposal dbProposal = proposalRepo.save(proposal);
            applicationEventPublisher.publishEvent(new AfterSaveEvent(dbProposal));
            return ResponseEntity.ok(dbProposal);
        }
        else if(event.getResponse() == SupplierEngagementEvent.Response.DECLINED) {
            proposalAbortHandler.handle(event.getProposalId(), "supplier");        
            return ResponseEntity.ok(proposal);
        }
        else {
            log.error("Unknown response type {}", event.getResponse());
            return ResponseEntity.badRequest().build();
        }
    }
    
    @Override
    public void setApplicationEventPublisher(ApplicationEventPublisher applicationEventPublisher) {
        this.applicationEventPublisher = applicationEventPublisher;
    }
}
