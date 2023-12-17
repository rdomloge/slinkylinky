package com.domloge.slinkylinky.linkservice.repo;

import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.web.bind.annotation.CrossOrigin;

import com.domloge.slinkylinky.linkservice.entity.DemandSite;

@RepositoryRestResource(collectionResourceRel = "demandsites", path = "demandsites")
@CrossOrigin(originPatterns = {"*localhost*"})
public interface DemandSiteRepo extends CrudRepository <DemandSite, Long>, PagingAndSortingRepository<DemandSite, Long> {

    DemandSite findByDomainIgnoreCase(String domain);

    DemandSite[] findByEmailContainsIgnoreCaseOrNameContainsIgnoreCase(String email, String name);
    
}
