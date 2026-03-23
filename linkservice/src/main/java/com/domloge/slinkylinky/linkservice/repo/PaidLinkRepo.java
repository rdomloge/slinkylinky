package com.domloge.slinkylinky.linkservice.repo;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.web.bind.annotation.CrossOrigin;

import com.domloge.slinkylinky.linkservice.entity.PaidLink;
import com.domloge.slinkylinky.linkservice.entity.SupplierLinkCountProjection;

@RepositoryRestResource(collectionResourceRel = "paidlinks", path = "paidlinks")
@CrossOrigin(exposedHeaders = "*")
public interface PaidLinkRepo extends CrudRepository <PaidLink, Long> {

    long countByDemand_domain(String domain);

    long countBySupplierId(long supplierId);

    PaidLink findByDemandDomainAndSupplierDomain(String demandDomain, String supplierDomain);

    @Query(nativeQuery = true, value =
        "SELECT s.id as id, s.domain as domain, s.name as name, COUNT(pl.id) as linkCount " +
        "FROM paid_link pl JOIN supplier s ON s.id = pl.supplier_id " +
        "GROUP BY s.id, s.domain, s.name " +
        "ORDER BY linkCount DESC " +
        "LIMIT :limit")
    List<SupplierLinkCountProjection> findTopByLinkCount(int limit);
}
