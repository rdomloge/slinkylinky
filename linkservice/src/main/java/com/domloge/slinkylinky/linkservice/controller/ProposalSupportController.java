package com.domloge.slinkylinky.linkservice.controller;

import java.net.URI;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.domloge.slinkylinky.common.TenantContext;
import com.domloge.slinkylinky.common.TenantFilter;

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
import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.rjeschke.txtmark.Processor;

import jakarta.annotation.PostConstruct;
import jakarta.persistence.EntityManager;
import jakarta.servlet.http.HttpServletRequest;
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

    @Autowired
    private ObjectMapper objectMapper;

    private TransactionTemplate transactionTemplate;


    @PostConstruct
    public void wireTransactionTemplate() {
        transactionTemplate = new TransactionTemplate(transactionManager);
    }



    @DeleteMapping(path = "/abort", produces = "text/HTML")
    @Transactional
    public ResponseEntity<Object> delete(@RequestParam long proposalId) {
        String user = TenantContext.getUsername();
        Optional<Proposal> opt = proposalRepo.findById(proposalId);
        if( ! opt.isPresent()) {
            return ResponseEntity.notFound().build();
        }
        proposalAbortHandler.handle(proposalId, user);
        applicationEventPublisher.publishEvent(new AfterDeleteEvent(opt.get()));
        return ResponseEntity.ok().build();
    }

    @GetMapping(path = "/getProposalsWithOriginalSuppliers", produces = "application/json")
    @Transactional
    public ResponseEntity<Proposal[]> getProposal(@RequestParam LocalDateTime startDate, @RequestParam LocalDateTime endDate,
            HttpServletRequest request) {

        UUID orgId = TenantFilter.requireOrgId(request);
        List<Proposal> proposals = proposalRepo.findAllByOrganisationIdAndDateCreatedLessThanEqualAndDateCreatedGreaterThanEqualOrderByDateCreatedAsc(
            orgId, endDate, startDate);

        // Only needed for proposals that still lack a JSON snapshot (legacy / first access).
        AuditReader auditReader = AuditReaderFactory.get(entityManager);
        // Per-request cache: avoids duplicate Envers calls when proposals share the same
        // supplier at the same snapshot version within a single request.
        Map<String, Supplier> enversCache = new HashMap<>();
        // Proposals whose supplierSnapshot was lazily populated this request — persist after the loop.
        List<Proposal> snapshotsToSave = new ArrayList<>();

        proposals.forEach(p -> {
            Supplier currentSupplier = p.getPaidLinks().get(0).getSupplier();
            if (p.getSupplierSnapshotVersion() != currentSupplier.getVersion()) {
                String cacheKey = currentSupplier.getId() + ":" + p.getSupplierSnapshotVersion();
                // Detach the current Supplier before any Envers lookup: Envers loads the same
                // entity at an older revision with version=null. Having both versions in the
                // same session causes a version conflict (see EntityManager javadoc on detach).
                entityManager.detach(currentSupplier);
                Supplier originalSupplier = enversCache.computeIfAbsent(cacheKey, k -> {
                    if (p.getSupplierSnapshot() != null) {
                        // Fast path: deserialize from stored JSON — zero Envers queries
                        try {
                            return objectMapper.readValue(p.getSupplierSnapshot(), Supplier.class);
                        } catch (Exception e) {
                            log.warn("Failed to deserialize supplier snapshot for proposal {}, falling back to Envers", p.getId(), e);
                        }
                    }
                    // Envers path: used for legacy proposals and first access before snapshot is stored
                    if (p.getSupplierSnapshotRevision() > 0) {
                        return auditReader.find(Supplier.class, currentSupplier.getId(), p.getSupplierSnapshotRevision());
                    }
                    List<Number> revisions = auditReader.getRevisions(Supplier.class, currentSupplier.getId());
                    return auditReader.find(Supplier.class, currentSupplier.getId(), revisions.get((int) p.getSupplierSnapshotVersion()));
                });

                // Lazily populate the snapshot for any proposal that doesn't have one yet,
                // so subsequent requests use JSON instead of hitting Envers again.
                if (p.getSupplierSnapshot() == null) {
                    try {
                        p.setSupplierSnapshot(objectMapper.writeValueAsString(originalSupplier));
                        snapshotsToSave.add(p);
                    } catch (JsonProcessingException ex) {
                        log.warn("Failed to serialize supplier snapshot for lazy backfill of proposal {}", p.getId(), ex);
                    }
                }

                p.setPaidLinks(p.getPaidLinks().stream().map(pl -> {
                    // Detach the PaidLink before swapping its supplier to an Envers-sourced
                    // entity (version=null).  Without this, Hibernate auto-flushes the dirty
                    // PaidLink on the next Envers query and rejects the null version.
                    entityManager.detach(pl);
                    pl.setSupplier(originalSupplier);
                    return pl;
                }).collect(Collectors.toList()));
            }
        });

        // Clear the Hibernate session unconditionally: PaidLinks were mutated in memory to
        // reference Envers-sourced Supplier objects that have version=null (Envers does not
        // store the @Version field in supplier_aud). Without this, the @Transactional flush
        // at method exit rejects the null version on BOTH the backfill path AND the fast
        // JSON-deserialization path. Clearing drops dirty tracking; the already-loaded
        // in-memory objects are unaffected and still serializable by Jackson.
        entityManager.clear();
        if (!snapshotsToSave.isEmpty()) {
            snapshotsToSave.forEach(p -> proposalRepo.updateSupplierSnapshot(p.getId(), p.getSupplierSnapshot()));
        }

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
    public ResponseEntity<Object> createProposal(@RequestParam long supplierId,
            @RequestParam long[] demandIds, HttpServletRequest request) throws JsonProcessingException {
        String user = TenantContext.getUsername();
        UUID orgId = TenantFilter.requireOrgId(request);

        log.info(user + " is creating a proposal for supplier {} for demands {} ", supplierId, Arrays.toString(demandIds));

        // 0 = ok, 400 = conflict, 404 = not found
        int[] errorStatus = {0};

        Proposal dbProposal;
        try {
        dbProposal = transactionTemplate.execute(status ->  {
            Optional<Supplier> supplierOpt = supplierRepo.findById(supplierId);
                if( ! supplierOpt.isPresent()) {
                    errorStatus[0] = 404;
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
                    errorStatus[0] = 404;
                    return null;
                }

                // check that there's no paid link already between the supplier and these demands (Rule 2 — cross-org: same two domains give no extra SEO value)
                List<Demand> existingPaidLinks = dbDemands.stream()
                    .filter(d -> null != paidLinkRepo.findByDemandDomainAndSupplierDomain(
                            d.getDomain(), supplier.getDomain()))
                    .collect(Collectors.toList());

                if(existingPaidLinks.size() > 0) {
                    log.error("There's already a paid link between supplier {} and one of the demands {}", supplierId, Arrays.toString(demandIds));
                    errorStatus[0] = 400;
                    return null;
                }

                LinkedList<PaidLink> paidLinks = new LinkedList<>();

                // create the paid links
                dbDemands.forEach(d -> {
                    PaidLink paidLink = new PaidLink();
                    paidLink.setDemand(d);
                    paidLink.setSupplier(supplier);
                    paidLink.setOrganisationId(orgId);
                    PaidLink dbPaidLink = paidLinkRepo.save(paidLink);
                    paidLinks.add(dbPaidLink);
                });

                // Capture the current Envers revision number for the supplier so that
                // legacy Envers lookups (for proposals without a JSON snapshot) can do a
                // direct find() without a preceding getRevisions() call.
                long snapshotRevision = 0;
                try {
                    List<Number> supplierRevisions = AuditReaderFactory.get(entityManager)
                            .getRevisions(Supplier.class, supplier.getId());
                    snapshotRevision = supplierRevisions.isEmpty() ? 0
                            : supplierRevisions.get(supplierRevisions.size() - 1).longValue();
                } catch (Exception e) {
                    log.warn("Could not read Envers revisions for supplier {} — snapshotRevision will be 0", supplier.getId(), e);
                }

                // Serialize the supplier as a JSON snapshot so getProposalsWithOriginalSuppliers
                // can restore the original state at read time without any Envers queries.
                String supplierSnapshotJson = null;
                try {
                    supplierSnapshotJson = objectMapper.writeValueAsString(supplier);
                } catch (JsonProcessingException ex) {
                    log.warn("Failed to serialize supplier snapshot at proposal creation — Envers will be used as fallback on reads", ex);
                }

                // create the proposal
                Proposal proposal = new Proposal();
                proposal.setCreatedBy(user);
                proposal.setOrganisationId(orgId);
                proposal.setDateCreated(LocalDateTime.now());
                proposal.setPaidLinks(paidLinks);
                proposal.setSupplierSnapshotVersion(supplier.getVersion());
                proposal.setSupplierSnapshotRevision(snapshotRevision);
                proposal.setSupplierSnapshot(supplierSnapshotJson);
                return proposalRepo.save(proposal);
        });
        } catch (Exception e) {
            log.error("Failed to create proposal for supplier {} demands {}", supplierId, Arrays.toString(demandIds), e);
            String message = e.getMessage() != null ? e.getMessage() : e.getClass().getSimpleName();
            return ResponseEntity.internalServerError().body(Map.of("error", message));
        }

        if(dbProposal == null) {
            return errorStatus[0] == 404
                ? ResponseEntity.notFound().build()
                : ResponseEntity.badRequest().build();
        }

        
        proposalAuditor.handleAfterCreate(dbProposal);
        // proposalEventDispatcher.handleAfterCreate(dbProposal);
        applicationEventPublisher.publishEvent(new AfterCreateEvent(dbProposal));
        
        // make sure the new proposal HREF is in the Location header of the response.
        return ResponseEntity.created(URI.create("/proposals/" + dbProposal.getId())).build();
    }

    @PatchMapping(path = "/addarticle", produces = "application/json")
    @Transactional
    public ResponseEntity<Object> addArticle(@RequestParam long proposalId,
            @RequestBody String article) {
        String user = TenantContext.getUsername();
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
            @RequestParam String name, @RequestParam int demandId, HttpServletRequest request) {
        String user = TenantContext.getUsername();
        UUID orgId = TenantFilter.requireOrgId(request);
        log.info(user + " is resolving demand " + demandId + " with 3rd party supplier " + name);

        // create the 3rd party supplier (bypasses SupplierWriteGuard — internal use only)
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
        paidLink.setOrganisationId(orgId);
        PaidLink dbPaidLink = paidLinkRepo.save(paidLink);

        // create the proposal with the paidlink added to it
        Proposal proposal = new Proposal();
        proposal.setCreatedBy(user);
        proposal.setOrganisationId(orgId);
        proposal.setDateCreated(LocalDateTime.now());
        proposal.setPaidLinks(Arrays.asList(dbPaidLink));
        Proposal dbProposal = proposalRepo.save(proposal);
        proposalAuditor.handleAfterCreate(dbProposal);
        applicationEventPublisher.publishEvent(new AfterCreateEvent(dbProposal));

        // make sure the new proposal HREF is in the Location header of the response.
        return ResponseEntity.created(URI.create("/proposals/" + dbProposal.getId())).build();
    }

    @GetMapping(path = "/responsivenessData", produces = "application/json")
    @Transactional
    public ResponseEntity<List<ResponsivenessDataPoint>> getResponsivenessData() {
        List<Proposal> proposals = proposalRepo.findCompletedProposalsWithBothDates();

        Map<Long, List<ResponsivenessDataPoint>> bySupplier = new HashMap<>();

        for (Proposal p : proposals) {
            if (p.getPaidLinks() == null || p.getPaidLinks().isEmpty()) continue;
            var supplier = p.getPaidLinks().get(0).getSupplier();
            if (supplier == null || supplier.getDomain() == null) continue;

            long supplierId = supplier.getId();
            List<ResponsivenessDataPoint> points = bySupplier.computeIfAbsent(supplierId, k -> new ArrayList<>());
            // Already ordered by dateBlogLive DESC from the query, so take first 10
            if (points.size() < 10) {
                points.add(new ResponsivenessDataPoint(
                    supplierId,
                    supplier.getDomain(),
                    p.getDateSentToSupplier(),
                    p.getDateBlogLive()
                ));
            }
        }

        List<ResponsivenessDataPoint> result = bySupplier.values().stream()
            .flatMap(List::stream)
            .collect(Collectors.toList());

        return ResponseEntity.ok(result);
    }

    @Override
    public void setApplicationEventPublisher(ApplicationEventPublisher applicationEventPublisher) {
        this.applicationEventPublisher = applicationEventPublisher;
    }

}
