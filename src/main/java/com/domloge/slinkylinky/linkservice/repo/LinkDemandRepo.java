package com.domloge.slinkylinky.linkservice.repo;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.web.bind.annotation.CrossOrigin;

import com.domloge.slinkylinky.linkservice.entity.LinkDemand;

@RepositoryRestResource(collectionResourceRel = "linkdemands", path = "linkdemands")
@CrossOrigin(exposedHeaders = "*")
public interface LinkDemandRepo extends CrudRepository <LinkDemand, Long> {
    
    @Query(nativeQuery = true,
        value = "SELECT ld.* FROM link_demand ld, blogger b, blogger_categories bc, link_demand_categories ldc "+
                "WHERE b.id=?1 "+
                "AND bc.categories_id=ldc.categories_id "+
                "AND ldc.link_demand_id=ld.id "+
                "AND bc.blogger_id=b.id "+
                "AND b.domain NOT IN "+
                "   (SELECT b.domain FROM blogger b, paid_link pl, link_demand ld "+
                        "WHERE pl.blogger_id=b.id AND pl.link_demand_id=ld.id AND ld.id=?1) "+
                "AND b.DA >= ld.da_needed "+
                "AND ld.id != ?2 "+
                "AND ld.id NOT IN (SELECT pl.link_demand_id FROM paid_link pl) "+
                "ORDER BY b.we_write_fee ASC, "+
                "   b.sem_rush_uk_jan23traffic DESC, "+
                "   b.sem_rush_authority_score DESC ")
    List<LinkDemand> findDemandForSupplierId(int supplierId, int linkdemandIdToIgnore);

    @Query(nativeQuery = true,
        value = "SELECT ld.* FROM link_demand ld "+
                "WHERE ld.id NOT IN (SELECT pl.link_demand_id FROM paid_link pl)")
    List<LinkDemand> findUnsatisfiedDemand();
}
