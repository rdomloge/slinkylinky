package com.domloge.slinkylinky.linkservice.controller;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertEquals;

import java.time.LocalDateTime;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;

import com.domloge.slinkylinky.linkservice.entity.Demand;
import com.domloge.slinkylinky.linkservice.entity.PaidLink;
import com.domloge.slinkylinky.linkservice.entity.Supplier;
import com.domloge.slinkylinky.linkservice.repo.DemandRepo;
import com.domloge.slinkylinky.linkservice.repo.PaidLinkRepo;
import com.domloge.slinkylinky.linkservice.repo.SupplierRepo;


@SpringBootTest
public class ProposalSupportControllerTest {

    @Autowired
    private ProposalSupportController controller;

    @Autowired
    private SupplierRepo supplierRepo;

    @Autowired
    private DemandRepo demandRepo;

    @Autowired
    private PaidLinkRepo paidLinkRepo;
    

    @Test
    void testCreateProposal_supplierDoesNotExist() {
        // Given
        // nothing to do here

        // When
        ResponseEntity<Object> response = controller.createProposal("somebody", 23L, new long[]{1,2,3});
        
        // Then
        assertThat(response.getStatusCode() == HttpStatusCode.valueOf(404));
    }

    @Test
    void testCreateProposal_supplierExistsDemandNotFound() {
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
    void testCreateProposal_supplierAlreadyLinkedToDemand() {
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
}