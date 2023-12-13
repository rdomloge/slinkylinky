package com.domloge.slinkylinky.linkservice.repo;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.web.bind.annotation.CrossOrigin;

import com.domloge.slinkylinky.linkservice.entity.FullLinkDemandProjection;
import com.domloge.slinkylinky.linkservice.entity.LinkDemand;

@RepositoryRestResource(collectionResourceRel = "linkdemands", path = "linkdemands")
@CrossOrigin(exposedHeaders = "*")
public interface LinkDemandRepo extends CrudRepository <LinkDemand, Long> {
    
    @Query(nativeQuery = true,
        value = "SELECT ld.* FROM link_demand ld, supplier s "+
                "WHERE s.id=?1 "+
                "AND s.domain NOT IN "+
                "   (SELECT s.domain FROM supplier s, paid_link pl, link_demand ld "+
                        "WHERE pl.supplier_id=s.id AND pl.link_demand_id=ld.id AND ld.id=?1) "+
                "AND s.DA >= ld.da_needed "+
                "AND ld.id in (select ldc.link_demand_id from link_demand_categories ldc where ldc.categories_id in "+
                        "(select c.id from category c inner join supplier_categories sc on sc.categories_id=c.id where sc.supplier_id=?1)) "+
                "AND ld.domain != (SELECT ld.domain FROM link_demand ld  where ld.id = ?2) "+
                "AND ld.id NOT IN (SELECT pl.link_demand_id FROM paid_link pl) "+
                "ORDER BY s.we_write_fee ASC, "+
                "   s.sem_rush_uk_jan23traffic DESC, "+
                "   s.sem_rush_authority_score DESC ")
    LinkDemand[] findDemandForSupplierId(int supplierId, int linkdemandIdToIgnore);

    @Query(nativeQuery = true,
        value = "SELECT ld.* FROM link_demand ld "+
                "WHERE ld.id NOT IN (SELECT pl.link_demand_id FROM paid_link pl) "+
                "ORDER BY ld.requested ASC, ld.name ASC")
    LinkDemand[] findUnsatisfiedDemandOrderedByRequested();

    @Query(nativeQuery = true,
        value = "SELECT ld.* FROM link_demand ld "+
                "WHERE ld.id NOT IN (SELECT pl.link_demand_id FROM paid_link pl) "+
                "ORDER BY ld.da_needed DESC, ld.name ASC")
    LinkDemand[] findUnsatisfiedDemandOrderedByDaNeeded();

    
    LinkDemand[] findByUrlAndAnchorText(String url, String anchorText);

    LinkDemand findById(int id);
}
