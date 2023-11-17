package com.domloge.slinkylinky.linkservice.repo;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import com.domloge.slinkylinky.linkservice.entity.Blogger;
import com.domloge.slinkylinky.linkservice.entity.Category;
import com.domloge.slinkylinky.linkservice.entity.Client;

@RepositoryRestResource(collectionResourceRel = "bloggers", path = "bloggers")
public interface BloggerRepo extends CrudRepository <Blogger, Long> {
    
    
    List<Blogger> findByCategories_NameIn(List<String> categories);

    @Query(nativeQuery = true,
        value = "SELECT b.* FROM blogger b, blogger_categories bc, category c "+
                "WHERE b.id NOT IN "+
                "  (SELECT pl.blogger_id FROM paid_link pl WHERE pl.client_id = ?2) "+
                "AND b.id=bc.blogger_id "+
                "AND bc.categories_id=c.id "+
                "AND c.name in (?1)")
    List<Blogger> findByCategories_NameInWithAvailability(List<String> categories, int clientId);
}
