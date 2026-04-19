package com.domloge.slinkylinky.audit;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PagedResourcesAssembler;
import org.springframework.hateoas.EntityModel;
import org.springframework.hateoas.PagedModel;
import org.springframework.http.ResponseEntity;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.test.context.bean.override.mockito.MockitoBean;

import com.domloge.slinkylinky.common.TenantContext;
import com.domloge.slinkylinky.common.TenantTestHelper;

/**
 * Unit tests for AuditRecordController — verifies tenant isolation enforcement.
 * Uses Mockito to stub the repository; no database required.
 */
@WebMvcTest(AuditRecordController.class)
class AuditRecordControllerTest {

    private static final String ORG_A = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa";
    private static final String ORG_B = "bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb";
    private static final UUID ORG_A_UUID = UUID.fromString(ORG_A);
    private static final UUID ORG_B_UUID = UUID.fromString(ORG_B);

    @MockitoBean
    private AuditRecordRepo repo;

    @MockitoBean
    private PagedResourcesAssembler<AuditRecord> assembler;

    @Autowired
    private AuditRecordController controller;

    @AfterEach
    void clearContext() {
        SecurityContextHolder.clearContext();
    }

    @Test
    void list_regularUser_filtersToOwnOrg() {
        TenantTestHelper.setSecurityContext("user", ORG_A, List.of());
        Page<AuditRecord> page = pageOf(auditRecord(ORG_A_UUID));
        when(repo.findAllByOrganisationIdOrderByEventTimeDesc(eq(ORG_A_UUID), any(Pageable.class)))
            .thenReturn(page);
        when(assembler.toModel(page)).thenReturn(PagedModel.empty());

        ResponseEntity<?> response = controller.list(PageRequest.of(0, 10), new MockHttpServletRequest());

        assertEquals(200, response.getStatusCode().value());
        verify(repo).findAllByOrganisationIdOrderByEventTimeDesc(eq(ORG_A_UUID), any(Pageable.class));
    }

    @Test
    void list_regularUserNoOrgId_returns403() {
        // JWT with no org_id claim
        TenantTestHelper.setSecurityContextNoOrg("user", List.of());

        org.springframework.web.server.ResponseStatusException ex =
            org.junit.jupiter.api.Assertions.assertThrows(
                org.springframework.web.server.ResponseStatusException.class,
                () -> controller.list(PageRequest.of(0, 10), new MockHttpServletRequest())
            );
        assertEquals(org.springframework.http.HttpStatus.FORBIDDEN, ex.getStatusCode());
    }

    @Test
    void list_globalAdminNoOverride_returnsAllRecords() {
        TenantTestHelper.setSecurityContext("admin", ORG_A, List.of("global_admin"));
        Page<AuditRecord> page = pageOf(auditRecord(ORG_A_UUID), auditRecord(ORG_B_UUID));
        when(repo.findAll(any(Pageable.class))).thenReturn(page);
        when(assembler.toModel(page)).thenReturn(PagedModel.empty());

        ResponseEntity<?> response = controller.list(PageRequest.of(0, 10), new MockHttpServletRequest());

        assertEquals(200, response.getStatusCode().value());
        verify(repo).findAll(any(Pageable.class));
    }

    @Test
    void list_globalAdminWithOverride_filtersToOverrideOrg() {
        TenantTestHelper.setSecurityContext("admin", ORG_A, List.of("global_admin"));
        Page<AuditRecord> page = pageOf(auditRecord(ORG_B_UUID));
        when(repo.findAllByOrganisationIdOrderByEventTimeDesc(eq(ORG_B_UUID), any(Pageable.class)))
            .thenReturn(page);
        when(assembler.toModel(page)).thenReturn(PagedModel.empty());
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.addHeader(TenantContext.TENANT_OVERRIDE_HEADER, ORG_B);

        ResponseEntity<?> response = controller.list(PageRequest.of(0, 10), request);

        assertEquals(200, response.getStatusCode().value());
        verify(repo).findAllByOrganisationIdOrderByEventTimeDesc(eq(ORG_B_UUID), any(Pageable.class));
    }

    @Test
    void list_regularUserCannotSeeOtherOrg() {
        TenantTestHelper.setSecurityContext("user", ORG_A, List.of());
        Page<AuditRecord> pageA = pageOf(auditRecord(ORG_A_UUID));
        when(repo.findAllByOrganisationIdOrderByEventTimeDesc(eq(ORG_A_UUID), any(Pageable.class)))
            .thenReturn(pageA);
        when(assembler.toModel(pageA)).thenReturn(PagedModel.empty());

        controller.list(PageRequest.of(0, 10), new MockHttpServletRequest());

        // ORG_B records must never be fetched
        verify(repo).findAllByOrganisationIdOrderByEventTimeDesc(eq(ORG_A_UUID), any(Pageable.class));
        org.mockito.Mockito.verify(repo, org.mockito.Mockito.never())
            .findAllByOrganisationIdOrderByEventTimeDesc(eq(ORG_B_UUID), any(Pageable.class));
        org.mockito.Mockito.verify(repo, org.mockito.Mockito.never()).findAll(any(Pageable.class));
    }

    // ── helpers ──────────────────────────────────────────────────────────────

    @SafeVarargs
    private static <T> Page<T> pageOf(T... items) {
        return new PageImpl<>(List.of(items));
    }

    private static AuditRecord auditRecord(UUID orgId) {
        AuditRecord r = new AuditRecord();
        r.setOrganisationId(orgId);
        r.setWho("user");
        r.setWhat("test action");
        r.setEventTime(LocalDateTime.now());
        return r;
    }
}
