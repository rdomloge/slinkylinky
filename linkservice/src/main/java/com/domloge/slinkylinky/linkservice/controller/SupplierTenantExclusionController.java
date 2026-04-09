package com.domloge.slinkylinky.linkservice.controller;

import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import com.domloge.slinkylinky.linkservice.config.TenantContext;
import com.domloge.slinkylinky.linkservice.config.TenantFilter;
import com.domloge.slinkylinky.linkservice.entity.SupplierTenantExclusion;
import com.domloge.slinkylinky.linkservice.repo.SupplierTenantExclusionRepo;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;

/**
 * Exposes supplier exclusion management for tenant_admin users.
 * A tenant_admin can exclude a Supplier from their org's matching without affecting other tenants.
 */
@Slf4j
@RestController
@RequestMapping("/.rest/supplierExclusions")
public class SupplierTenantExclusionController {

    @Autowired
    private SupplierTenantExclusionRepo exclusionRepo;

    /**
     * Check whether a given supplier is excluded for the calling org.
     * Returns {@code true} or {@code false}.
     */
    @GetMapping("/isExcluded")
    public ResponseEntity<Boolean> isExcluded(@RequestParam Long supplierId, HttpServletRequest request) {
        UUID orgId = TenantFilter.requireOrgId(request);
        return ResponseEntity.ok(exclusionRepo.existsBySupplierIdAndOrganisationId(supplierId, orgId));
    }

    /**
     * Exclude a supplier for the calling org. Requires tenant_admin or global_admin.
     */
    @PostMapping("/exclude")
    public ResponseEntity<Void> exclude(@RequestParam Long supplierId, HttpServletRequest request) {
        requireTenantAdmin();
        UUID orgId = TenantFilter.requireOrgId(request);

        if (!exclusionRepo.existsBySupplierIdAndOrganisationId(supplierId, orgId)) {
            SupplierTenantExclusion exclusion = new SupplierTenantExclusion();
            exclusion.setSupplierId(supplierId);
            exclusion.setOrganisationId(orgId);
            exclusionRepo.save(exclusion);
            log.info("Supplier {} excluded for org {}", supplierId, orgId);
        }
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }

    /**
     * Un-exclude a supplier for the calling org. Requires tenant_admin or global_admin.
     */
    @DeleteMapping("/unexclude")
    @Transactional
    public ResponseEntity<Void> unexclude(@RequestParam Long supplierId, HttpServletRequest request) {
        requireTenantAdmin();
        UUID orgId = TenantFilter.requireOrgId(request);
        exclusionRepo.deleteBySupplierIdAndOrganisationId(supplierId, orgId);
        log.info("Supplier {} un-excluded for org {}", supplierId, orgId);
        return ResponseEntity.noContent().build();
    }

    private void requireTenantAdmin() {
        if (!TenantContext.isTenantAdmin() && !TenantContext.isGlobalAdmin()) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Requires tenant_admin or global_admin role");
        }
    }
}
