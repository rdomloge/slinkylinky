package com.domloge.slinkylinky.linkservice.postprocessing;

import org.springframework.data.rest.core.annotation.HandleBeforeCreate;
import org.springframework.data.rest.core.annotation.HandleBeforeDelete;
import org.springframework.data.rest.core.annotation.HandleBeforeSave;
import org.springframework.data.rest.core.annotation.RepositoryEventHandler;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.linkservice.config.TenantFilter;
import com.domloge.slinkylinky.linkservice.entity.Supplier;

/**
 * Restricts all Supplier mutations (create / update / delete) to global_admin callers.
 * Suppliers are a global shared resource — no tenant can create or modify them.
 */
@Component
@RepositoryEventHandler(Supplier.class)
public class SupplierWriteGuard {

    @HandleBeforeCreate
    public void beforeCreate(Supplier supplier) {
        TenantFilter.requireGlobalAdmin();
    }

    @HandleBeforeSave
    public void beforeSave(Supplier supplier) {
        TenantFilter.requireGlobalAdmin();
    }

    @HandleBeforeDelete
    public void beforeDelete(Supplier supplier) {
        TenantFilter.requireGlobalAdmin();
    }
}
