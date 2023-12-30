package com.domloge.slinkylinky.linkservice.controller;

import java.net.URI;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.LinkedList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.domloge.slinkylinky.linkservice.entity.PaidLink;
import com.domloge.slinkylinky.linkservice.entity.Proposal;
import com.domloge.slinkylinky.linkservice.entity.Supplier;
import com.domloge.slinkylinky.linkservice.entity.audit.ProposalAuditor;
import com.domloge.slinkylinky.linkservice.entity.audit.SupplierAuditor;
import com.domloge.slinkylinky.linkservice.repo.DemandRepo;
import com.domloge.slinkylinky.linkservice.repo.PaidLinkRepo;
import com.domloge.slinkylinky.linkservice.repo.ProposalRepo;
import com.domloge.slinkylinky.linkservice.repo.SupplierRepo;

import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping(".rest/proposalsupport")
@Slf4j
public class ProposalSupportController {
    
    @Autowired
    private SupplierRepo supplierRepo;

    @Autowired
    private PaidLinkRepo paidLinkRepo;

    @Autowired
    private ProposalRepo proposalRepo;

    @Autowired
    private DemandRepo demandRepo;

    @Autowired
    private ProposalAuditor proposalAuditor;

    @Autowired
    private SupplierAuditor supplierAuditor;


    @PostMapping(path = "/createProposal", produces = "application/json")
    @Transactional
    public ResponseEntity<Object> createProposal(@RequestHeader String user, @RequestParam long supplierId, 
            @RequestParam long[] demandIds) {
        
        log.info(user + " is creating a proposal for supplier {} for demands {} " + supplierId + " " + Arrays.toString(demandIds));
        
        LinkedList<PaidLink> paidLinks = new LinkedList<>();
        // create the paid links
        Arrays.stream(demandIds).forEach(i -> {
            PaidLink paidLink = new PaidLink();
            paidLink.setDemand(demandRepo.findById(i).get());
            paidLink.setSupplier(supplierRepo.findById(supplierId).get());
            PaidLink dbPaidLink = paidLinkRepo.save(paidLink);
            paidLinks.add(dbPaidLink);
        });

        // create the proposal
        Proposal proposal = new Proposal();
        proposal.setCreatedBy(user);
        proposal.setDateCreated(LocalDateTime.now());
        proposal.setPaidLinks(paidLinks);
        Proposal dbProposal = proposalRepo.save(proposal);
        proposalAuditor.handleAfterCreate(dbProposal);
        
        // make sure the new proposal HREF is in the Location header of the response.
        return ResponseEntity.created(URI.create("/proposals/" + dbProposal.getId())).build();
    }

    

    @PostMapping(path = "/resolveProposal3rdParty", produces = "application/json")
    @Transactional
    public ResponseEntity<Object> resolveDemandWith3rdPartySupplier(
            @RequestParam String name, @RequestHeader String user, @RequestParam int demandId) {
        
        log.info(user + " is resolving demand " + demandId + " with 3rd party supplier " + name);
        
        // create the 3rd party supplier
        Supplier supplier = new Supplier();
        supplier.setName(name);
        supplier.setThirdParty(true);
        supplier.setCreatedBy(user);
        Supplier dbSupplier = supplierRepo.save(supplier);
        supplierAuditor.handleAfterCreate(dbSupplier);

        // create the paidlink, linking the demand with the 3rd party supplier
        PaidLink paidLink = new PaidLink();
        paidLink.setDemand(demandRepo.findById(demandId));
        paidLink.setSupplier(dbSupplier);
        PaidLink dbPaidLink = paidLinkRepo.save(paidLink);
        

        // create the proposal with the paidlink added to it
        Proposal proposal = new Proposal();
        proposal.setCreatedBy(user);
        proposal.setDateCreated(LocalDateTime.now());
        proposal.setPaidLinks(Arrays.asList(dbPaidLink));
        Proposal dbProposal = proposalRepo.save(proposal);
        proposalAuditor.handleAfterCreate(dbProposal);
        
        // make sure the new proposal HREF is in the Location header of the response.
        return ResponseEntity.created(URI.create("/proposals/" + dbProposal.getId())).build();
    }

}
