package com.domloge.slinkylinky.linkservice.postprocessing;

import org.springframework.data.rest.core.annotation.HandleBeforeCreate;
import org.springframework.data.rest.core.annotation.HandleBeforeSave;
import org.springframework.data.rest.core.annotation.RepositoryEventHandler;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.domloge.slinkylinky.linkservice.config.TenantFilter;
import com.domloge.slinkylinky.linkservice.entity.DemandSite;

import jakarta.servlet.http.HttpServletRequest;

/**
 * Ensures every DemandSite saved via Spring Data REST is tagged with the caller's
 * effective organisation_id before the row hits the database.
 */
@Component
@RepositoryEventHandler(DemandSite.class)
public class DemandSiteEventHandler {

    @HandleBeforeCreate
    public void handleBeforeCreate(DemandSite demandSite) {
        HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
        demandSite.setOrganisationId(TenantFilter.requireOrgId(request));
    }

    @HandleBeforeSave
    public void handleBeforeSave(DemandSite demandSite) {
        if (demandSite.getOrganisationId() == null) {
            HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
            demandSite.setOrganisationId(TenantFilter.requireOrgId(request));
        }
    }
}
