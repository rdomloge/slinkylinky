package com.domloge.slinkylinky.linkservice.repo;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import com.domloge.slinkylinky.linkservice.entity.Blogger;
import com.domloge.slinkylinky.linkservice.entity.Category;
import com.domloge.slinkylinky.linkservice.entity.LinkDemand;

@RepositoryRestResource(collectionResourceRel = "bloggers", path = "bloggers")
public interface BloggerRepo extends CrudRepository <Blogger, Long> {
    
    
    List<Blogger> findByCategories_NameIn(List<String> categories);

    @Query(nativeQuery = true,
        value = "SELECT b.* FROM blogger b, blogger_categories bc, category c "+
                "WHERE b.id NOT IN "+
                "  (SELECT pl.blogger_id FROM paid_link pl WHERE pl.link_demand_id = ?2) "+
                "AND b.id=bc.blogger_id "+
                "AND bc.categories_id=c.id "+
                "AND c.name in (?1) " +
                "AND b.DA >= ?3")
    List<Blogger> findByCategories_NameInWithAvailability(List<String> categories, int linkDemandId, int daNeeded);

    @Query(nativeQuery = true,
        value = "SELECT b.* FROM blogger b, blogger_categories bc, link_demand ld, link_demand_categories ldc "+
                "WHERE ld.id=?1 "+
                "AND bc.categories_id=ldc.categories_id "+
                "AND ldc.link_demand_id=ld.id "+
                "AND bc.blogger_id=b.id "+
                "AND b.website NOT IN "+
                "   (SELECT b.website FROM blogger b, paid_link pl, link_demand ld "+
                        "WHERE pl.blogger_id=b.id AND pl.link_demand_id=ld.id) "+
                "AND b.DA >= ld.da_needed")
    List<Blogger> findBloggersForLinkDemandId(int linkDemandId);
}
