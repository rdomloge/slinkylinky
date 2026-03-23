package com.domloge.slinkylinky.linkservice.controller;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;

import com.domloge.slinkylinky.linkservice.entity.Category;
import com.domloge.slinkylinky.linkservice.entity.Demand;
import com.domloge.slinkylinky.linkservice.entity.PaidLink;
import com.domloge.slinkylinky.linkservice.entity.Proposal;
import com.domloge.slinkylinky.linkservice.entity.Supplier;
import com.domloge.slinkylinky.linkservice.repo.CategoryRepo;
import com.domloge.slinkylinky.linkservice.repo.DemandRepo;
import com.domloge.slinkylinky.linkservice.repo.PaidLinkRepo;
import com.domloge.slinkylinky.linkservice.repo.ProposalRepo;
import com.domloge.slinkylinky.linkservice.repo.SupplierRepo;
import com.fasterxml.jackson.core.JsonProcessingException;

import jakarta.persistence.EntityManager;
import jakarta.transaction.Transactional;


@SpringBootTest
@AutoConfigureTestDatabase( replace = AutoConfigureTestDatabase.Replace.NONE )
public class ProposalSupportControllerTest {

    @Autowired
    private ProposalSupportController controller;

    @Autowired
    private SupplierRepo supplierRepo;

    @Autowired
    private DemandRepo demandRepo;

    @Autowired
    private PaidLinkRepo paidLinkRepo;

    @Autowired 
    private ProposalRepo proposalRepo;

    @Autowired
    private CategoryRepo categoryRepo;

    @Autowired
    private EntityManager em;

    // Prevent actual RabbitMQ connections: tests call the controller directly and don't
    // need messaging side-effects. All three templates used by auditors and dispatchers
    // are replaced with no-op mocks.
    @MockBean(name = "auditRabbitTemplate")
    private AmqpTemplate auditRabbitTemplate;

    @MockBean(name = "proposalsRabbitTemplate")
    private AmqpTemplate proposalsRabbitTemplate;

    @MockBean(name = "supplierRabbitTemplate")
    private AmqpTemplate supplierRabbitTemplate;


    @BeforeEach
    void cleanupBeforeEach() {
        cleanup();
    }

    @Test
    // @Transactional() -- can't be transactional because envers does not write until transaction is committed
    // this means that the audit records are not written until the transaction is committed and the controller
    // finds no audit records when it tries to read them and fix the Proposal
    void createProposal_supplierUpdated_originalSupplierReturned() throws JsonProcessingException {
        // Given
        Supplier supplier = new Supplier();
        supplier.setDa(10);
        supplier.setName("somebody");
        supplier.setWebsite("www.tesco.com");
        supplier.setDisabled(false);
        supplier.setSource("source");
        supplier.setWeWriteFee(100);
        
        List<Category> testCategories = createTestCategories();
        categoryRepo.saveAll(testCategories);
        supplier.setCategories(new HashSet<>(testCategories));
        Supplier dbSupplier = supplierRepo.save(supplier);

        Demand demand = new Demand();
        Demand dbDemand = demandRepo.save(demand);


        // When
        ResponseEntity<Object> response = controller.createProposal("somebody", dbSupplier.getId(), new long[]{dbDemand.getId()});
        List<String> locationHeaders = response.getHeaders().get("Location");
        String location = locationHeaders.get(0);
        String[] parts = location.split("/");
        long proposalId = Long.parseLong(parts[parts.length-1]);
        Proposal dbProposal = proposalRepo.findById(proposalId).get();


        
        dbSupplier.setDa(200);
        Category categoryToRemove = new LinkedList<>(dbSupplier.getCategories()).get(0);
        dbSupplier.getCategories().remove(categoryToRemove);
        dbSupplier.setName("new name");
        dbSupplier.setWebsite("www.newwebsite.com");
        dbSupplier.setDisabled(true);
        dbSupplier.setSource("new source");
        dbSupplier.setWeWriteFee(200);
        supplierRepo.save(dbSupplier);

        
        ResponseEntity<Proposal[]> resp = controller.getProposal(LocalDateTime.now().minusHours(1), LocalDateTime.now());
        Supplier latestSupplier = supplierRepo.findById(dbSupplier.getId()).get();
        
        // Then
        assertTrue(resp.getStatusCode() == HttpStatusCode.valueOf(200));
        assertTrue(resp != null);
        assertTrue(resp.getBody() != null);
        Proposal[] proposals = resp.getBody();

        assertTrue(proposals.length == 1, "Wrong number of proposals returned");
        assertTrue(proposals[0].getId() == dbProposal.getId());
        assertTrue(proposals[0].getPaidLinks().size() == 1);
        assertTrue(proposals[0].getPaidLinks().get(0).getSupplier().getDa() == 10);
        assertTrue(proposals[0].getPaidLinks().get(0).getSupplier().getCategories().size() == testCategories.size());
        assertTrue(proposals[0].getPaidLinks().get(0).getSupplier().getName().equals("somebody"));
        assertTrue(proposals[0].getPaidLinks().get(0).getSupplier().getWebsite().equals("www.tesco.com"));
        assertTrue(proposals[0].getPaidLinks().get(0).getSupplier().isDisabled() == false);
        assertTrue(proposals[0].getPaidLinks().get(0).getSupplier().getSource().equals("source"));
        assertTrue(proposals[0].getPaidLinks().get(0).getSupplier().getWeWriteFee() == 100);

        assertTrue(latestSupplier.getDa() == 200);
        assertTrue(latestSupplier.getCategories().size() == testCategories.size() - 1, "Categories not updated");
        assertTrue(latestSupplier.getName().equals("new name"));
        assertTrue(latestSupplier.getWebsite().equals("www.newwebsite.com"));
        assertTrue(latestSupplier.isDisabled() == true);
        assertTrue(latestSupplier.getSource().equals("new source"));
        assertTrue(latestSupplier.getWeWriteFee() == 200);

        cleanup();
    }

    private void cleanup() {
        proposalRepo.deleteAll();
        paidLinkRepo.deleteAll();
        demandRepo.deleteAll();
        supplierRepo.deleteAll();
        categoryRepo.deleteAll();
    }

    @Test
    void testGetProposal_supplierUpdated_originalSupplierReturned() {
        // Given
        Supplier supplier = new Supplier();
        supplier.setDa(10);
        supplier.setName("somebody");
        supplier.setWebsite("www.tesco.com");
        supplier.setDisabled(false);
        supplier.setSource("source");
        supplier.setWeWriteFee(100);
        
        List<Category> testCategories = createTestCategories();
        categoryRepo.saveAll(testCategories);
        supplier.setCategories(new HashSet<>(testCategories));
        Supplier dbSupplier = supplierRepo.save(supplier);

        Proposal proposal = new Proposal();
        proposal.setDateCreated(LocalDateTime.now());
        Demand demand = new Demand();
        demandRepo.save(demand);
        PaidLink paidLink = new PaidLink();
        paidLink.setSupplier(dbSupplier);
        paidLink.setDemand(demand);
        paidLinkRepo.save(paidLink);
        proposal.setPaidLinks(List.of(paidLink));
        Proposal dbProposal = proposalRepo.save(proposal);

        // When
        dbSupplier.setDa(200);
        Category categoryToRemove = new LinkedList<>(dbSupplier.getCategories()).get(0);
        dbSupplier.getCategories().remove(categoryToRemove);
        dbSupplier.setName("new name");
        dbSupplier.setWebsite("www.newwebsite.com");
        dbSupplier.setDisabled(true);
        dbSupplier.setSource("new source");
        dbSupplier.setWeWriteFee(200);
        supplierRepo.save(dbSupplier);

        
        ResponseEntity<Proposal[]> resp = controller.getProposal(LocalDateTime.now().minusHours(1), LocalDateTime.now());
        Supplier latestSupplier = supplierRepo.findById(dbSupplier.getId()).get();
        
        // Then
        assertTrue(resp.getStatusCode() == HttpStatusCode.valueOf(200));
        assertTrue(resp != null);
        assertTrue(resp.getBody() != null);
        Proposal[] proposals = resp.getBody();

        assertTrue(proposals.length == 1, "Wrong number of proposals returned");
        assertTrue(proposals[0].getId() == dbProposal.getId());
        assertTrue(proposals[0].getPaidLinks().size() == 1);
        assertTrue(proposals[0].getPaidLinks().get(0).getSupplier().getDa() == 10);
        assertTrue(proposals[0].getPaidLinks().get(0).getSupplier().getCategories().size() == testCategories.size());
        assertTrue(proposals[0].getPaidLinks().get(0).getSupplier().getName().equals("somebody"));
        assertTrue(proposals[0].getPaidLinks().get(0).getSupplier().getWebsite().equals("www.tesco.com"));
        assertTrue(proposals[0].getPaidLinks().get(0).getSupplier().isDisabled() == false);
        assertTrue(proposals[0].getPaidLinks().get(0).getSupplier().getSource().equals("source"));
        assertTrue(proposals[0].getPaidLinks().get(0).getSupplier().getWeWriteFee() == 100);

        assertTrue(latestSupplier.getDa() == 200);
        assertTrue(latestSupplier.getCategories().size() == testCategories.size()-1, "Categories not updated");
        assertTrue(latestSupplier.getName().equals("new name"));
        assertTrue(latestSupplier.getWebsite().equals("www.newwebsite.com"));
        assertTrue(latestSupplier.isDisabled() == true);
        assertTrue(latestSupplier.getSource().equals("new source"));
        assertTrue(latestSupplier.getWeWriteFee() == 200);

        cleanup();
    }
    

    @Test
    @Transactional
    void testCreateProposal_supplierDoesNotExist() throws JsonProcessingException {
        // Given
        // nothing to do here

        // When
        ResponseEntity<Object> response = controller.createProposal("somebody", 23L, new long[]{1,2,3});
        
        // Then
        assertTrue(response.getStatusCode() == HttpStatusCode.valueOf(404));
    }

    @Test
    @Transactional
    void testCreateProposal_supplierExistsDemandNotFound() throws JsonProcessingException {
        // Given
        Supplier supplier = new Supplier();
        supplier.setName("somebody");
        Supplier dbSupplier = supplierRepo.save(supplier);

        // When
        ResponseEntity<Object> response = controller.createProposal("somebody", dbSupplier.getId(), new long[]{1,2,3});
        
        // Then
        assertEquals(response.getStatusCode(), HttpStatusCode.valueOf(404));
    }

    @Test
    @Transactional
    void testCreateProposal_supplierAlreadyLinkedToDemand() throws JsonProcessingException {
        // Given
        Supplier supplier = new Supplier();
        supplier.setName("somebody");
        supplier.setWebsite("www.tesco.com");
        supplier.setDomain("tesco.com");
        Supplier dbSupplier = supplierRepo.save(supplier);

        Demand demand = new Demand();
        demand.setUrl("http://www.example.com");
        demand.setDomain("example.com");
        demand.setAnchorText("anchor text");
        demand.setCreatedBy("somebody");
        demand.setDaNeeded(1);
        demand.setRequested(LocalDateTime.now());
        demand.setName("name");
        Demand dbDemand = demandRepo.save(demand);

        PaidLink paidLink = new PaidLink();
        paidLink.setDemand(dbDemand);
        paidLink.setSupplier(dbSupplier);
        paidLinkRepo.save(paidLink);

        // When
        ResponseEntity<Object> response = controller.createProposal("somebody", dbSupplier.getId(), new long[]{dbDemand.getId()});
        
        // Then
        assertEquals(response.getStatusCode(), HttpStatusCode.valueOf(400));
    }

    /**
     * When the supplier has not changed since the proposal was created, the version
     * fields match and no snapshot restoration is applied — the proposal's paidLink
     * already points to the current supplier, which is returned as-is.
     */
    @Test
    void proposalFetch_supplierUnchanged_currentDataReturnedDirectly() throws JsonProcessingException {
        // Given
        Supplier supplier = new Supplier();
        supplier.setDa(55);
        supplier.setName("stable-supplier");
        supplier.setWebsite("www.stable.com");
        Supplier dbSupplier = supplierRepo.save(supplier);

        Demand demand = new Demand();
        Demand dbDemand = demandRepo.save(demand);
        controller.createProposal("testuser", dbSupplier.getId(), new long[]{dbDemand.getId()});

        // When – supplier NOT updated, fetch immediately
        ResponseEntity<Proposal[]> resp = controller.getProposal(LocalDateTime.now().minusHours(1), LocalDateTime.now());

        // Then – current supplier data returned unchanged; snapshot restoration not triggered
        assertEquals(HttpStatusCode.valueOf(200), resp.getStatusCode());
        Proposal[] proposals = resp.getBody();
        assertEquals(1, proposals.length);
        Supplier returnedSupplier = proposals[0].getPaidLinks().get(0).getSupplier();
        assertEquals(55, returnedSupplier.getDa());
        assertEquals("stable-supplier", returnedSupplier.getName());

        // Supplier in DB also reflects unchanged state
        Supplier dbCurrentSupplier = supplierRepo.findById(dbSupplier.getId()).get();
        assertEquals(55, dbCurrentSupplier.getDa());
        assertEquals("stable-supplier", dbCurrentSupplier.getName());

        cleanup();
    }

    /**
     * A legacy proposal that has no JSON snapshot (supplierSnapshot=null) causes the
     * controller to fall back to Envers to reconstruct the original supplier. The result
     * is then lazily persisted back to the proposal row so that subsequent reads use the
     * fast JSON path instead of hitting Envers again.
     */
    @Test
    void legacyProposal_firstAccess_snapshotBackfilledToDatabase() {
        // Given – manually construct a legacy proposal with no snapshot fields set
        Supplier supplier = new Supplier();
        supplier.setDa(10);
        supplier.setName("legacy-supplier");
        supplier.setWebsite("www.legacy.com");
        List<Category> categories = createTestCategories();
        categoryRepo.saveAll(categories);
        supplier.setCategories(new HashSet<>(categories));
        Supplier dbSupplier = supplierRepo.save(supplier);

        Demand demand = new Demand();
        demandRepo.save(demand);

        PaidLink paidLink = new PaidLink();
        paidLink.setSupplier(dbSupplier);
        paidLink.setDemand(demand);
        paidLinkRepo.save(paidLink);

        Proposal proposal = new Proposal();
        proposal.setDateCreated(LocalDateTime.now());
        proposal.setPaidLinks(List.of(paidLink));
        // supplierSnapshot and supplierSnapshotRevision left at defaults (null / 0) — legacy state
        Proposal dbProposal = proposalRepo.save(proposal);

        dbSupplier.setDa(999);
        dbSupplier.setName("updated-legacy-supplier");
        supplierRepo.save(dbSupplier);

        // When – first access: Envers fallback used, snapshot lazily written to DB
        ResponseEntity<Proposal[]> firstResp = controller.getProposal(LocalDateTime.now().minusHours(1), LocalDateTime.now());

        // Then – original supplier returned
        Proposal[] firstProposals = firstResp.getBody();
        assertEquals(1, firstProposals.length);
        assertEquals(10,              firstProposals[0].getPaidLinks().get(0).getSupplier().getDa());
        assertEquals("legacy-supplier", firstProposals[0].getPaidLinks().get(0).getSupplier().getName());

        // Snapshot has now been backfilled in the database
        String storedSnapshot = proposalRepo.findById(dbProposal.getId()).get().getSupplierSnapshot();
        assertNotNull(storedSnapshot, "Supplier snapshot should have been lazily backfilled after first Envers access");

        // When – second access: snapshot exists, JSON fast path used
        ResponseEntity<Proposal[]> secondResp = controller.getProposal(LocalDateTime.now().minusHours(1), LocalDateTime.now());

        // Then – same original supplier data returned, now from JSON snapshot
        Proposal[] secondProposals = secondResp.getBody();
        assertEquals(1, secondProposals.length);
        assertEquals(10,              secondProposals[0].getPaidLinks().get(0).getSupplier().getDa());
        assertEquals("legacy-supplier", secondProposals[0].getPaidLinks().get(0).getSupplier().getName());

        // Updated supplier still visible when fetched directly
        assertEquals(999, supplierRepo.findById(dbSupplier.getId()).get().getDa());

        cleanup();
    }

    /**
     * Two proposals created for the same supplier (against different demands) are both
     * returned in a single list call. After the supplier is updated, both proposals must
     * show the supplier as it was at proposal-creation time, not the current state.
     */
    @Test
    void twoProposals_sameSupplier_bothReturnOriginalSupplierData() throws JsonProcessingException {
        // Given
        Supplier supplier = new Supplier();
        supplier.setDa(20);
        supplier.setName("shared-supplier");
        supplier.setWebsite("www.shared-supplier.com");
        Supplier dbSupplier = supplierRepo.save(supplier);

        // Use distinct demand domains to satisfy the duplicate paid-link check
        Demand demand1 = new Demand();
        demand1.setUrl("http://www.site-a.com");
        demand1.setDomain("site-a.com");
        Demand dbDemand1 = demandRepo.save(demand1);

        Demand demand2 = new Demand();
        demand2.setUrl("http://www.site-b.com");
        demand2.setDomain("site-b.com");
        Demand dbDemand2 = demandRepo.save(demand2);

        controller.createProposal("testuser", dbSupplier.getId(), new long[]{dbDemand1.getId()});
        controller.createProposal("testuser", dbSupplier.getId(), new long[]{dbDemand2.getId()});

        dbSupplier.setDa(300);
        dbSupplier.setName("updated-shared-supplier");
        supplierRepo.save(dbSupplier);

        // When
        ResponseEntity<Proposal[]> resp = controller.getProposal(LocalDateTime.now().minusHours(1), LocalDateTime.now());

        // Then – both proposals show the original supplier, not the updated one
        Proposal[] proposals = resp.getBody();
        assertEquals(2, proposals.length);
        for (Proposal p : proposals) {
            Supplier returned = p.getPaidLinks().get(0).getSupplier();
            assertEquals(20,               returned.getDa(),   "Proposal " + p.getId() + " should show original DA");
            assertEquals("shared-supplier", returned.getName(), "Proposal " + p.getId() + " should show original name");
        }

        // Current supplier in the repository reflects the update
        Supplier currentSupplier = supplierRepo.findById(dbSupplier.getId()).get();
        assertEquals(300, currentSupplier.getDa());
        assertEquals("updated-shared-supplier", currentSupplier.getName());

        cleanup();
    }

    /**
     * Simulates the proposal detail-page view: a narrow date window around the proposal's
     * creation time is used to fetch exactly one proposal. After the supplier is updated,
     * the proposal must still carry the original supplier details, while the supplier
     * repository reflects the latest state.
     */
    @Test
    void proposalDetail_narrowDateRange_originalSupplierReturned() throws JsonProcessingException {
        // Given
        Supplier supplier = new Supplier();
        supplier.setDa(77);
        supplier.setName("detail-supplier");
        supplier.setWebsite("www.detail-test.com");
        Supplier dbSupplier = supplierRepo.save(supplier);

        Demand demand = new Demand();
        Demand dbDemand = demandRepo.save(demand);

        LocalDateTime beforeCreate = LocalDateTime.now();
        ResponseEntity<Object> createResp = controller.createProposal("testuser", dbSupplier.getId(), new long[]{dbDemand.getId()});
        String location = createResp.getHeaders().get("Location").get(0);
        long proposalId = Long.parseLong(location.split("/")[location.split("/").length - 1]);
        LocalDateTime afterCreate = LocalDateTime.now();

        dbSupplier.setDa(999);
        dbSupplier.setName("updated-detail-supplier");
        dbSupplier.setDisabled(true);
        supplierRepo.save(dbSupplier);

        // When – narrow window matching exactly when this proposal was created (detail-page style)
        ResponseEntity<Proposal[]> resp = controller.getProposal(
            beforeCreate.minusSeconds(1), afterCreate.plusSeconds(1));

        // Then – exactly one proposal returned with original supplier data
        assertEquals(HttpStatusCode.valueOf(200), resp.getStatusCode());
        Proposal[] proposals = resp.getBody();
        assertEquals(1, proposals.length, "Should return exactly the one proposal");
        assertEquals(proposalId, proposals[0].getId());

        Supplier returnedSupplier = proposals[0].getPaidLinks().get(0).getSupplier();
        assertEquals(77,                   returnedSupplier.getDa());
        assertEquals("detail-supplier",    returnedSupplier.getName());
        assertEquals("www.detail-test.com", returnedSupplier.getWebsite());
        assertFalse(returnedSupplier.isDisabled());

        // Supplier repository returns the updated values (latest version visible in listings)
        Supplier currentSupplier = supplierRepo.findById(dbSupplier.getId()).get();
        assertEquals(999,                      currentSupplier.getDa());
        assertEquals("updated-detail-supplier", currentSupplier.getName());
        assertTrue(currentSupplier.isDisabled());

        cleanup();
    }

    private List<Category> createTestCategories() {
        List<Category> categories = new ArrayList<>();

        String[] businessTypes = {"Retail", "Healthcare", "Technology", "Finance", "Manufacturing"};

        for (String businessType : businessTypes) {
            Category category = new Category();
            category.setName(businessType);
            categories.add(category);
        }

        return categories;
    }
}