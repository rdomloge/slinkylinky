package com.domloge.slinkylinky.linkservice.repo;

import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.RepositoryDefinition;
import org.springframework.data.rest.core.annotation.RestResource;
import org.springframework.web.bind.annotation.CrossOrigin;

import com.domloge.slinkylinky.linkservice.entity.BlackListedSupplier;

@RepositoryDefinition(domainClass = BlackListedSupplier.class, idClass = Long.class)
@CrossOrigin(originPatterns = {"*localhost*"})
public interface BlackListedSupplierRepo extends CrudRepository <BlackListedSupplier, Long> {


    
    @RestResource(exported = false) // access via the support controller which can pair down the domain
    BlackListedSupplier findByDomainIgnoreCase(String domain);

    @RestResource(exported = false) // access via the support controller which can pair down the domain
    BlackListedSupplier[] findByDomainContainsIgnoreCaseOrderByIdAsc(String domain); // used by the blacklist admin page (when searching)
}
