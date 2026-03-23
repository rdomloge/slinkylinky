package com.domloge.slinkylinky.audit;

import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.web.bind.annotation.CrossOrigin;


import jakarta.transaction.Transactional;

@RepositoryRestResource(collectionResourceRel = "auditrecords", path = "auditrecords")
@CrossOrigin(originPatterns = {"*localhost*"})
public interface AuditRecordRepo extends CrudRepository<AuditRecord, Long>, PagingAndSortingRepository<AuditRecord, Long> { 

    @Transactional
    AuditRecord[] findByEntityTypeAndEntityIdOrderByEventTimeAsc(String entityType, Long entityId);
}
