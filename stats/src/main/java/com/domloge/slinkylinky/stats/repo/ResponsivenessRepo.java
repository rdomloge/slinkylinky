package com.domloge.slinkylinky.stats.repo;

import java.util.List;

import org.springframework.data.repository.CrudRepository;

import com.domloge.slinkylinky.stats.entity.SupplierResponsiveness;

public interface ResponsivenessRepo extends CrudRepository<SupplierResponsiveness, Long> {

    SupplierResponsiveness findBySupplierId(long supplierId);

    SupplierResponsiveness findByDomain(String domain);

    List<SupplierResponsiveness> findAll();
}
