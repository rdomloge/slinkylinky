package com.domloge.slinkylinky.audit;

import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.web.bind.annotation.CrossOrigin;

import jakarta.transaction.Transactional;

@RepositoryRestResource(collectionResourceRel = "auditrecords", path = "auditrecords")
@CrossOrigin(originPatterns = {"*localhost*"})
public interface AuditRecordRepo extends CrudRepository<AuditRecord, Long>, PagingAndSortingRepository<AuditRecord, Long> {

    @Transactional
    AuditRecord[] findByEntityTypeAndEntityIdOrderByEventTimeAsc(String entityType, String entityId);

    @Transactional
    Page<AuditRecord> findAllByOrganisationIdOrderByEventTimeDesc(UUID organisationId, Pageable pageable);

    @Transactional
    @Query("SELECT ar FROM AuditRecord ar WHERE ar.organisationId = ?1 OR ar.organisationId IS NULL ORDER BY ar.eventTime DESC")
    Page<AuditRecord> findByOrganisationIdOrNullOrderByEventTimeDesc(UUID organisationId, Pageable pageable);
}
