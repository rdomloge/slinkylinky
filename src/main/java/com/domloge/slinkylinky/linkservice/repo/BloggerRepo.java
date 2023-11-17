package com.domloge.slinkylinky.linkservice.repo;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import com.domloge.slinkylinky.linkservice.Category;
import com.domloge.slinkylinky.linkservice.entity.Blogger;
import com.domloge.slinkylinky.linkservice.entity.Client;

@RepositoryRestResource(collectionResourceRel = "bloggers", path = "bloggers")
public interface BloggerRepo extends CrudRepository <Blogger, Long> {
    
    
    List<Blogger> findByCategoriesIn(List<Category> categories);

    // SELECT * FROM users WHERE user.id NOT IN (SELECT user.id FROM usertask)
    @Query(nativeQuery = true, 
        value = "SELECT * FROM blogger b WHERE b.id NOT IN (SELECT pl.blogger_id FROM paid_link pl)")
    List<Blogger> findByCategoriesInWithAvailability(List<Category> categories);
}
