package com.domloge.slinkylinky.linkservice.repo;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;

import com.domloge.slinkylinky.linkservice.entity.AtRiskDemandSiteProjection;
import com.domloge.slinkylinky.linkservice.entity.Category;
import com.domloge.slinkylinky.linkservice.entity.Demand;
import com.domloge.slinkylinky.linkservice.entity.DemandSite;
import com.domloge.slinkylinky.linkservice.entity.PaidLink;
import com.domloge.slinkylinky.linkservice.entity.Supplier;

/**
 * Tests for findAtRiskDemandSites — verifies that demand sites with fewer than
 * threshold available suppliers are correctly identified.
 *
 * These tests exercise the real SQL via H2 and will catch the bug where
 * the query references paid_link.demand_domain, a column that JPA never
 * populates (so paid links are silently ignored and used suppliers are
 * counted as still available).
 */
@DataJpaTest
public class SupplierHealthRepoTest {

    private static final UUID TEST_ORG_ID = UUID.fromString("00000000-0000-0000-0000-000000000001");

    @Autowired
    private SupplierRepo supplierRepo;

    @Autowired
    private DemandSiteRepo demandSiteRepo;

    @Autowired
    private DemandRepo demandRepo;

    @Autowired
    private CategoryRepo categoryRepo;

    @Autowired
    private PaidLinkRepo paidLinkRepo;

    /**
     * Core bug-proving test.
     *
     * A demand site has a niche category (cryptocurrency). 8 matching suppliers
     * exist but 5 of them have already been used (paid links exist). Only 3
     * remain available — below the threshold of 5. The at-risk query must flag
     * this site.
     *
     * This test FAILS before the fix because paid_link.demand_domain is not
     * mapped by JPA, so the NOT IN subquery silently counts used suppliers as
     * available and reports 8 available (not 3).
     */
    @Test
    public void atRisk_siteWithUsedSuppliers_isCorrectlyFlagged() {
        // Given
        Category crypto = new Category();
        crypto.setName("Cryptocurrency");
        categoryRepo.save(crypto);

        DemandSite site = new DemandSite();
        site.setName("Crypto News");
        site.setDomain("cryptonews.com");
        site.setCategories(Set.of(crypto));
        site.setOrganisationId(TEST_ORG_ID);
        demandSiteRepo.save(site);

        List<Supplier> suppliers = createSuppliers(8, crypto);
        supplierRepo.saveAll(suppliers);

        // A demand on that site — domain must match the demand site's domain
        Demand demand = new Demand();
        demand.setUrl("https://cryptonews.com/get-a-link");
        demand.setCategories(Set.of(crypto));
        demand.setDaNeeded(20);
        demand.setOrganisationId(TEST_ORG_ID);
        demandRepo.save(demand);

        // Use up 5 suppliers by creating paid links
        for (int i = 0; i < 5; i++) {
            PaidLink pl = new PaidLink();
            pl.setSupplier(suppliers.get(i));
            pl.setDemand(demand);
            pl.setOrganisationId(TEST_ORG_ID);
            paidLinkRepo.save(pl);
        }

        // When — 3 suppliers remain; threshold is 5
        List<AtRiskDemandSiteProjection> result = supplierRepo.findAtRiskDemandSites(5, TEST_ORG_ID);

        // Then — the site must appear with availableCount=3
        assertThat(result).hasSize(1);
        assertThat(result.get(0).getDomain()).isEqualTo("cryptonews.com");
        assertThat(result.get(0).getAvailableCount()).isEqualTo(3);
    }

    /**
     * A demand site with many unused suppliers should not appear as at-risk.
     * Even the buggy query passes this case because no paid links exist to
     * expose the demand_domain issue. This test verifies the happy path.
     */
    @Test
    public void atRisk_siteWithEnoughUnusedSuppliers_isNotFlagged() {
        // Given
        Category crypto = new Category();
        crypto.setName("Cryptocurrency2");
        categoryRepo.save(crypto);

        DemandSite site = new DemandSite();
        site.setName("Crypto Blog");
        site.setDomain("cryptoblog.com");
        site.setCategories(Set.of(crypto));
        site.setOrganisationId(TEST_ORG_ID);
        demandSiteRepo.save(site);

        supplierRepo.saveAll(createSuppliers(6, crypto));

        // When — 6 suppliers available, threshold 5 → not at risk
        List<AtRiskDemandSiteProjection> result = supplierRepo.findAtRiskDemandSites(5, TEST_ORG_ID);

        // Then
        assertThat(result).isEmpty();
    }

    /**
     * A demand site at the boundary: exactly `threshold` suppliers available.
     * HAVING COUNT < threshold means exactly-at-threshold sites are NOT flagged.
     */
    @Test
    public void atRisk_siteAtExactThreshold_isNotFlagged() {
        // Given
        Category crypto = new Category();
        crypto.setName("Cryptocurrency3");
        categoryRepo.save(crypto);

        DemandSite site = new DemandSite();
        site.setName("Crypto Wire");
        site.setDomain("cryptowire.com");
        site.setCategories(Set.of(crypto));
        site.setOrganisationId(TEST_ORG_ID);
        demandSiteRepo.save(site);

        supplierRepo.saveAll(createSuppliers(5, crypto));   // exactly 5 = threshold

        // When
        List<AtRiskDemandSiteProjection> result = supplierRepo.findAtRiskDemandSites(5, TEST_ORG_ID);

        // Then — COUNT < 5 is false when count == 5
        assertThat(result).isEmpty();
    }

    /**
     * Two demand sites: one at-risk, one healthy. Only the at-risk one appears,
     * and its category list is correct — allowing the frontend to show which
     * categories need new suppliers.
     */
    @Test
    public void atRisk_mixedSites_onlyAtRiskSitesAppear() {
        // Given
        Category crypto = new Category();
        crypto.setName("Cryptocurrency4");
        categoryRepo.save(crypto);

        Category finance = new Category();
        finance.setName("Finance");
        categoryRepo.save(finance);

        // At-risk site: only 2 available suppliers (below threshold of 5)
        DemandSite atRiskSite = new DemandSite();
        atRiskSite.setName("Crypto Daily");
        atRiskSite.setDomain("cryptodaily.com");
        atRiskSite.setCategories(Set.of(crypto));
        atRiskSite.setOrganisationId(TEST_ORG_ID);
        demandSiteRepo.save(atRiskSite);

        List<Supplier> cryptoSuppliers = createSuppliers(7, crypto);
        supplierRepo.saveAll(cryptoSuppliers);

        Demand atRiskDemand = new Demand();
        atRiskDemand.setUrl("https://cryptodaily.com/link-request");
        atRiskDemand.setCategories(Set.of(crypto));
        atRiskDemand.setDaNeeded(10);
        atRiskDemand.setOrganisationId(TEST_ORG_ID);
        demandRepo.save(atRiskDemand);

        // Use 5 of the 7 crypto suppliers → 2 remaining
        for (int i = 0; i < 5; i++) {
            PaidLink pl = new PaidLink();
            pl.setSupplier(cryptoSuppliers.get(i));
            pl.setDemand(atRiskDemand);
            pl.setOrganisationId(TEST_ORG_ID);
            paidLinkRepo.save(pl);
        }

        // Healthy site: 8 finance suppliers, none used
        DemandSite healthySite = new DemandSite();
        healthySite.setName("Finance Hub");
        healthySite.setDomain("financehub.com");
        healthySite.setCategories(Set.of(finance));
        healthySite.setOrganisationId(TEST_ORG_ID);
        demandSiteRepo.save(healthySite);

        supplierRepo.saveAll(createSuppliers(8, finance));

        // When
        List<AtRiskDemandSiteProjection> result = supplierRepo.findAtRiskDemandSites(5, TEST_ORG_ID);

        // Then — only cryptodaily.com appears
        assertThat(result).hasSize(1);
        assertThat(result.get(0).getDomain()).isEqualTo("cryptodaily.com");
        assertThat(result.get(0).getAvailableCount()).isEqualTo(2);
    }

    /**
     * Disabled and third-party suppliers must not be counted as available,
     * even if they share the demand site's category.
     */
    @Test
    public void atRisk_disabledAndThirdPartySuppliersDontCount() {
        // Given
        Category crypto = new Category();
        crypto.setName("Cryptocurrency5");
        categoryRepo.save(crypto);

        DemandSite site = new DemandSite();
        site.setName("Crypto Today");
        site.setDomain("cryptotoday.com");
        site.setCategories(Set.of(crypto));
        site.setOrganisationId(TEST_ORG_ID);
        demandSiteRepo.save(site);

        // 3 valid suppliers (not disabled, not third-party)
        List<Supplier> validSuppliers = createSuppliers(3, crypto);
        supplierRepo.saveAll(validSuppliers);

        // 4 extra suppliers that should NOT be counted
        Supplier disabled = new Supplier();
        disabled.setName("Disabled Supplier");
        disabled.setWebsite("www.disabledsupplier.com");
        disabled.setCategories(Set.of(crypto));
        disabled.setDisabled(true);
        disabled.setThirdParty(false);
        supplierRepo.save(disabled);

        Supplier thirdParty = new Supplier();
        thirdParty.setName("Third Party Supplier");
        thirdParty.setWebsite("www.thirdpartysupplier.com");
        thirdParty.setCategories(Set.of(crypto));
        thirdParty.setDisabled(false);
        thirdParty.setThirdParty(true);
        supplierRepo.save(thirdParty);

        // When — only 3 valid suppliers → below threshold of 5
        List<AtRiskDemandSiteProjection> result = supplierRepo.findAtRiskDemandSites(5, TEST_ORG_ID);

        // Then
        assertThat(result).hasSize(1);
        assertThat(result.get(0).getDomain()).isEqualTo("cryptotoday.com");
        assertThat(result.get(0).getAvailableCount()).isEqualTo(3);
    }

    // ─── Helpers ────────────────────────────────────────────────────────────────

    private List<Supplier> createSuppliers(int count, Category category) {
        List<Supplier> suppliers = new ArrayList<>();
        for (int i = 1; i <= count; i++) {
            Supplier s = new Supplier();
            s.setName("Supplier " + category.getName() + " " + i);
            s.setWebsite("www.supplier-" + category.getName().toLowerCase() + "-" + i + ".com");
            s.setDa(30);
            s.setDisabled(false);
            s.setThirdParty(false);
            s.setCategories(new HashSet<>(Set.of(category)));
            suppliers.add(s);
        }
        return suppliers;
    }
}
