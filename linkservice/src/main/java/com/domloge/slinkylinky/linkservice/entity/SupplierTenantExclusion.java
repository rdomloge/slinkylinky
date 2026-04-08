package com.domloge.slinkylinky.linkservice.entity;

import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import lombok.Getter;
import lombok.Setter;

/**
 * Per-tenant suppression of a Supplier from matching.
 * A tenant_admin can exclude a Supplier so it never appears in their org's proposal matching.
 * Other organisations are unaffected.
 * This is distinct from supplier.disabled which hides the Supplier from all tenants globally.
 */
@Entity
@Table(name = "supplier_tenant_exclusion",
       uniqueConstraints = @UniqueConstraint(columnNames = {"supplier_id", "organisation_id"}))
@Getter
@Setter
public class SupplierTenantExclusion {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Column(name = "supplier_id", nullable = false)
    private Long supplierId;

    @Column(name = "organisation_id", nullable = false)
    private UUID organisationId;
}
