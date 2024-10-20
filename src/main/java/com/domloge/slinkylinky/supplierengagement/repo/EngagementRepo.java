package com.domloge.slinkylinky.supplierengagement.repo;

import java.time.LocalDateTime;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.web.bind.annotation.CrossOrigin;

import com.domloge.slinkylinky.supplierengagement.entity.Engagement;
import com.domloge.slinkylinky.supplierengagement.entity.EngagementStatus;

import jakarta.transaction.Transactional;

@RepositoryRestResource(collectionResourceRel = "engagements", path = "engagements")
@CrossOrigin(exposedHeaders = "*")
public interface EngagementRepo extends CrudRepository <Engagement, Long> {
    
    @Transactional
    public Engagement findByGuid(String guid);

    @Transactional
    @Query("select e from Engagement e where e.proposalId = ?1 and (e.status = 'NEW' or e.status = 'ACCEPTED' or e.status = 'DECLINED')")
    public Engagement findByProposalIdAndStatusNewOrAcceptedOrDeclined(long proposalId);

    @Transactional
    @Query("select e from Engagement e where e.proposalId = ?1 and e.status = 'ACCEPTED'")
    public Engagement findByProposalIdAndStatusACCEPTED(long proposalId);

    @Transactional 
    public Engagement[] findByProposalId(long proposalId);
    
    @Transactional
    public Engagement[] findByStatusAndSupplierEmailSentBefore(EngagementStatus status, LocalDateTime dateTime);
}
