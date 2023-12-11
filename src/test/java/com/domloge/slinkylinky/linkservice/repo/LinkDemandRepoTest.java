package com.domloge.slinkylinky.linkservice.repo;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.ArrayList;
import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;

import com.domloge.slinkylinky.linkservice.entity.Category;
import com.domloge.slinkylinky.linkservice.entity.LinkDemand;
import com.domloge.slinkylinky.linkservice.entity.Supplier;

@DataJpaTest
public class LinkDemandRepoTest {

    @Autowired
    private LinkDemandRepo linkDemandRepo;

    @Autowired
    private SupplierRepo supplierRepo;

    @Autowired
    private CategoryRepo categoryRepo;


    @Test
    public void testFindDemandForSupplierId_domainNotMatching() {
        // Given
        List<Category> testCategories = createTestCategories();
        categoryRepo.saveAll(testCategories);
        
        Supplier testSupplier = createTestSupplier();
        testSupplier.setCategories(testCategories);
        testSupplier = supplierRepo.save(testSupplier);

        LinkDemand testLinkDemand = createTestLinkDemand();
        testLinkDemand = linkDemandRepo.save(testLinkDemand);

        LinkDemand daNotMatchingLd = createTestLinkDemand();
        daNotMatchingLd.setCategories(testCategories);
        daNotMatchingLd.setDaNeeded(testSupplier.getDa() + 1);
        daNotMatchingLd.setUrl("www.bca.co.uk");
        LinkDemand daMatchingLd = createTestLinkDemand();
        daMatchingLd.setCategories(testCategories);
        daMatchingLd.setUrl("www.disney.com");
        daMatchingLd.setDaNeeded(testSupplier.getDa());

        linkDemandRepo.saveAll(List.of(daNotMatchingLd, daMatchingLd));
        
        // WHEN
        // Call the method under test
        LinkDemand[] result = linkDemandRepo.findDemandForSupplierId((int)testSupplier.getId(), (int)testLinkDemand.getId());

        // THEN        
        assertThat(result.length).isEqualTo(1);
        LinkDemand[] expectedLinkDemands = { daMatchingLd }; 
        assertThat(result).isEqualTo(expectedLinkDemands);
    }

    private LinkDemand createTestLinkDemand() {
        LinkDemand linkDemand = new LinkDemand();
        linkDemand.setName("Test Link Demand");
        linkDemand.setUrl("www.testlinkdemand.com");
        linkDemand.setAnchorText("Test Anchor Text");
        linkDemand.setCreatedBy("Test User");
        linkDemand.setDaNeeded(10);
        
        return linkDemand;
    }
    
    private Supplier createTestSupplier() {
        Supplier supplier = new Supplier();
        supplier.setName("Test Supplier");
        supplier.setEmail("testsupplier@test.com");
        supplier.setDa(10);
        supplier.setWebsite("www.testsupplier.com");
        supplier.setWeWriteFee(100);
        supplier.setWeWriteFeeCurrency("USD");
        supplier.setSemRushAuthorityScore(20);
        supplier.setSemRushUkMonthlyTraffic(300);
        supplier.setSemRushUkJan23Traffic(400);
        supplier.setThirdParty(false);
        supplier.setDisabled(false);        

        return supplier;
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