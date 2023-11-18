package com.domloge.slinkylinky.linkservice.repo;

import org.springframework.data.repository.CrudRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.web.bind.annotation.CrossOrigin;

import com.domloge.slinkylinky.linkservice.entity.LinkDemand;

@RepositoryRestResource(collectionResourceRel = "linkdemands", path = "linkdemands")
@CrossOrigin(originPatterns = {"*localhost*"})
public interface LinkDemandRepo extends CrudRepository <LinkDemand, Long> {
    
}
