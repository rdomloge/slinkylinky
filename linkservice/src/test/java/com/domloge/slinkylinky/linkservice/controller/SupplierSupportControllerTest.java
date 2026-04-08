package com.domloge.slinkylinky.linkservice.controller;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.List;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;

import com.domloge.slinkylinky.linkservice.config.TenantContextTest;

import com.domloge.slinkylinky.events.SupplierEngagementEvent;
import com.domloge.slinkylinky.linkservice.entity.Demand;
import com.domloge.slinkylinky.linkservice.entity.Proposal;
import com.domloge.slinkylinky.linkservice.entity.Supplier;
import com.domloge.slinkylinky.linkservice.repo.DemandRepo;
import com.domloge.slinkylinky.linkservice.repo.PaidLinkRepo;
import com.domloge.slinkylinky.linkservice.repo.ProposalRepo;
import com.domloge.slinkylinky.linkservice.repo.SupplierRepo;

/**
 * Integration tests for SupplierSupportController.processSupplierResponse.
 *
 * Covers the two response types from the supplier engagement service:
 *   ACCEPTED — marks the proposal as accepted and blog live, preserves the proposal
 *   DECLINED — aborts the proposal (deletes it and its PaidLinks); standard supplier retained
 */
@SpringBootTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
public class SupplierSupportControllerTest {

    @Autowired
    private SupplierSupportController supplierSupportController;

    @Autowired
    private ProposalSupportController proposalSupportController;

    @Autowired
    private SupplierRepo supplierRepo;

    @Autowired
    private DemandRepo demandRepo;

    @Autowired
    private PaidLinkRepo paidLinkRepo;

    @Autowired
    private ProposalRepo proposalRepo;

    @MockBean(name = "auditRabbitTemplate")
    private AmqpTemplate auditRabbitTemplate;

    @MockBean(name = "proposalsRabbitTemplate")
    private AmqpTemplate proposalsRabbitTemplate;

    @MockBean(name = "supplierRabbitTemplate")
    private AmqpTemplate supplierRabbitTemplate;

    @BeforeEach
    void setup() {
        cleanup();
        TenantContextTest.setSecurityContext("testuser", "00000000-0000-0000-0000-000000000001", List.of("global_admin"));
    }

    @AfterEach
    void clearContext() {
        SecurityContextHolder.clearContext();
    }

    void cleanup() {
        proposalRepo.deleteAll();
        paidLinkRepo.deleteAll();
        demandRepo.deleteAll();
        supplierRepo.deleteAll();
    }

    /**
     * When the supplier accepts a proposal, all acceptance flags are set on the
     * proposal and it is retained in the database.
     */
    @Test
    void processSupplierResponse_accepted_setsAllAcceptanceFlagsOnProposal() throws Exception {
        // Given
        long proposalId = createProposal();

        SupplierEngagementEvent event = new SupplierEngagementEvent();
        event.buildForAccept("The Blog Title", "https://www.supplier.com/the-blog", proposalId);

        // When
        ResponseEntity<Proposal> resp = supplierSupportController.processSupplierResponse(event, proposalId);

        // Then — HTTP 200 returned with updated proposal
        assertEquals(HttpStatusCode.valueOf(200), resp.getStatusCode());
        Proposal returned = resp.getBody();
        assertNotNull(returned);
        assertTrue(returned.isProposalAccepted());
        assertNotNull(returned.getDateAcceptedBySupplier());
        assertTrue(returned.isInvoiceReceived());
        assertNotNull(returned.getDateInvoiceReceived());
        assertTrue(returned.isBlogLive());
        assertNotNull(returned.getDateBlogLive());
        assertEquals("The Blog Title", returned.getLiveLinkTitle());
        assertEquals("https://www.supplier.com/the-blog", returned.getLiveLinkUrl());

        // Proposal is still in the database
        assertTrue(proposalRepo.findById(proposalId).isPresent(), "Accepted proposal must not be deleted");
        Proposal dbProposal = proposalRepo.findById(proposalId).get();
        assertTrue(dbProposal.isProposalAccepted());
        assertTrue(dbProposal.isBlogLive());

        cleanup();
    }

    /**
     * When the supplier declines a proposal, the proposal and all its PaidLinks are
     * deleted. The standard (non-third-party) supplier must NOT be deleted (Rule 7).
     */
    @Test
    void processSupplierResponse_declined_proposalAndPaidLinksDeletedSupplierRetained() throws Exception {
        // Given
        Supplier supplier = new Supplier();
        supplier.setName("Standard Supplier");
        supplier.setWebsite("www.standard-supplier.com");
        Supplier dbSupplier = supplierRepo.save(supplier);

        Demand demand = new Demand();
        demand.setUrl("https://www.client-site.com");
        Demand dbDemand = demandRepo.save(demand);

        ResponseEntity<Object> createResp = proposalSupportController.createProposal(
                dbSupplier.getId(), new long[]{dbDemand.getId()});
        String location = createResp.getHeaders().get("Location").get(0);
        long proposalId = Long.parseLong(location.split("/")[location.split("/").length - 1]);

        assertTrue(proposalRepo.findById(proposalId).isPresent(), "Proposal should exist before decline");
        assertEquals(1, paidLinkRepo.count(), "One PaidLink should exist before decline");

        SupplierEngagementEvent event = new SupplierEngagementEvent();
        event.buildForDecline(proposalId, "Not interested", false);

        // When
        ResponseEntity<Proposal> resp = supplierSupportController.processSupplierResponse(event, proposalId);

        // Then — HTTP 200 and proposal deleted
        assertEquals(HttpStatusCode.valueOf(200), resp.getStatusCode());
        assertFalse(proposalRepo.findById(proposalId).isPresent(), "Proposal must be deleted after decline");
        assertEquals(0, paidLinkRepo.count(), "PaidLink must be deleted after decline");
        assertTrue(supplierRepo.findById(dbSupplier.getId()).isPresent(),
                "Standard (non-third-party) supplier must NOT be deleted when proposal is declined");

        cleanup();
    }

    // ─── Helper ───────────────────────────────────────────────────────────────

    /**
     * Creates a minimal supplier + demand + proposal and returns the proposal ID.
     * Uses distinct URL domains so the duplicate paid-link check (Rule 2) is not triggered.
     */
    private long createProposal() throws Exception {
        Supplier supplier = new Supplier();
        supplier.setName("Test Supplier");
        supplier.setWebsite("www.test-supplier-accept.com");
        Supplier dbSupplier = supplierRepo.save(supplier);

        Demand demand = new Demand();
        demand.setUrl("https://www.accept-test-client.com");
        Demand dbDemand = demandRepo.save(demand);

        ResponseEntity<Object> createResp = proposalSupportController.createProposal(
                dbSupplier.getId(), new long[]{dbDemand.getId()});

        String location = createResp.getHeaders().get("Location").get(0);
        return Long.parseLong(location.split("/")[location.split("/").length - 1]);
    }
}
