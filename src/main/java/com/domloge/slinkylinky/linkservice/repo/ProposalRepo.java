package com.domloge.slinkylinky.linkservice.repo;

import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.data.repository.CrudRepository;

import com.domloge.slinkylinky.linkservice.entity.Proposal;

@RepositoryRestResource(collectionResourceRel = "proposals", path = "proposals")
@CrossOrigin(originPatterns = {"*localhost*"})
public interface ProposalRepo extends CrudRepository <Proposal, Long> {
    
}
