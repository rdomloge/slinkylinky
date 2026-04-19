package com.domloge.slinkylinky.linkservice.repo;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Random;
import java.util.Set;
import java.util.UUID;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;

import com.domloge.slinkylinky.linkservice.entity.Category;
import com.domloge.slinkylinky.linkservice.entity.Demand;
import com.domloge.slinkylinky.linkservice.entity.PaidLink;
import com.domloge.slinkylinky.linkservice.entity.Supplier;

@DataJpaTest
public class SupplierRepoTest {

    private static final UUID TEST_ORG_ID    = UUID.fromString("00000000-0000-0000-0000-000000000001");
    private static final UUID ANOTHER_ORG_ID = UUID.fromString("00000000-0000-0000-0000-000000000002");

    @Autowired
    private SupplierRepo supplierRepo;

    @Autowired
    private DemandRepo demandRepo; 

    @Autowired
    private CategoryRepo categoryRepo;

    @Autowired
    private PaidLinkRepo paidLinkRepo;

    
    @Test
    public void testFindSuppliersForDemandId_disabledCategoryIgnored() {
        // Given
        List<Category> testCategories = createTestCategories();
        testCategories.get(0).setDisabled(true);
        categoryRepo.saveAll(testCategories);

        List<Supplier> testSuppliers = createTestSuppliers();
        testSuppliers.forEach(s -> {
            s.setCategories(new HashSet<>(testCategories));
        });
        supplierRepo.saveAll(testSuppliers);

        Demand matchingByDisabledCategory = new Demand();
        matchingByDisabledCategory.setCategories(Set.of(testCategories.get(0)));
        matchingByDisabledCategory.setOrganisationId(TEST_ORG_ID);
        demandRepo.save(matchingByDisabledCategory);

        // When
        Supplier[] result = supplierRepo.findSuppliersForDemandId(matchingByDisabledCategory.getId(), TEST_ORG_ID);

        // Then
        assertThat(result.length).isEqualTo(0);
    }

    @Test
    public void testFindSuppliersForDemandId_enabledCategoryIgnored() {
        // Given
        List<Category> testCategories = createTestCategories();
        categoryRepo.saveAll(testCategories);

        List<Supplier> testSuppliers = createTestSuppliers();
        testSuppliers.forEach(s -> {
            s.setCategories(new HashSet<>(testCategories));
        });
        supplierRepo.saveAll(testSuppliers);

        Demand matchingByEnabledCategory = new Demand();
        matchingByEnabledCategory.setCategories(Set.of(testCategories.get(0)));
        matchingByEnabledCategory.setOrganisationId(TEST_ORG_ID);
        demandRepo.save(matchingByEnabledCategory);

        // When
        Supplier[] result = supplierRepo.findSuppliersForDemandId(matchingByEnabledCategory.getId(), TEST_ORG_ID);

        // Then
        assertThat(result.length).isEqualTo(testSuppliers.size());
    }

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
            s.setCategories(new HashSet<>(testCategories));
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
        Demand ld = new Demand();
        ld.setDaNeeded(20);
        ld.setCategories(new HashSet<>(testCategories));
        ld.setOrganisationId(TEST_ORG_ID);
        Demand dbLd = demandRepo.save(ld);

        // WHEN
        // Call the method under test
        Supplier[] result = supplierRepo.findSuppliersForDemandId((int) dbLd.getId(), TEST_ORG_ID);

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
            s.setCategories(new HashSet<>(testCategories));
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
        Demand ld = new Demand();
        ld.setDaNeeded(20);
        ld.setCategories(new HashSet<>(testCategories));
        ld.setOrganisationId(TEST_ORG_ID);
        Demand dbLd = demandRepo.save(ld);

        // WHEN
        // Call the method under test
        Supplier[] result = supplierRepo.findSuppliersForDemandId((int) dbLd.getId(), TEST_ORG_ID);

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
        testSuppliers.get(0).setCategories(Set.of(testCategories.get(0), testCategories.get(1))); // match
        testSuppliers.get(1).setCategories(Set.of(testCategories.get(0), testCategories.get(1))); // match
        testSuppliers.get(2).setCategories(Set.of(testCategories.get(2), testCategories.get(3))); // no match
        testSuppliers.get(3).setCategories(Set.of(testCategories.get(2), testCategories.get(3))); // no match
        testSuppliers.get(4).setCategories(Set.of(testCategories.get(2), testCategories.get(3))); // no match
        supplierRepo.saveAll(testSuppliers);

        // create the link demand
        Demand ld = new Demand();
        ld.setDaNeeded(20);
        ld.setCategories(Set.of(testCategories.get(0), testCategories.get(1))); // cat 0 & 1
        ld.setOrganisationId(TEST_ORG_ID);
        Demand dbLd = demandRepo.save(ld);

        // WHEN
        // Call the method under test
        Supplier[] result = supplierRepo.findSuppliersForDemandId((int) dbLd.getId(), TEST_ORG_ID);

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
        testSuppliers.get(0).setCategories(Set.of(testCategories.get(0))); // match
        testSuppliers.get(1).setCategories(Set.of(testCategories.get(2))); // only cat 2 so no match
        testSuppliers.get(2).setCategories(Set.of(testCategories.get(2))); // only cat 2 so no match
        testSuppliers.get(3).setCategories(Set.of(testCategories.get(2))); // only cat 2 so no match
        testSuppliers.get(4).setCategories(Set.of(testCategories.get(2))); // only cat 2 so no match
        supplierRepo.saveAll(testSuppliers);

        // create the link demand
        Demand ld = new Demand();
        ld.setDaNeeded(20);
        ld.setCategories(Set.of(testCategories.get(0), testCategories.get(1))); // cat 0 & 1
        ld.setOrganisationId(TEST_ORG_ID);
        Demand dbLd = demandRepo.save(ld);

        // WHEN
        // Call the method under test
        Supplier[] result = supplierRepo.findSuppliersForDemandId((int) dbLd.getId(), TEST_ORG_ID);

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
        testSuppliers.get(0).setCategories(Set.of(testCategories.get(0)));
        testSuppliers.get(1).setCategories(Set.of(testCategories.get(1)));
        testSuppliers.get(2).setCategories(Set.of(testCategories.get(1)));
        testSuppliers.get(3).setCategories(Set.of(testCategories.get(1)));
        testSuppliers.get(4).setCategories(Set.of(testCategories.get(1)));
        supplierRepo.saveAll(testSuppliers);

        // create the link demand
        Demand ld = new Demand();
        ld.setDaNeeded(20);
        ld.setCategories(Set.of(testCategories.get(0)));
        ld.setOrganisationId(TEST_ORG_ID);
        Demand dbLd = demandRepo.save(ld);

        // WHEN
        // Call the method under test
        Supplier[] result = supplierRepo.findSuppliersForDemandId((int) dbLd.getId(), TEST_ORG_ID);

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
            s.setCategories(new HashSet<>(testCategories));
            s.setThirdParty(false);
            s.setDisabled(false);
        });
        supplierRepo.saveAll(testSuppliers);

        // create the link demand
        Demand ld = new Demand();
        ld.setDaNeeded(20);
        ld.setCategories(new HashSet<>(testCategories));
        ld.setUrl("https://www.disney.com");
        ld.setOrganisationId(TEST_ORG_ID);
        Demand dbLd = demandRepo.save(ld);

        // link one of the suppliers to a /previous/ link demand with the same domain
        Demand previousD = new Demand();
        previousD.setUrl("https://www.disney.com");
        previousD.setCategories(new HashSet<>(testCategories));
        previousD.setDaNeeded(20);
        previousD.setOrganisationId(TEST_ORG_ID);
        demandRepo.save(previousD);
        PaidLink pl = new PaidLink();
        pl.setSupplier(testSuppliers.get(0));
        pl.setDemand(previousD);
        pl.setOrganisationId(TEST_ORG_ID);
        paidLinkRepo.save(pl);

        
        // WHEN
        // Call the method under test
        Supplier[] result = supplierRepo.findSuppliersForDemandId((int) dbLd.getId(), TEST_ORG_ID);

        // THEN
        assertThat(result.length).isEqualTo(testSuppliers.size() - 1);
    }

    @Test
    public void testFindSuppliersForLinkDemandId_previousSupplierFromAnotherOrgNotSuggested() {
        // A PaidLink created by a different organisation still uses up the domain pair
        // globally — Google SEO sees the same link regardless of which org placed it.
        List<Category> testCategories = createTestCategories();
        categoryRepo.saveAll(testCategories);

        List<Supplier> testSuppliers = createTestSuppliers();
        testSuppliers.forEach(s -> {
            s.setDa(35);
            s.setCategories(new HashSet<>(testCategories));
            s.setThirdParty(false);
            s.setDisabled(false);
        });
        supplierRepo.saveAll(testSuppliers);

        Demand currentDemand = new Demand();
        currentDemand.setDaNeeded(20);
        currentDemand.setCategories(new HashSet<>(testCategories));
        currentDemand.setUrl("https://www.disney.com");
        currentDemand.setOrganisationId(TEST_ORG_ID);
        Demand dbCurrentDemand = demandRepo.save(currentDemand);

        // PaidLink belongs to a DIFFERENT organisation
        Demand otherOrgDemand = new Demand();
        otherOrgDemand.setUrl("https://www.disney.com");
        otherOrgDemand.setCategories(new HashSet<>(testCategories));
        otherOrgDemand.setDaNeeded(20);
        otherOrgDemand.setOrganisationId(ANOTHER_ORG_ID);
        demandRepo.save(otherOrgDemand);
        PaidLink pl = new PaidLink();
        pl.setSupplier(testSuppliers.get(0));
        pl.setDemand(otherOrgDemand);
        pl.setOrganisationId(ANOTHER_ORG_ID);
        paidLinkRepo.save(pl);

        Supplier[] result = supplierRepo.findSuppliersForDemandId((int) dbCurrentDemand.getId(), TEST_ORG_ID);

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
            s.setCategories(new HashSet<>(testCategories));
            s.setThirdParty(false);
            s.setDisabled(false);
        });
        supplierRepo.saveAll(testSuppliers);

        Demand ld = new Demand();
        ld.setDaNeeded(100);
        ld.setCategories(new HashSet<>(testCategories));
        ld.setOrganisationId(TEST_ORG_ID);
        Demand dbLd = demandRepo.save(ld);

        // when
        // Call the method under test
        Supplier[] result = supplierRepo.findSuppliersForDemandId((int) dbLd.getId(), TEST_ORG_ID);

        // Assert the results
        assertThat(result.length).isEqualTo(0);
    }

    /**
     * findSuppliersForDemandId must return results ordered by weWriteFee ASC then
     * da DESC (Rule 3). Cheapest supplier appears first; ties on fee are broken by
     * highest DA first.
     */
    @Test
    public void testFindSuppliersForDemandId_orderedByCheapestFirstThenHighestDa() {
        // Given
        List<Category> testCategories = createTestCategories();
        categoryRepo.saveAll(testCategories);

        // Four suppliers, all eligible (category matches, DA >= 20, not disabled, not third-party)
        Supplier cheap1 = new Supplier();
        cheap1.setName("Cheap High DA");
        cheap1.setWebsite("www.cheap-high-da.com");
        cheap1.setDa(70);
        cheap1.setWeWriteFee(100);
        cheap1.setWeWriteFeeCurrency("£");
        cheap1.setCategories(new HashSet<>(testCategories));

        Supplier cheap2 = new Supplier();
        cheap2.setName("Cheap Low DA");
        cheap2.setWebsite("www.cheap-low-da.com");
        cheap2.setDa(50);
        cheap2.setWeWriteFee(100);
        cheap2.setWeWriteFeeCurrency("£");
        cheap2.setCategories(new HashSet<>(testCategories));

        Supplier expensive1 = new Supplier();
        expensive1.setName("Expensive High DA");
        expensive1.setWebsite("www.expensive-high-da.com");
        expensive1.setDa(90);
        expensive1.setWeWriteFee(200);
        expensive1.setWeWriteFeeCurrency("£");
        expensive1.setCategories(new HashSet<>(testCategories));

        Supplier expensive2 = new Supplier();
        expensive2.setName("Expensive Low DA");
        expensive2.setWebsite("www.expensive-low-da.com");
        expensive2.setDa(40);
        expensive2.setWeWriteFee(200);
        expensive2.setWeWriteFeeCurrency("£");
        expensive2.setCategories(new HashSet<>(testCategories));

        supplierRepo.saveAll(List.of(cheap1, cheap2, expensive1, expensive2));

        Demand demand = new Demand();
        demand.setDaNeeded(20);
        demand.setCategories(new HashSet<>(testCategories));
        demand.setOrganisationId(TEST_ORG_ID);
        Demand dbDemand = demandRepo.save(demand);

        // When
        Supplier[] result = supplierRepo.findSuppliersForDemandId(dbDemand.getId(), TEST_ORG_ID);

        // Then — cheapest first (fee=100 before fee=200); within same fee, highest DA first
        assertThat(result.length).isEqualTo(4);
        assertThat(result[0].getName()).isEqualTo("Cheap High DA");      // fee=100, da=70
        assertThat(result[1].getName()).isEqualTo("Cheap Low DA");       // fee=100, da=50
        assertThat(result[2].getName()).isEqualTo("Expensive High DA");  // fee=200, da=90
        assertThat(result[3].getName()).isEqualTo("Expensive Low DA");   // fee=200, da=40
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