package com.domloge.slinkylinky.linkservice.controller;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.context.SpringBootTest;
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