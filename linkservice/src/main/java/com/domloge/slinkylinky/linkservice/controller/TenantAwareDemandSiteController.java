package com.domloge.slinkylinky.linkservice.controller;

import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.rest.webmvc.PersistentEntityResource;
import org.springframework.data.rest.webmvc.PersistentEntityResourceAssembler;
import org.springframework.data.rest.webmvc.RepositoryRestController;
import org.springframework.data.web.PagedResourcesAssembler;
import org.springframework.hateoas.PagedModel;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;

import com.domloge.slinkylinky.linkservice.config.TenantFilter;
import com.domloge.slinkylinky.linkservice.entity.DemandSite;
import com.domloge.slinkylinky.linkservice.repo.DemandSiteRepo;

import jakarta.servlet.http.HttpServletRequest;

/**
 * Overrides the Spring Data REST collection endpoint for DemandSite to enforce
 * tenant isolation. Without this, GET /.rest/demandsites would return all orgs' data.
 */
@RepositoryRestController
public class TenantAwareDemandSiteController {

    @Autowired
    private DemandSiteRepo demandSiteRepo;

    @GetMapping("/demandsites")
    public ResponseEntity<PagedModel<PersistentEntityResource>> list(
            Pageable pageable,
            PersistentEntityResourceAssembler entityAssembler,
            PagedResourcesAssembler<DemandSite> pageAssembler,
            HttpServletRequest request) {
        UUID orgId = TenantFilter.requireOrgId(request);
        Page<DemandSite> page = demandSiteRepo.findAllByOrganisationId(orgId, pageable);
        return ResponseEntity.ok(pageAssembler.toModel(page, entityAssembler::toModel));
    }
}
