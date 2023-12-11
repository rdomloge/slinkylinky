package com.domloge.slinkylinky.linkservice.repo;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;

import com.domloge.slinkylinky.linkservice.entity.LinkDemand;

@DataJpaTest
public class LinkDemandRepoTest {

    @Autowired
    private TestEntityManager entityManager;

    @Autowired
    private LinkDemandRepo linkDemandRepo;

    @Test
    public void testFindDemandForSupplierId() {
        // Given
        
        // When
        // Then

        // Create and persist mock data
        // Use the entityManager to persist LinkDemand, Supplier, SupplierCategories, LinkDemandCategories, PaidLink

        // Call the method under test
        LinkDemand[] result = linkDemandRepo.findDemandForSupplierId(1, 2);

        // Assert the results
        // Replace expectedLinkDemands with the expected results
        LinkDemand[] expectedLinkDemands = {}; 
        assertThat(result).isEqualTo(expectedLinkDemands);
    }

    // Write a similar test for the second query method
}