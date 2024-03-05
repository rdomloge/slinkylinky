package com.domloge.slinkylinky.linkservice.controller;

import java.util.List;
import java.util.Optional;

import org.hibernate.envers.AuditReader;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.domloge.slinkylinky.linkservice.Util;
import com.domloge.slinkylinky.linkservice.entity.Supplier;
import com.domloge.slinkylinky.linkservice.entity.audit.SupplierAuditor;
import com.domloge.slinkylinky.linkservice.repo.SupplierRepo;

import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping(".rest/supplierSupport")
@Slf4j
public class SupplierSupportController {

    @Autowired
    private AuditReader auditReader;

    @Autowired
    private SupplierRepo supplierRepo;

    @Autowired
    private SupplierAuditor supplierAuditor;


    @PatchMapping(path = "/updateSupplierDa", produces = "application/json")
    @Transactional
    public ResponseEntity<Supplier> updateSupplierDa(@RequestParam long supplierId, @RequestParam int da) {
        log.info("Updating supplier da for supplierId: " + supplierId + " da: " + da);

        Optional<Supplier> opt = supplierRepo.findById(supplierId);
        if (opt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        Supplier supplier = opt.get();

        supplier.setDa(da);
        supplier.setUpdatedBy("system");
        supplier.setModifiedDate(System.currentTimeMillis());
        supplierRepo.save(supplier);
        supplierAuditor.handleBeforeSave(supplier);

        return ResponseEntity.ok(supplier);
    }
    

    @GetMapping(path = "/getVersion", produces = "application/json")
    @Transactional
    public ResponseEntity<Supplier> getSupplier(@RequestParam long supplierId, @RequestParam long version) {
        log.info("Getting supplier version for supplierId: " + supplierId + " version: " + version);

        List<Number> revisions = auditReader.getRevisions(Supplier.class, supplierId);
        if (revisions.size() < version) {
            return ResponseEntity.notFound().build();
        }

        Supplier versionedSupplier = auditReader.find(Supplier.class, supplierId, revisions.get((int) version));
        
        return ResponseEntity.ok(versionedSupplier);
    }

    @GetMapping(path = "/exists", produces = "application/json")
    public ResponseEntity<Boolean> supplierExists(@RequestParam String supplierWebsite) {
        String domain  = Util.stripDomain(supplierWebsite);
        Supplier s = supplierRepo.findByDomainIgnoreCase(domain);
        log.info("Supplier {} for supplierWebsite {} {}", domain, supplierWebsite, s != null ? "exists" : "does not exist");
        return ResponseEntity.ok(s != null);
    }
}
