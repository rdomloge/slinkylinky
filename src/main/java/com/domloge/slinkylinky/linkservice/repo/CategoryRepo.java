package com.domloge.slinkylinky.linkservice.repo;

import org.springframework.data.repository.CrudRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.web.bind.annotation.CrossOrigin;

import com.domloge.slinkylinky.linkservice.entity.Category;

@RepositoryRestResource(collectionResourceRel = "categories", path = "categories")
@CrossOrigin(originPatterns = {"*localhost*"})
public interface CategoryRepo extends CrudRepository <Category, Long> {
    
    Category findByNameIgnoreCase(String name);

    Category[] findByNameContainsIgnoreCase(String name);
}
