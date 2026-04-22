package com.domloge.slinkylinky.audit;

import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.rest.webmvc.RepositoryRestController;
import org.springframework.data.web.PagedResourcesAssembler;
import org.springframework.hateoas.EntityModel;
import org.springframework.hateoas.PagedModel;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.domloge.slinkylinky.common.TenantContext;
import com.domloge.slinkylinky.common.TenantFilter;

import jakarta.servlet.http.HttpServletRequest;

/**
 * Overrides the default Spring Data REST collection endpoint for AuditRecord.
 *
 * - global_admin: returns all records (or filtered via X-Tenant-Override).
 * - All other callers: filtered to their org_id from the JWT (403 if none present).
 */
@RepositoryRestController
public class AuditRecordController {

    @Autowired
    private AuditRecordRepo repo;

    @Autowired
    private PagedResourcesAssembler<AuditRecord> assembler;

    @GetMapping("/auditrecords")
    public ResponseEntity<PagedModel<EntityModel<AuditRecord>>> list(
            Pageable pageable,
            HttpServletRequest request) {

        if (TenantContext.isGlobalAdmin()) {
            String overrideHeader = request.getHeader(TenantContext.TENANT_OVERRIDE_HEADER);
            Page<AuditRecord> page;
            if (overrideHeader != null && !overrideHeader.isBlank()) {
                try {
                    UUID overrideId = UUID.fromString(overrideHeader.trim());
                    page = repo.findByOrganisationIdOrNullOrderByEventTimeDesc(overrideId, pageable);
                } catch (IllegalArgumentException ignored) {
                    page = repo.findAll(pageable);
                }
            } else {
                page = repo.findAll(pageable);
            }
            return ResponseEntity.ok(assembler.toModel(page));
        }

        UUID orgId = TenantFilter.requireOrgId(request);
        Page<AuditRecord> page = repo.findAllByOrganisationIdOrderByEventTimeDesc(orgId, pageable);
        return ResponseEntity.ok(assembler.toModel(page));
    }

    @GetMapping("/auditrecords/trace")
    public ResponseEntity<?> trace(
            @RequestParam(required = false) String entityType,
            @RequestParam(required = false) String entityId,
            HttpServletRequest request) {

        if (entityType == null || entityId == null) {
            return ResponseEntity.badRequest().body("entityType and entityId query parameters are required");
        }

        AuditRecord[] records = repo.findByEntityTypeAndEntityIdOrderByEventTimeAsc(entityType, entityId);

        if (!TenantContext.isGlobalAdmin()) {
            UUID orgId = TenantFilter.requireOrgId(request);
            records = java.util.Arrays.stream(records)
                .filter(r -> orgId.equals(r.getOrganisationId()))
                .toArray(AuditRecord[]::new);
        } else {
            String overrideHeader = request.getHeader(TenantContext.TENANT_OVERRIDE_HEADER);
            if (overrideHeader != null && !overrideHeader.isBlank()) {
                try {
                    UUID overrideId = UUID.fromString(overrideHeader.trim());
                    final UUID filterId = overrideId;
                    records = java.util.Arrays.stream(records)
                        .filter(r -> filterId.equals(r.getOrganisationId()))
                        .toArray(AuditRecord[]::new);
                } catch (IllegalArgumentException ignored) {
                    // If override header is invalid, allow all results
                }
            }
        }

        return ResponseEntity.ok(records);
    }
}
