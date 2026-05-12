package com.domloge.slinkylinky.linkservice.config;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;

import java.util.List;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.security.core.context.SecurityContextHolder;

import com.domloge.slinkylinky.common.SensitiveFieldMasker;
import com.domloge.slinkylinky.common.TenantTestHelper;
import com.domloge.slinkylinky.linkservice.entity.Supplier;

/**
 * Unit tests for {@link SensitiveFieldMasker} applied to {@link Supplier}.
 *
 * Verifies role-based masking of {@code @GlobalAdminOnly} fields (name, email, source).
 * Wrapping/collection handling is covered separately in {@link SupplierSensitiveDataAdviceTest}.
 */
public class SensitiveFieldMaskerSupplierTest {

    private static final String ORG = "00000000-0000-0000-0000-000000000001";

    @BeforeEach
    void clear() { SecurityContextHolder.clearContext(); }

    @AfterEach
    void tearDown() { SecurityContextHolder.clearContext(); }

    @Test
    void globalAdmin_allFieldsPreserved() {
        TenantTestHelper.setSecurityContext("admin", ORG, List.of("global_admin"));
        Supplier s = supplier();

        SensitiveFieldMasker.mask(s);

        assertEquals("Test Supplier",        s.getName());
        assertEquals("supplier@example.com", s.getEmail());
        assertEquals("collaborator",         s.getSource());
    }

    @Test
    void regularUser_sensitiveNulled_nonSensitivePreserved() {
        TenantTestHelper.setSecurityContext("user", ORG, List.of());
        Supplier s = supplier();

        SensitiveFieldMasker.mask(s);

        assertNull(s.getName());
        assertNull(s.getEmail());
        assertNull(s.getSource());
        // non-sensitive fields remain
        assertEquals(42, s.getDa());
        assertEquals("https://www.example.com", s.getWebsite());
        assertEquals("example.com", s.getDomain());
    }

    @Test
    void tenantAdmin_sensitiveNulled() {
        TenantTestHelper.setSecurityContext("tenantadmin", ORG, List.of("tenant_admin"));
        Supplier s = supplier();

        SensitiveFieldMasker.mask(s);

        assertNull(s.getName());
        assertNull(s.getEmail());
        assertNull(s.getSource());
    }

    @Test
    void noAuthentication_sensitiveNulled() {
        SecurityContextHolder.clearContext();
        Supplier s = supplier();

        SensitiveFieldMasker.mask(s);

        assertNull(s.getName());
        assertNull(s.getEmail());
        assertNull(s.getSource());
    }

    @Test
    void nullEntity_safe() {
        TenantTestHelper.setSecurityContext("user", ORG, List.of());
        assertNull(SensitiveFieldMasker.mask((Supplier) null));
    }

    private static Supplier supplier() {
        Supplier s = new Supplier();
        s.setName("Test Supplier");
        s.setEmail("supplier@example.com");
        s.setSource("collaborator");
        s.setDa(42);
        s.setWebsite("https://www.example.com");
        return s;
    }
}
