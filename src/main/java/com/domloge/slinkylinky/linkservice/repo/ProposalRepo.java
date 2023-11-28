package com.domloge.slinkylinky.linkservice.repo;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.repository.CrudRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.web.bind.annotation.CrossOrigin;

import com.domloge.slinkylinky.linkservice.entity.Proposal;

@RepositoryRestResource(collectionResourceRel = "proposals", path = "proposals")
@CrossOrigin(exposedHeaders = "*")
public interface ProposalRepo extends CrudRepository <Proposal, Long> {
    
    List<Proposal> findAllByDateCreatedLessThanEqualAndDateCreatedGreaterThanEqual(LocalDateTime endDate, LocalDateTime startDate);
}
