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

    @Autowired
    private PaidLinkRepo paidLinkRepo;

    

    @Test
    public void testFindSuppliersForLinkDemandId_disabledAndThirdPartyIgnored() {
        // GIVEN
        // save some categories to use
        List<Category> testCategories = createTestCategories();
        categoryRepo.saveAll(testCategories);

        // create the suppliers
        List<Supplier> testSuppliers = createTestSuppliers();
        testSuppliers.forEach(s -> {
            s.setDa(35);
            s.setCategories(testCategories);
        });
        testSuppliers.get(0).setDisabled(true);        // no match
        testSuppliers.get(1).setThirdParty(true);   // no match
        testSuppliers.get(0).setDa(30);
        testSuppliers.get(1).setDa(30);
        testSuppliers.get(2).setDa(30); // match
        testSuppliers.get(3).setDa(30); // match
        testSuppliers.get(4).setDa(30); // match
        supplierRepo.saveAll(testSuppliers);

        // create the link demand
        LinkDemand ld = new LinkDemand();
        ld.setDaNeeded(20);
        ld.setCategories(testCategories);
        LinkDemand dbLd = linkDemandRepo.save(ld);

        // WHEN
        // Call the method under test
        Supplier[] result = supplierRepo.findSuppliersForLinkDemandId((int) dbLd.getId());

        // THEN
        assertThat(result.length).isEqualTo(3);
        assertThat(result[0].getName()).isEqualTo("Supplier 3");
        assertThat(result[1].getName()).isEqualTo("Supplier 4");
        assertThat(result[2].getName()).isEqualTo("Supplier 5");
    }

    @Test
    public void testFindSuppliersForLinkDemandId_multiSupplierMatchingDa() {
        // GIVEN
        // save some categories to use
        List<Category> testCategories = createTestCategories();
        categoryRepo.saveAll(testCategories);

        // create the suppliers
        List<Supplier> testSuppliers = createTestSuppliers();
        testSuppliers.forEach(s -> {
            s.setCategories(testCategories);
            s.setThirdParty(false);
            s.setDisabled(false);
        });
        
        testSuppliers.get(0).setDa(20); // match
        testSuppliers.get(1).setDa(20); // match
        testSuppliers.get(2).setDa(10); // no match
        testSuppliers.get(3).setDa(10); // no match
        testSuppliers.get(4).setDa(10); // no match
        supplierRepo.saveAll(testSuppliers);

        // create the link demand
        LinkDemand ld = new LinkDemand();
        ld.setDaNeeded(20);
        ld.setCategories(testCategories);
        LinkDemand dbLd = linkDemandRepo.save(ld);

        // WHEN
        // Call the method under test
        Supplier[] result = supplierRepo.findSuppliersForLinkDemandId((int) dbLd.getId());

        // THEN
        assertThat(result.length).isEqualTo(2);
        assertThat(result[0].getName()).isEqualTo("Supplier 1");
        assertThat(result[1].getName()).isEqualTo("Supplier 2");
    }

    @Test
    public void testFindSuppliersForLinkDemandId_multiSupplierMultiCategoryMatch() {
        // GIVEN
        // save some categories to use
        List<Category> testCategories = createTestCategories();
        categoryRepo.saveAll(testCategories);

        // create the suppliers
        List<Supplier> testSuppliers = createTestSuppliers();
        testSuppliers.forEach(s -> {
            s.setDa(35);
            s.setThirdParty(false);
            s.setDisabled(false);
        });
        testSuppliers.get(0).setCategories(Arrays.asList(testCategories.get(0), testCategories.get(1))); // match
        testSuppliers.get(1).setCategories(Arrays.asList(testCategories.get(0), testCategories.get(1))); // match
        testSuppliers.get(2).setCategories(Arrays.asList(testCategories.get(2), testCategories.get(3))); // no match
        testSuppliers.get(3).setCategories(Arrays.asList(testCategories.get(2), testCategories.get(3))); // no match
        testSuppliers.get(4).setCategories(Arrays.asList(testCategories.get(2), testCategories.get(3))); // no match
        supplierRepo.saveAll(testSuppliers);

        // create the link demand
        LinkDemand ld = new LinkDemand();
        ld.setDaNeeded(20);
        ld.setCategories(Arrays.asList(testCategories.get(0), testCategories.get(1))); // cat 0 & 1
        LinkDemand dbLd = linkDemandRepo.save(ld);

        // WHEN
        // Call the method under test
        Supplier[] result = supplierRepo.findSuppliersForLinkDemandId((int) dbLd.getId());

        // THEN
        assertThat(result.length).isEqualTo(2);
        assertThat(result[0].getName()).isEqualTo("Supplier 1");
        assertThat(result[1].getName()).isEqualTo("Supplier 2");
    }

    @Test
    public void testFindSuppliersForLinkDemandId_oneSupplierMultiCategoryMatch() {
        // GIVEN
        // save some categories to use
        List<Category> testCategories = createTestCategories();
        categoryRepo.saveAll(testCategories);

        // create the suppliers
        List<Supplier> testSuppliers = createTestSuppliers();
        testSuppliers.forEach(s -> {
            s.setDa(35);
            s.setThirdParty(false);
            s.setDisabled(false);
        });
        testSuppliers.get(0).setCategories(Arrays.asList(testCategories.get(0))); // match
        testSuppliers.get(1).setCategories(Arrays.asList(testCategories.get(2))); // only cat 2 so no match
        testSuppliers.get(2).setCategories(Arrays.asList(testCategories.get(2))); // only cat 2 so no match
        testSuppliers.get(3).setCategories(Arrays.asList(testCategories.get(2))); // only cat 2 so no match
        testSuppliers.get(4).setCategories(Arrays.asList(testCategories.get(2))); // only cat 2 so no match
        supplierRepo.saveAll(testSuppliers);

        // create the link demand
        LinkDemand ld = new LinkDemand();
        ld.setDaNeeded(20);
        ld.setCategories(Arrays.asList(testCategories.get(0), testCategories.get(1))); // cat 0 & 1
        LinkDemand dbLd = linkDemandRepo.save(ld);

        // WHEN
        // Call the method under test
        Supplier[] result = supplierRepo.findSuppliersForLinkDemandId((int) dbLd.getId());

        // THEN
        assertThat(result.length).isEqualTo(1);
        assertThat(result[0].getName()).isEqualTo("Supplier 1");
    }

    @Test
    public void testFindSuppliersForLinkDemandId_oneSupplierOneCategoryMatch() {
        // GIVEN
        // save some categories to use
        List<Category> testCategories = createTestCategories();
        categoryRepo.saveAll(testCategories);

        // create the suppliers
        List<Supplier> testSuppliers = createTestSuppliers();
        testSuppliers.forEach(s -> {
            s.setDa(35);
            s.setThirdParty(false);
            s.setDisabled(false);
        });
        testSuppliers.get(0).setCategories(Arrays.asList(testCategories.get(0)));
        testSuppliers.get(1).setCategories(Arrays.asList(testCategories.get(1)));
        testSuppliers.get(2).setCategories(Arrays.asList(testCategories.get(1)));
        testSuppliers.get(3).setCategories(Arrays.asList(testCategories.get(1)));
        testSuppliers.get(4).setCategories(Arrays.asList(testCategories.get(1)));
        supplierRepo.saveAll(testSuppliers);

        // create the link demand
        LinkDemand ld = new LinkDemand();
        ld.setDaNeeded(20);
        ld.setCategories(Arrays.asList(testCategories.get(0)));
        LinkDemand dbLd = linkDemandRepo.save(ld);

        // WHEN
        // Call the method under test
        Supplier[] result = supplierRepo.findSuppliersForLinkDemandId((int) dbLd.getId());

        // THEN
        assertThat(result.length).isEqualTo(1);
        assertThat(result[0].getName()).isEqualTo("Supplier 1");
    }

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
        linkDemandRepo.save(previousLd);
        PaidLink pl = new PaidLink();
        pl.setSupplier(testSuppliers.get(0));
        pl.setLinkDemand(previousLd);
        paidLinkRepo.save(pl);

        
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