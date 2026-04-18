package com.domloge.slinkylinky.linkservice.controller;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.Arrays;
import java.util.List;
import java.util.UUID;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.server.ResponseStatusException;

import com.domloge.slinkylinky.linkservice.config.TenantContext;
import com.domloge.slinkylinky.linkservice.config.TenantContextTest;
import com.domloge.slinkylinky.linkservice.entity.Demand;
import com.domloge.slinkylinky.linkservice.entity.DemandSite;
import com.domloge.slinkylinky.linkservice.entity.Supplier;
import com.domloge.slinkylinky.linkservice.entity.SupplierTenantExclusion;
import com.domloge.slinkylinky.linkservice.postprocessing.SupplierWriteGuard;
import com.domloge.slinkylinky.linkservice.repo.BlackListedSupplierRepo;
import com.domloge.slinkylinky.linkservice.repo.DemandRepo;
import com.domloge.slinkylinky.linkservice.repo.DemandSiteRepo;
import com.domloge.slinkylinky.linkservice.repo.SupplierRepo;
import com.domloge.slinkylinky.linkservice.repo.SupplierTenantExclusionRepo;

/**
 * Integration tests proving tenant data isolation and role-based access control.
 *
 * Covers:
 * - Data segregation: each org sees only its own Demands and DemandSites
 * - Cross-tenant deletes blocked with 403
 * - Role restrictions: supplier exclusion requires tenant_admin; blacklist requires global_admin;
 *   Supplier writes require global_admin (via SupplierWriteGuard)
 * - X-Tenant-Override honoured for global_admin only; ignored for tenant_admin
 */
@SpringBootTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
public class TenantIsolationTest {

    @MockBean(name = "auditRabbitTemplate")
    private AmqpTemplate auditRabbitTemplate;

    @MockBean(name = "proposalsRabbitTemplate")
    private AmqpTemplate proposalsRabbitTemplate;

    @MockBean(name = "supplierRabbitTemplate")
    private AmqpTemplate supplierRabbitTemplate;

    @Autowired
    private DemandSupportController demandSupportController;

    @Autowired
    private DemandSiteSupportController demandSiteSupportController;

    @Autowired
    private SupplierTenantExclusionController exclusionController;

    @Autowired
    private BlackListedSupplierSupportController blacklistController;

    @Autowired
    private SupplierWriteGuard supplierWriteGuard;

    @Autowired
    private DemandRepo demandRepo;

    @Autowired
    private DemandSiteRepo demandSiteRepo;

    @Autowired
    private SupplierRepo supplierRepo;

    @Autowired
    private SupplierTenantExclusionRepo exclusionRepo;

    @Autowired
    private BlackListedSupplierRepo blacklistRepo;

    static final UUID ORG_A = UUID.fromString("aaaaaaaa-0000-0000-0000-aaaaaaaaaaaa");
    static final UUID ORG_B = UUID.fromString("bbbbbbbb-0000-0000-0000-bbbbbbbbbbbb");
    static final String ORG_A_STR = ORG_A.toString();
    static final String ORG_B_STR = ORG_B.toString();

    private MockHttpServletRequest mockRequest;

    @BeforeEach
    void setup() {
        cleanup();
        mockRequest = new MockHttpServletRequest();
    }

    @AfterEach
    void tearDown() {
        SecurityContextHolder.clearContext();
        cleanup();
    }

    void cleanup() {
        exclusionRepo.deleteAll();
        blacklistRepo.deleteAll();
        demandRepo.deleteAll();
        demandSiteRepo.deleteAll();
        supplierRepo.deleteAll();
    }

    // ── 1: Demand data isolation ─────────────────────────────────────────────

    @Test
    void demandSupport_findUnsatisfied_returnsOnlyCallerOrg() {
        Demand demandA = new Demand();
        demandA.setUrl("https://org-a-client.com");
        demandA.setOrganisationId(ORG_A);
        demandA = demandRepo.save(demandA);

        Demand demandB = new Demand();
        demandB.setUrl("https://org-b-client.com");
        demandB.setOrganisationId(ORG_B);
        demandRepo.save(demandB);

        TenantContextTest.setSecurityContext("user", ORG_A_STR, List.of());

        ResponseEntity<Demand[]> resp = demandSupportController.findUnsatisfied("requested", mockRequest);

        assertEquals(HttpStatus.OK, resp.getStatusCode());
        Demand[] result = resp.getBody();
        assertNotNull(result);
        assertEquals(1, result.length, "Should return exactly 1 demand for org A");
        assertEquals(demandA.getId(), result[0].getId());
    }

    // ── 2: Demand cross-tenant delete blocked ────────────────────────────────

    @Test
    void demandSupport_delete_crossTenantReturns403() {
        Demand demandB = new Demand();
        demandB.setUrl("https://org-b-client-delete.com");
        demandB.setOrganisationId(ORG_B);
        demandB = demandRepo.save(demandB);

        TenantContextTest.setSecurityContext("user", ORG_A_STR, List.of("tenant_admin"));

        ResponseEntity<Object> resp = demandSupportController.delete(demandB.getId(), mockRequest);

        assertEquals(HttpStatus.FORBIDDEN, resp.getStatusCode());
    }

    // ── 3: DemandSite data isolation ─────────────────────────────────────────

    @Test
    void demandSiteSupport_missingCategories_returnsOnlyCallerOrg() {
        DemandSite siteA = new DemandSite();
        siteA.setUrl("https://org-a-site.com");
        siteA.setOrganisationId(ORG_A);
        siteA = demandSiteRepo.save(siteA);

        DemandSite siteB = new DemandSite();
        siteB.setUrl("https://org-b-site.com");
        siteB.setOrganisationId(ORG_B);
        siteB = demandSiteRepo.save(siteB);

        TenantContextTest.setSecurityContext("user", ORG_A_STR, List.of());

        ResponseEntity<?> resp = demandSiteSupportController.missingCategories(mockRequest, 8);

        assertEquals(HttpStatus.OK, resp.getStatusCode());
        Object resultObj = resp.getBody();
        assertNotNull(resultObj);

        // Extract items list from MissingCategoriesResult record via reflection
        java.util.List<DemandSite> items;
        try {
            java.lang.reflect.Field field = resultObj.getClass().getDeclaredField("items");
            field.setAccessible(true);
            @SuppressWarnings("unchecked")
            java.util.List<DemandSite> fieldValue = (java.util.List<DemandSite>) field.get(resultObj);
            items = fieldValue;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        assertNotNull(items);

        long siteAId = siteA.getId();
        long siteBId = siteB.getId();
        assertTrue(items.stream().anyMatch(ds -> ds.getId() == siteAId),
                "Org A's site must appear in results");
        assertFalse(items.stream().anyMatch(ds -> ds.getId() == siteBId),
                "Org B's site must not appear in org A's results");
    }

    // ── 4: DemandSite cross-tenant delete blocked ────────────────────────────

    @Test
    void demandSiteSupport_delete_crossTenantReturns403() {
        DemandSite siteB = new DemandSite();
        siteB.setUrl("https://org-b-site-del.com");
        siteB.setOrganisationId(ORG_B);
        siteB = demandSiteRepo.save(siteB);

        TenantContextTest.setSecurityContext("user", ORG_A_STR, List.of("tenant_admin"));

        ResponseEntity<Object> resp = demandSiteSupportController.delete(siteB.getId(), mockRequest);

        assertEquals(HttpStatus.FORBIDDEN, resp.getStatusCode());
    }

    // ── 5: Supplier exclusion — plain user blocked ───────────────────────────

    @Test
    void supplierExclusion_exclude_asDefaultUserReturns403() {
        Supplier supplier = savedSupplier("supplier-exclusion-block.com");

        TenantContextTest.setSecurityContext("user", ORG_A_STR, List.of());

        ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> exclusionController.exclude(supplier.getId(), mockRequest));
        assertEquals(HttpStatus.FORBIDDEN, ex.getStatusCode());
    }

    // ── 6: Supplier exclusion — tenant_admin allowed ─────────────────────────

    @Test
    void supplierExclusion_exclude_asTenantAdminSucceeds() {
        Supplier supplier = savedSupplier("supplier-exclusion-ok.com");

        TenantContextTest.setSecurityContext("admin", ORG_A_STR, List.of("tenant_admin"));

        ResponseEntity<Void> resp = exclusionController.exclude(supplier.getId(), mockRequest);

        assertEquals(HttpStatus.CREATED, resp.getStatusCode());
        assertTrue(exclusionRepo.existsBySupplierIdAndOrganisationId(supplier.getId(), ORG_A));
    }

    // ── 7: Supplier unexclusion — plain user blocked ─────────────────────────

    @Test
    void supplierExclusion_unexclude_asDefaultUserReturns403() {
        Supplier supplier = savedSupplier("supplier-unexclude-block.com");

        TenantContextTest.setSecurityContext("user", ORG_A_STR, List.of());

        ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> exclusionController.unexclude(supplier.getId(), mockRequest));
        assertEquals(HttpStatus.FORBIDDEN, ex.getStatusCode());
    }

    // ── 8: Supplier unexclusion — global_admin allowed ───────────────────────

    @Test
    void supplierExclusion_unexclude_asGlobalAdminSucceeds() {
        Supplier supplier = savedSupplier("supplier-unexclude-ok.com");
        SupplierTenantExclusion exclusion = new SupplierTenantExclusion();
        exclusion.setSupplierId(supplier.getId());
        exclusion.setOrganisationId(ORG_A);
        exclusionRepo.save(exclusion);

        TenantContextTest.setSecurityContext("root", ORG_A_STR, List.of("global_admin"));

        ResponseEntity<Void> resp = exclusionController.unexclude(supplier.getId(), mockRequest);

        assertEquals(HttpStatus.NO_CONTENT, resp.getStatusCode());
        assertFalse(exclusionRepo.existsBySupplierIdAndOrganisationId(supplier.getId(), ORG_A));
    }

    // ── 9: Blacklist — plain user blocked ────────────────────────────────────

    @Test
    void blacklist_isBlackListed_asDefaultUserReturns403() {
        TenantContextTest.setSecurityContext("user", ORG_A_STR, List.of());

        ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> blacklistController.isBlackListed("example.com"));
        assertEquals(HttpStatus.FORBIDDEN, ex.getStatusCode());
    }

    // ── 10: Blacklist — tenant_admin blocked ─────────────────────────────────

    @Test
    void blacklist_addBlackListed_asTenantAdminReturns403() {
        TenantContextTest.setSecurityContext("admin", ORG_A_STR, List.of("tenant_admin"));

        ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> blacklistController.addBlackListed("badsite.com", "{}", 10, 5));
        assertEquals(HttpStatus.FORBIDDEN, ex.getStatusCode());
    }

    // ── 11: Blacklist — global_admin allowed ─────────────────────────────────

    @Test
    void blacklist_addBlackListed_asGlobalAdminSucceeds() {
        TenantContextTest.setSecurityContext("root", ORG_A_STR, List.of("global_admin"));

        ResponseEntity<Boolean> resp = blacklistController.addBlackListed("blacklistedsite.com", "{}", 20, 3);

        assertEquals(HttpStatus.OK, resp.getStatusCode());
        assertNotNull(blacklistRepo.findByDomainIgnoreCase("blacklistedsite.com"));
    }

    // ── 12: SupplierWriteGuard — non-global_admin blocked ────────────────────

    @Test
    void supplierWriteGuard_nonGlobalAdmin_create_throwsForbidden() {
        TenantContextTest.setSecurityContext("user", ORG_A_STR, List.of("tenant_admin"));

        ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> supplierWriteGuard.beforeCreate(new Supplier()));
        assertEquals(HttpStatus.FORBIDDEN, ex.getStatusCode());
    }

    // ── 13: SupplierWriteGuard — global_admin allowed ────────────────────────

    @Test
    void supplierWriteGuard_globalAdmin_create_doesNotThrow() {
        TenantContextTest.setSecurityContext("root", ORG_A_STR, List.of("global_admin"));

        assertDoesNotThrow(() -> supplierWriteGuard.beforeCreate(new Supplier()));
    }

    // ── 14: X-Tenant-Override — global_admin sees target org ─────────────────

    @Test
    void globalAdmin_withTenantOverride_seesTargetOrgDemands() {
        Demand demandA = new Demand();
        demandA.setUrl("https://override-org-a.com");
        demandA.setOrganisationId(ORG_A);
        demandA = demandRepo.save(demandA);

        Demand demandB = new Demand();
        demandB.setUrl("https://override-org-b.com");
        demandB.setOrganisationId(ORG_B);
        demandRepo.save(demandB);

        // JWT org is ORG_B, but override header points to ORG_A
        TenantContextTest.setSecurityContext("root", ORG_B_STR, List.of("global_admin"));
        mockRequest.addHeader(TenantContext.TENANT_OVERRIDE_HEADER, ORG_A_STR);

        ResponseEntity<Demand[]> resp = demandSupportController.findUnsatisfied("requested", mockRequest);

        assertEquals(HttpStatus.OK, resp.getStatusCode());
        Demand[] result = resp.getBody();
        assertNotNull(result);
        assertEquals(1, result.length, "Override should give access to ORG_A's single demand");
        assertEquals(demandA.getId(), result[0].getId());
    }

    // ── 15: X-Tenant-Override — tenant_admin override is ignored ─────────────

    @Test
    void tenantAdmin_tenantOverrideHeader_isIgnored() {
        Demand demandA = new Demand();
        demandA.setUrl("https://ignored-override-org-a.com");
        demandA.setOrganisationId(ORG_A);
        demandA = demandRepo.save(demandA);

        Demand demandB = new Demand();
        demandB.setUrl("https://ignored-override-org-b.com");
        demandB.setOrganisationId(ORG_B);
        demandRepo.save(demandB);

        // tenant_admin in ORG_A tries to use override header to see ORG_B — must be ignored
        TenantContextTest.setSecurityContext("admin", ORG_A_STR, List.of("tenant_admin"));
        mockRequest.addHeader(TenantContext.TENANT_OVERRIDE_HEADER, ORG_B_STR);

        ResponseEntity<Demand[]> resp = demandSupportController.findUnsatisfied("requested", mockRequest);

        assertEquals(HttpStatus.OK, resp.getStatusCode());
        Demand[] result = resp.getBody();
        assertNotNull(result);
        assertEquals(1, result.length, "tenant_admin override must be ignored; only ORG_A demand returned");
        assertEquals(demandA.getId(), result[0].getId());
    }

    // ── Helper ───────────────────────────────────────────────────────────────

    private Supplier savedSupplier(String website) {
        Supplier supplier = new Supplier();
        supplier.setName("Test Supplier");
        supplier.setWebsite(website);
        return supplierRepo.save(supplier);
    }
}
