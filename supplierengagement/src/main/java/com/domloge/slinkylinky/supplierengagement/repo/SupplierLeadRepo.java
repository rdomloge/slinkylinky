package com.domloge.slinkylinky.supplierengagement.repo;

import org.springframework.data.repository.CrudRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.web.bind.annotation.CrossOrigin;

import com.domloge.slinkylinky.supplierengagement.entity.LeadStatus;
import com.domloge.slinkylinky.supplierengagement.entity.SupplierLead;

import jakarta.transaction.Transactional;

@RepositoryRestResource(collectionResourceRel = "leads", path = "leads")
@CrossOrigin(exposedHeaders = "*")
public interface SupplierLeadRepo extends CrudRepository<SupplierLead, Long> {

    @Transactional
    SupplierLead findByGuid(String guid);

    @Transactional
    SupplierLead findByDomainAndSource(String domain, String source);

    @Transactional
    Iterable<SupplierLead> findBySource(String source);

    @Transactional
    Iterable<SupplierLead> findByStatus(LeadStatus status);
}
