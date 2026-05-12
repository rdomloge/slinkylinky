package com.domloge.slinkylinky.linkservice.config;

import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertSame;

import java.util.List;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.hateoas.CollectionModel;
import org.springframework.hateoas.EntityModel;
import org.springframework.hateoas.PagedModel;
import org.springframework.hateoas.PagedModel.PageMetadata;
import org.springframework.security.core.context.SecurityContextHolder;

import com.domloge.slinkylinky.common.TenantTestHelper;
import com.domloge.slinkylinky.linkservice.entity.Supplier;

/**
 * Unit tests for {@link SupplierSensitiveDataAdvice}.
 *
 * Verifies that the advice strips {@code @GlobalAdminOnly} fields from each response shape
 * for non-global_admin callers and preserves them for global_admin. The advice has no
 * Spring-managed collaborators so this is intentionally a plain JUnit test.
 */
public class SupplierSensitiveDataAdviceTest {

    private static final String ORG = "00000000-0000-0000-0000-000000000001";

    private final SupplierSensitiveDataAdvice advice = new SupplierSensitiveDataAdvice();

    @BeforeEach
    void clear() { SecurityContextHolder.clearContext(); }

    @AfterEach
    void tearDown() { SecurityContextHolder.clearContext(); }

    @Test
    void singleSupplier_regularUser_masked() {
        asUser();
        Supplier s = supplier();
        assertSame(s, advice.beforeBodyWrite(s, null, null, null, null, null));
        assertSensitiveNulled(s);
    }

    @Test
    void singleSupplier_globalAdmin_preserved() {
        asAdmin();
        Supplier s = supplier();
        advice.beforeBodyWrite(s, null, null, null, null, null);
        assertSensitivePreserved(s);
    }

    @Test
    void supplierArray_regularUser_masked() {
        asUser();
        Supplier[] arr = { supplier(), supplier() };
        advice.beforeBodyWrite(arr, null, null, null, null, null);
        for (Supplier s : arr) assertSensitiveNulled(s);
    }

    @Test
    void pageOfSuppliers_regularUser_masked() {
        asUser();
        Supplier s = supplier();
        Page<Supplier> page = new PageImpl<>(List.of(s), PageRequest.of(0, 10), 1);
        advice.beforeBodyWrite(page, null, null, null, null, null);
        assertSensitiveNulled(s);
    }

    @Test
    void entityModel_regularUser_masked() {
        asUser();
        Supplier s = supplier();
        advice.beforeBodyWrite(EntityModel.of(s), null, null, null, null, null);
        assertSensitiveNulled(s);
    }

    @Test
    void pagedModel_regularUser_masked() {
        asUser();
        Supplier s = supplier();
        List<EntityModel<Supplier>> content = List.of(EntityModel.of(s));
        PagedModel<EntityModel<Supplier>> model = PagedModel.of(content, new PageMetadata(10, 0, 1, 1));
        advice.beforeBodyWrite(model, null, null, null, null, null);
        assertSensitiveNulled(s);
    }

    @Test
    void collectionModel_regularUser_masked() {
        asUser();
        Supplier s = supplier();
        CollectionModel<EntityModel<Supplier>> model = CollectionModel.of(List.of(EntityModel.of(s)));
        advice.beforeBodyWrite(model, null, null, null, null, null);
        assertSensitiveNulled(s);
    }

    @Test
    void nullBody_returnsNull() {
        asUser();
        assertNull(advice.beforeBodyWrite(null, null, null, null, null, null));
    }

    // ── helpers ──────────────────────────────────────────────────────────────

    private static void asAdmin() { TenantTestHelper.setSecurityContext("admin", ORG, List.of("global_admin")); }
    private static void asUser()  { TenantTestHelper.setSecurityContext("user",  ORG, List.of()); }

    private static Supplier supplier() {
        Supplier s = new Supplier();
        s.setName("Alpha Supplier");
        s.setEmail("alpha@test.com");
        s.setSource("collaborator");
        s.setDa(50);
        s.setWebsite("https://www.alpha.com");
        return s;
    }

    private static void assertSensitiveNulled(Supplier s) {
        assertNull(s.getName(),   "name must be masked");
        assertNull(s.getEmail(),  "email must be masked");
        assertNull(s.getSource(), "source must be masked");
    }

    private static void assertSensitivePreserved(Supplier s) {
        if (s.getName() == null || s.getEmail() == null || s.getSource() == null) {
            throw new AssertionError("global_admin sensitive fields must not be masked");
        }
    }
}
