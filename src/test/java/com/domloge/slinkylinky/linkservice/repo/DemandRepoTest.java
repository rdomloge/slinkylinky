package com.domloge.slinkylinky.linkservice.repo;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.ArrayList;
import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;

import com.domloge.slinkylinky.linkservice.entity.Category;
import com.domloge.slinkylinky.linkservice.entity.Demand;
import com.domloge.slinkylinky.linkservice.entity.PaidLink;
import com.domloge.slinkylinky.linkservice.entity.Supplier;

@DataJpaTest
public class DemandRepoTest {

    @Autowired
    private DemandRepo linkDemandRepo;

    @Autowired
    private SupplierRepo supplierRepo;

    @Autowired
    private CategoryRepo categoryRepo;

    @Autowired
    private PaidLinkRepo paidLinkRepo;

    @Test
    public void testFindDemandForSupplierId_noDomainDupes() {
        // Given
        List<Category> testCategories = createTestCategories();
        categoryRepo.saveAll(testCategories);
        
        Supplier testSupplier = createTestSupplier();
        testSupplier.setCategories(testCategories);
        testSupplier = supplierRepo.save(testSupplier);

        Demand selectedDemand = createTestLinkDemand();
        selectedDemand.setCategories(testCategories);
        selectedDemand = linkDemandRepo.save(selectedDemand);

        Demand otherMatchingDemandFromSameClient = createTestLinkDemand();
        otherMatchingDemandFromSameClient.setCategories(testCategories);
        linkDemandRepo.save(otherMatchingDemandFromSameClient);

        
        // WHEN
        // Call the method under test
        Demand[] result = linkDemandRepo.findDemandForSupplierId((int)testSupplier.getId(), (int)selectedDemand.getId());

        // THEN        
        assertThat(result.length).isEqualTo(0);
    }

    @Test
    public void testFindDemandForSupplierId_noMatchPreviousPaidLinks() {
        // Given
        List<Category> testCategories = createTestCategories();
        categoryRepo.saveAll(testCategories);
        
        Supplier testSupplier = createTestSupplier();
        testSupplier.setCategories(testCategories);
        testSupplier = supplierRepo.save(testSupplier);

        Demand testLinkDemand = createTestLinkDemand();
        testLinkDemand.setCategories(testCategories);
        testLinkDemand.setDaNeeded(5);
        testLinkDemand = linkDemandRepo.save(testLinkDemand);

        Demand otherMatchingDemand = createTestLinkDemand();
        otherMatchingDemand.setCategories(testCategories);
        otherMatchingDemand.setDaNeeded(5);
        otherMatchingDemand.setUrl("www.toysrus.com");
        linkDemandRepo.save(otherMatchingDemand);

        Demand currentDemandPreviouslyLinkedFromSupplier = createTestLinkDemand();
        currentDemandPreviouslyLinkedFromSupplier.setCategories(testCategories);
        currentDemandPreviouslyLinkedFromSupplier.setUrl("www.bca.co.uk");
        currentDemandPreviouslyLinkedFromSupplier.setDaNeeded(testSupplier.getDa());
        linkDemandRepo.save(currentDemandPreviouslyLinkedFromSupplier);
        PaidLink paidLink = new PaidLink();
        paidLink.setDemand(currentDemandPreviouslyLinkedFromSupplier);
        paidLink.setSupplier(testSupplier);
        paidLinkRepo.save(paidLink);
        
        // WHEN
        // Call the method under test
        Demand[] result = linkDemandRepo.findDemandForSupplierId((int)testSupplier.getId(), (int)testLinkDemand.getId());

        // THEN        
        assertThat(result.length).isEqualTo(1);
        assertThat(result[0]).isEqualTo(otherMatchingDemand);
    }


    @Test
    public void testFindDemandForSupplierId_categoriesMatch() {
        // Given
        List<Category> testCategories = createTestCategories();
        categoryRepo.saveAll(testCategories);
        
        Supplier testSupplier = createTestSupplier();
        testSupplier.setCategories(testCategories.subList(3, 4));
        testSupplier = supplierRepo.save(testSupplier);

        Demand testLinkDemand = createTestLinkDemand();
        testLinkDemand = linkDemandRepo.save(testLinkDemand);

        Demand catNotMatchingLd = createTestLinkDemand();
        catNotMatchingLd.setCategories(testCategories.subList(0, 2));
        catNotMatchingLd.setDaNeeded(testSupplier.getDa());
        catNotMatchingLd.setUrl("www.bca.co.uk");
        Demand catMatchingLd = createTestLinkDemand();
        catMatchingLd.setCategories(testCategories.subList(3, 4));
        catMatchingLd.setUrl("www.disney.com");
        catMatchingLd.setDaNeeded(testSupplier.getDa());

        linkDemandRepo.saveAll(List.of(catNotMatchingLd, catMatchingLd));
        
        // WHEN
        // Call the method under test
        Demand[] result = linkDemandRepo.findDemandForSupplierId((int)testSupplier.getId(), (int)testLinkDemand.getId());

        // THEN        
        assertThat(result.length).isEqualTo(1);
        Demand[] expectedLinkDemands = { catMatchingLd }; 
        assertThat(result).isEqualTo(expectedLinkDemands);
    }

    @Test
    public void testFindDemandForSupplierId_daMatches() {
        // Given
        List<Category> testCategories = createTestCategories();
        categoryRepo.saveAll(testCategories);
        
        Supplier testSupplier = createTestSupplier();
        testSupplier.setCategories(testCategories);
        testSupplier = supplierRepo.save(testSupplier);

        Demand testLinkDemand = createTestLinkDemand();
        testLinkDemand = linkDemandRepo.save(testLinkDemand);

        Demand daNotMatchingLd = createTestLinkDemand();
        daNotMatchingLd.setCategories(testCategories);
        daNotMatchingLd.setDaNeeded(testSupplier.getDa() + 1);
        daNotMatchingLd.setUrl("www.bca.co.uk");
        Demand daMatchingLd = createTestLinkDemand();
        daMatchingLd.setCategories(testCategories);
        daMatchingLd.setUrl("www.disney.com");
        daMatchingLd.setDaNeeded(testSupplier.getDa());

        linkDemandRepo.saveAll(List.of(daNotMatchingLd, daMatchingLd));
        
        // WHEN
        // Call the method under test
        Demand[] result = linkDemandRepo.findDemandForSupplierId((int)testSupplier.getId(), (int)testLinkDemand.getId());

        // THEN        
        assertThat(result.length).isEqualTo(1);
        Demand[] expectedLinkDemands = { daMatchingLd }; 
        assertThat(result).isEqualTo(expectedLinkDemands);
    }

    private Demand createTestLinkDemand() {
        Demand linkDemand = new Demand();
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