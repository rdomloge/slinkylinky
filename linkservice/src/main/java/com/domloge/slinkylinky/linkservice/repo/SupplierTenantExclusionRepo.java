package com.domloge.slinkylinky.linkservice.repo;

import java.util.List;
import java.util.UUID;

import org.springframework.data.repository.CrudRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import com.domloge.slinkylinky.linkservice.entity.SupplierTenantExclusion;

// Not auto-exposed — accessed via SupplierTenantExclusionController (Phase 7)
@RepositoryRestResource(exported = false)
public interface SupplierTenantExclusionRepo extends CrudRepository<SupplierTenantExclusion, Long> {

    List<SupplierTenantExclusion> findByOrganisationId(UUID organisationId);

    boolean existsBySupplierIdAndOrganisationId(Long supplierId, UUID organisationId);

    void deleteBySupplierIdAndOrganisationId(Long supplierId, UUID organisationId);
}
