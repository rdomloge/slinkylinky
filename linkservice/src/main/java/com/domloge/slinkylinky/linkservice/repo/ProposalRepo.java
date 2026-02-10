package com.domloge.slinkylinky.linkservice.repo;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.data.rest.core.annotation.RestResource;
import org.springframework.web.bind.annotation.CrossOrigin;

import com.domloge.slinkylinky.linkservice.entity.Proposal;

import jakarta.transaction.Transactional;

@RepositoryRestResource(collectionResourceRel = "proposals", path = "proposals")
@CrossOrigin(exposedHeaders = "*")
public interface ProposalRepo extends CrudRepository <Proposal, Long>, PagingAndSortingRepository<Proposal, Long> {

    @Override
    @RestResource(exported = false)
    void delete(Proposal entity);

    @Override
    @RestResource(exported = false)
    void deleteById(Long id);
    
    @Transactional
    List<Proposal> findAllByDateCreatedLessThanEqualAndDateCreatedGreaterThanEqualOrderByDateCreatedAsc(
        LocalDateTime endDate, LocalDateTime startDate);

    Proposal findByLiveLinkUrl(String liveLinkUrl);

    /*
     * This method is used to find all proposals that have a paid link with a demand domain that matches the given demand domain.
     */
    @Transactional
    Page<Proposal> findAllByPaidLinks_Demand_DomainOrderByDateCreatedDesc(String domain, Pageable pageable);
}
