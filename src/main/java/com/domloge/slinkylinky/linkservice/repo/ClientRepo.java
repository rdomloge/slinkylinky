package com.domloge.slinkylinky.linkservice.repo;

import org.springframework.data.repository.CrudRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import com.domloge.slinkylinky.linkservice.entity.Client;

@RepositoryRestResource(collectionResourceRel = "clients", path = "clients")
public interface ClientRepo extends CrudRepository <Client, Long> {
    
}
