package com.domloge.slinkylinky.linkservice.repo;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Random;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;

import com.domloge.slinkylinky.linkservice.entity.Category;
import com.domloge.slinkylinky.linkservice.entity.LinkDemand;
import com.domloge.slinkylinky.linkservice.entity.PaidLink;
import com.domloge.slinkylinky.linkservice.entity.Supplier;

@DataJpaTest
public class SupplierRepoTest {

    @Autowired
    private SupplierRepo supplierRepo;

    @Autowired
    private LinkDemandRepo linkDemandRepo; 

    @Autowired
    private CategoryRepo categoryRepo;

    @Test
    public void testFindSuppliersForLinkDemandId_previousSupplierNotSuggested() {
        // GIVEN
        // save some categories to use
        List<Category> testCategories = createTestCategories();
        categoryRepo.saveAll(testCategories);

        // create the suppliers
        List<Supplier> testSuppliers = createTestSuppliers();
        testSuppliers.forEach(s -> {
            s.setDa(35);
            s.setCategories(testCategories);
            s.setThirdParty(false);
            s.setDisabled(false);
        });
        supplierRepo.saveAll(testSuppliers);

        // create the link demand
        LinkDemand ld = new LinkDemand();
        ld.setDaNeeded(20);
        ld.setCategories(testCategories);
        ld.setUrl("https://www.disney.com");
        LinkDemand dbLd = linkDemandRepo.save(ld);

        // link one of the suppliers to a /previous/ link demand with the same domain
        LinkDemand previousLd = new LinkDemand();
        previousLd.setUrl("https://www.disney.com");
        previousLd.setCategories(testCategories);
        previousLd.setDaNeeded(20);
        PaidLink pl = new PaidLink();
        pl.setSupplier(testSuppliers.get(0));
        pl.setLinkDemand(previousLd);

        
        // WHEN
        // Call the method under test
        Supplier[] result = supplierRepo.findSuppliersForLinkDemandId((int) dbLd.getId());

        // THEN
        assertThat(result.length).isEqualTo(testSuppliers.size() - 1);
    }

    @Test
    public void testFindSuppliersForLinkDemandId_noMatchingDa() {
        // given
        // save some categories to use
        List<Category> testCategories = createTestCategories();
        categoryRepo.saveAll(testCategories);

        List<Supplier> testSuppliers = createTestSuppliers();
        testSuppliers.forEach(s -> {
            s.setDa(new Random().nextInt(5));
            s.setCategories(testCategories);
            s.setThirdParty(false);
            s.setDisabled(false);
        });
        supplierRepo.saveAll(testSuppliers);

        LinkDemand ld = new LinkDemand();
        ld.setDaNeeded(100);
        ld.setCategories(testCategories);
        LinkDemand dbLd = linkDemandRepo.save(ld);

        // when
        // Call the method under test
        Supplier[] result = supplierRepo.findSuppliersForLinkDemandId((int) dbLd.getId());

        // Assert the results
        assertThat(result.length).isEqualTo(0);
    }

    private List<Supplier> createTestSuppliers() {
        List<Supplier> suppliers = new ArrayList<>();

        for (int i = 1; i <= 5; i++) {
            Supplier supplier = new Supplier();
            supplier.setName("Supplier " + i);
            supplier.setEmail("supplier" + i + "@test.com");
            supplier.setDa(i * 10);
            supplier.setWebsite("www.supplier" + i + ".com");
            supplier.setWeWriteFee(i * 100);
            supplier.setWeWriteFeeCurrency("USD");
            supplier.setSemRushAuthorityScore(i * 20);
            supplier.setSemRushUkMonthlyTraffic(i * 300);
            supplier.setSemRushUkJan23Traffic(i * 400);
            

            suppliers.add(supplier);
        }

        return suppliers;
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