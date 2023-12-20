package com.domloge.slinkylinky.linkservice.repo;

import org.springframework.data.repository.CrudRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.web.bind.annotation.CrossOrigin;

import com.domloge.slinkylinky.linkservice.entity.audit.AuditRecord;

import jakarta.transaction.Transactional;

@RepositoryRestResource(collectionResourceRel = "auditrecords", path = "auditrecords")
@CrossOrigin(originPatterns = {"*localhost*"})
public interface AuditRecordRepo extends CrudRepository <AuditRecord, Long>{

    @Transactional
    AuditRecord[] findByEntityTypeAndEntityIdOrderByEventTimeAsc(String entityType, Long entityId);
}
