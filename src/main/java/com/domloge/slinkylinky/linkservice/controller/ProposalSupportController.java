package com.domloge.slinkylinky.linkservice.controller;

import java.net.URI;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.domloge.slinkylinky.linkservice.entity.PaidLink;
import com.domloge.slinkylinky.linkservice.entity.Proposal;
import com.domloge.slinkylinky.linkservice.entity.Supplier;
import com.domloge.slinkylinky.linkservice.entity.audit.ProposalAuditor;
import com.domloge.slinkylinky.linkservice.entity.audit.SupplierAuditor;
import com.domloge.slinkylinky.linkservice.repo.DemandRepo;
import com.domloge.slinkylinky.linkservice.repo.PaidLinkRepo;
import com.domloge.slinkylinky.linkservice.repo.ProposalRepo;
import com.domloge.slinkylinky.linkservice.repo.SupplierRepo;
import com.github.rjeschke.txtmark.Processor;

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


    @DeleteMapping(path = "/abort", produces = "text/HTML")
    @Transactional
    public ResponseEntity<Object> delete(@RequestParam long proposalId, @RequestHeader String user) {
        Optional<Proposal> opt = proposalRepo.findById(proposalId);
        if( ! opt.isPresent()) {
            return ResponseEntity.notFound().build();
        }
        Proposal proposal = proposalRepo.findById(proposalId).get();
        proposal.setUpdatedBy(user);
        
        proposal.getPaidLinks().forEach(pl -> {
            paidLinkRepo.delete(pl);
        });
        proposalRepo.delete(proposal);

        Supplier s = proposal.getPaidLinks().get(0).getSupplier();
        if(s.isThirdParty()) {
            log.info("Deleting 3rd party supplier {}, for proposal abort", s.getName());
            supplierRepo.delete(s);
        }

        proposalAuditor.handleAfterDelete(proposal);
        log.info(user + " deleted proposal " + proposalId);
        return ResponseEntity.ok().build();
    }

    @GetMapping(path = "/getArticleFormatted", produces = "text/HTML")
    @Transactional
    public ResponseEntity<String> getArticleFormatted(@RequestParam long proposalId) {
        Proposal proposal = proposalRepo.findById(proposalId).get();

        String article = proposal.getArticle();
        if(article == null) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok(Processor.process(article));
    }


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

    @PatchMapping(path = "/addarticle", produces = "application/json")
    @Transactional
    public ResponseEntity<Object> addArticle(@RequestHeader String user, @RequestParam long proposalId, 
            @RequestBody String article) {
        
        log.info(user + " is adding article to proposal " + proposalId);
        
        Proposal proposal = proposalRepo.findById(proposalId).get();
        proposal.setArticle(article);
        proposal.setUpdatedBy(user);
        Proposal dbProposal = proposalRepo.save(proposal);
        proposalAuditor.handleBeforeSave(dbProposal);
        
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
