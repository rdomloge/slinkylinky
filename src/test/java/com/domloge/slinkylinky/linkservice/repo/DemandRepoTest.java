package com.domloge.slinkylinky.linkservice.repo;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

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
    private DemandRepo demandRepo;

    @Autowired
    private SupplierRepo supplierRepo;

    @Autowired
    private CategoryRepo categoryRepo;

    @Autowired
    private PaidLinkRepo paidLinkRepo;

    @Test
    public void testFindDemandForSupplierId_disabledCategoryIgnored() {
        // Given
        List<Category> testCategories = createTestCategories();
        testCategories.get(0).setDisabled(true);
        categoryRepo.saveAll(testCategories);

        // When
        Supplier testSupplier = createTestSupplier();
        testSupplier.setCategories(testCategories);
        supplierRepo.save(testSupplier);

        Demand testDemand = createTestDemand();
        testDemand.setCategories(Arrays.asList(testCategories.get(0)));
        demandRepo.save(testDemand);

        // Then
        assertThat(demandRepo.findDemandForSupplierId((int)testSupplier.getId(), (int)testDemand.getId()).length).isEqualTo(0);
    }

    @Test
    public void testFindDemandForSupplierId_disabledCategoryIgnoredEnabledCategoryMatched() {
        // Given
        List<Category> testCategories = createTestCategories();
        testCategories.get(0).setDisabled(true);
        categoryRepo.saveAll(testCategories);

        // When
        Supplier testSupplier = createTestSupplier();
        testSupplier.setCategories(testCategories);
        supplierRepo.save(testSupplier);

        
        String demand1Name = UUID.randomUUID().toString();
        String demand2Name = UUID.randomUUID().toString();
        
        Demand ignoreDemand = createTestDemand();
        ignoreDemand.setName("ignore");
        ignoreDemand.setCategories(Arrays.asList(testCategories.get(1)));
        ignoreDemand.setUrl("www.testignore.com");
        
        Demand nonMatchingDemand = createTestDemand();
        nonMatchingDemand.setName(demand1Name);
        nonMatchingDemand.setUrl("www.test.com");
        nonMatchingDemand.setCategories(Arrays.asList(testCategories.get(0)));

        Demand matchingDemand = createTestDemand();
        matchingDemand.setName(demand2Name);
        matchingDemand.setDaNeeded(10);
        matchingDemand.setUrl("www.test2.com");
        matchingDemand.setCategories(Arrays.asList(testCategories.get(1)));
        demandRepo.saveAll(Arrays.asList(nonMatchingDemand, matchingDemand, ignoreDemand));

        // Then
        Demand[] matchingDemandResults = demandRepo.findDemandForSupplierId(testSupplier.getId(), ignoreDemand.getId());
        assertThat(matchingDemandResults.length).isEqualTo(1);
        assertThat(matchingDemandResults[0].getName()).isEqualTo(matchingDemand.getName());
    }

    @Test
    public void testFindDemandForSupplierId_noDomainDupes() {
        // Given
        List<Category> testCategories = createTestCategories();
        categoryRepo.saveAll(testCategories);
        
        Supplier testSupplier = createTestSupplier();
        testSupplier.setCategories(testCategories);
        testSupplier = supplierRepo.save(testSupplier);

        Demand selectedDemand = createTestDemand();
        selectedDemand.setCategories(testCategories);
        selectedDemand = demandRepo.save(selectedDemand);

        Demand otherMatchingDemandFromSameClient = createTestDemand();
        otherMatchingDemandFromSameClient.setCategories(testCategories);
        demandRepo.save(otherMatchingDemandFromSameClient);

        
        // WHEN
        // Call the method under test
        Demand[] result = demandRepo.findDemandForSupplierId((int)testSupplier.getId(), (int)selectedDemand.getId());

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

        Demand testLinkDemand = createTestDemand();
        testLinkDemand.setCategories(testCategories);
        testLinkDemand.setDaNeeded(5);
        testLinkDemand.setUrl("www.a2d.com");
        testLinkDemand = demandRepo.save(testLinkDemand);

        Demand otherMatchingDemand = createTestDemand();
        otherMatchingDemand.setCategories(testCategories);
        otherMatchingDemand.setDaNeeded(5);
        otherMatchingDemand.setUrl("www.toysrus.com");
        demandRepo.save(otherMatchingDemand);

        Demand nonMatchingDemand = createTestDemand();
        nonMatchingDemand.setCategories(testCategories);
        nonMatchingDemand.setDaNeeded(testSupplier.getDa() + 1);
        nonMatchingDemand.setUrl("www.abc.co.uk");
        demandRepo.save(nonMatchingDemand);

        Demand secondNonMatchingDemand = createTestDemand();
        secondNonMatchingDemand.setCategories(Arrays.asList(categoryRepo.save(new Category("Non matching category"))));
        secondNonMatchingDemand.setDaNeeded(testSupplier.getDa());
        secondNonMatchingDemand.setUrl("www.rty.co.uk");
        demandRepo.save(secondNonMatchingDemand);

        Demand historicalDemandForSupplier = createTestDemand();
        historicalDemandForSupplier.setCategories(testCategories);
        historicalDemandForSupplier.setUrl("www.bca.co.uk");
        historicalDemandForSupplier.setDaNeeded(testSupplier.getDa());
        demandRepo.save(historicalDemandForSupplier);
        PaidLink paidLink = new PaidLink();
        paidLink.setDemand(historicalDemandForSupplier);
        paidLink.setSupplier(testSupplier);
        paidLinkRepo.save(paidLink);

        Demand newDemandFromHistorical = createTestDemand();
        newDemandFromHistorical.setCategories(testCategories);
        newDemandFromHistorical.setUrl("www.bca.co.uk");
        newDemandFromHistorical.setDaNeeded(testSupplier.getDa());
        demandRepo.save(newDemandFromHistorical);
        
        // WHEN
        // Call the method under test
        Demand[] result = demandRepo.findDemandForSupplierId(testSupplier.getId(), testLinkDemand.getId());

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

        Demand testLinkDemand = createTestDemand();
        testLinkDemand = demandRepo.save(testLinkDemand);

        Demand catNotMatchingLd = createTestDemand();
        catNotMatchingLd.setCategories(testCategories.subList(0, 2));
        catNotMatchingLd.setDaNeeded(testSupplier.getDa());
        catNotMatchingLd.setUrl("www.bca.co.uk");
        Demand catMatchingLd = createTestDemand();
        catMatchingLd.setCategories(testCategories.subList(3, 4));
        catMatchingLd.setUrl("www.disney.com");
        catMatchingLd.setDaNeeded(testSupplier.getDa());

        demandRepo.saveAll(List.of(catNotMatchingLd, catMatchingLd));
        
        // WHEN
        // Call the method under test
        Demand[] result = demandRepo.findDemandForSupplierId((int)testSupplier.getId(), (int)testLinkDemand.getId());

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

        Demand testLinkDemand = createTestDemand();
        testLinkDemand = demandRepo.save(testLinkDemand);

        Demand daNotMatchingLd = createTestDemand();
        daNotMatchingLd.setCategories(testCategories);
        daNotMatchingLd.setDaNeeded(testSupplier.getDa() + 1);
        daNotMatchingLd.setUrl("www.bca.co.uk");
        Demand daMatchingLd = createTestDemand();
        daMatchingLd.setCategories(testCategories);
        daMatchingLd.setUrl("www.disney.com");
        daMatchingLd.setDaNeeded(testSupplier.getDa());

        demandRepo.saveAll(List.of(daNotMatchingLd, daMatchingLd));
        
        // WHEN
        // Call the method under test
        Demand[] result = demandRepo.findDemandForSupplierId((int)testSupplier.getId(), (int)testLinkDemand.getId());

        // THEN        
        assertThat(result.length).isEqualTo(1);
        Demand[] expectedLinkDemands = { daMatchingLd }; 
        assertThat(result).isEqualTo(expectedLinkDemands);
    }

    private Demand createTestDemand() {
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