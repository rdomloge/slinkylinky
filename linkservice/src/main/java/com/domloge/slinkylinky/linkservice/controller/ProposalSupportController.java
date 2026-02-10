package com.domloge.slinkylinky.linkservice.controller;

import java.net.URI;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.hibernate.envers.AuditReader;
import org.hibernate.envers.AuditReaderFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.context.ApplicationEventPublisherAware;
import org.springframework.data.rest.core.event.AfterCreateEvent;
import org.springframework.data.rest.core.event.AfterDeleteEvent;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.domloge.slinkylinky.linkservice.ProposalAbortHandler;
import com.domloge.slinkylinky.linkservice.entity.Demand;
import com.domloge.slinkylinky.linkservice.entity.PaidLink;
import com.domloge.slinkylinky.linkservice.entity.Proposal;
import com.domloge.slinkylinky.linkservice.entity.Supplier;
import com.domloge.slinkylinky.linkservice.entity.audit.ProposalAuditor;
import com.domloge.slinkylinky.linkservice.entity.audit.SupplierAuditor;
import com.domloge.slinkylinky.linkservice.repo.DemandRepo;
import com.domloge.slinkylinky.linkservice.repo.PaidLinkRepo;
import com.domloge.slinkylinky.linkservice.repo.ProposalRepo;
import com.domloge.slinkylinky.linkservice.repo.SupplierRepo;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.github.rjeschke.txtmark.Processor;

import jakarta.annotation.PostConstruct;
import jakarta.persistence.EntityManager;
import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping(".rest/proposalsupport")
@Slf4j
public class ProposalSupportController implements ApplicationEventPublisherAware {
    
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

    @Autowired
    private ProposalAbortHandler proposalAbortHandler;

    @Autowired
    private EntityManager entityManager;

    private ApplicationEventPublisher applicationEventPublisher;

    @Autowired
    private PlatformTransactionManager transactionManager;

    private TransactionTemplate transactionTemplate;


    @PostConstruct
    public void wireTransactionTemplate() {
        transactionTemplate = new TransactionTemplate(transactionManager);
    }



    @DeleteMapping(path = "/abort", produces = "text/HTML")
    @Transactional
    public ResponseEntity<Object> delete(@RequestParam long proposalId, @RequestHeader String user) {
        Optional<Proposal> opt = proposalRepo.findById(proposalId);
        if( ! opt.isPresent()) {
            return ResponseEntity.notFound().build();
        }
        proposalAbortHandler.handle(proposalId, user);
        applicationEventPublisher.publishEvent(new AfterDeleteEvent(opt.get()));
        return ResponseEntity.ok().build();
    }

    @GetMapping(path = "/getProposalsWithOriginalSuppliers", produces = "application/json")
    public ResponseEntity<Proposal[]> getProposal(@RequestParam LocalDateTime startDate, @RequestParam LocalDateTime endDate) {
        
        List<Proposal> proposals = proposalRepo.findAllByDateCreatedLessThanEqualAndDateCreatedGreaterThanEqualOrderByDateCreatedAsc(
            endDate, startDate);
        // for each proposal, check if the supplier has been updated since the proposal was created
        proposals.stream().forEach(p -> {
            Supplier currentSupplier = p.getPaidLinks().get(0).getSupplier();
            if(p.getSupplierSnapshotVersion() != currentSupplier.getVersion()) {
                AuditReader auditReader = AuditReaderFactory.get(entityManager);
                List<Number> revisions = auditReader.getRevisions(Supplier.class, currentSupplier.getId());
                Supplier originalSupplier = auditReader.find(Supplier.class, currentSupplier.getId(), revisions.get((int) p.getSupplierSnapshotVersion()));
                p.setPaidLinks(p.getPaidLinks().stream().map(pl -> {
                    pl.setSupplier(originalSupplier);
                    return pl;
                }).collect(Collectors.toList()));
            }
        });

        return ResponseEntity.ok().body(proposals.stream().toArray(Proposal[]::new));
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
    public ResponseEntity<Object> createProposal(@RequestHeader String user, @RequestParam long supplierId, 
            @RequestParam long[] demandIds) throws JsonProcessingException {
        
        log.info(user + " is creating a proposal for supplier {} for demands {} ", supplierId, Arrays.toString(demandIds));
        
        Proposal dbProposal = transactionTemplate.execute(status ->  {
            Optional<Supplier> supplierOpt = supplierRepo.findById(supplierId);
                if( ! supplierOpt.isPresent()) {
                    return null;
                }
                
                Supplier supplier = supplierOpt.get();
                
                List<Demand> dbDemands = new LinkedList<>();
                Arrays.stream(demandIds).forEach(i -> {
                    Optional<Demand> demand = demandRepo.findById(i);
                    if (demand.isEmpty()) {
                        log.error("Demand with id {} does not exist", i);
                        return;                
                    }
                    dbDemands.add(demand.get());
                });
                if(dbDemands.size() != demandIds.length) {
                    return null;
                }

                // check that there's no paid link already between the supplier and these demands (what if someone already created a proposal?)
                List<Demand> existingPaidLinks = dbDemands.stream()
                    .filter(d -> null != paidLinkRepo.findByDemandDomainAndSupplierDomain(d.getDomain(), supplier.getDomain()))
                    .collect(Collectors.toList());
                
                if(existingPaidLinks.size() > 0) {
                    log.error("There's already a paid link between supplier {} and one of the demands {}", supplierId, Arrays.toString(demandIds));
                    return null;
                }
                
                LinkedList<PaidLink> paidLinks = new LinkedList<>();

                // create the paid links
                dbDemands.forEach(d -> {
                    PaidLink paidLink = new PaidLink();
                    paidLink.setDemand(d);
                    paidLink.setSupplier(supplier);
                    PaidLink dbPaidLink = paidLinkRepo.save(paidLink);
                    paidLinks.add(dbPaidLink);
                });

                // create the proposal
                Proposal proposal = new Proposal();
                proposal.setCreatedBy(user);
                proposal.setDateCreated(LocalDateTime.now());
                proposal.setPaidLinks(paidLinks);
                proposal.setSupplierSnapshotVersion(supplier.getVersion());
                return proposalRepo.save(proposal);
        });

        if(dbProposal == null) {
            return ResponseEntity.badRequest().build();
        }

        
        proposalAuditor.handleAfterCreate(dbProposal);
        // proposalEventDispatcher.handleAfterCreate(dbProposal);
        applicationEventPublisher.publishEvent(new AfterCreateEvent(dbProposal));
        
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
        applicationEventPublisher.publishEvent(new AfterCreateEvent(dbProposal));
        
        // make sure the new proposal HREF is in the Location header of the response.
        return ResponseEntity.created(URI.create("/proposals/" + dbProposal.getId())).build();
    }

    @Override
    public void setApplicationEventPublisher(ApplicationEventPublisher applicationEventPublisher) {
        this.applicationEventPublisher = applicationEventPublisher;
    }

}
