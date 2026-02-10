package com.domloge.slinkylinky.linkservice.repo;

import org.springframework.data.repository.CrudRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.data.rest.core.annotation.RestResource;
import org.springframework.web.bind.annotation.CrossOrigin;

import com.domloge.slinkylinky.linkservice.entity.Category;

@RepositoryRestResource(collectionResourceRel = "categories", path = "categories")
@CrossOrigin(originPatterns = {"*localhost*"})
public interface CategoryRepo extends CrudRepository <Category, Long> {
    
    Category findByNameIgnoreCase(String name);

    Category[] findByNameContainsIgnoreCaseAndDisabledFalseOrderByNameAsc(String name); // used by the category selector (when searching)

    Category[] findAllByDisabledFalseOrderByNameAsc(); // used by the category selector
    
    Category[] findAllByOrderByNameAsc(); // returns disabled categories too, for the category admin page



        
    @Override
    @RestResource(exported = false)
    void delete(Category entity);

    @Override
    @RestResource(exported = false)
    void deleteAll();

    @Override
    @RestResource(exported = false)
    void deleteAll(Iterable<? extends Category> entities);

    @Override
    @RestResource(exported = false)
    void deleteAllById(Iterable<? extends Long> ids);

    @Override
    @RestResource(exported = false)
    void deleteById(Long id);

    
}
