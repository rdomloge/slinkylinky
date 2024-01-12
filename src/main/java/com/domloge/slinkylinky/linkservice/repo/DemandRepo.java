package com.domloge.slinkylinky.linkservice.repo;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.data.rest.core.annotation.RestResource;
import org.springframework.web.bind.annotation.CrossOrigin;

import com.domloge.slinkylinky.linkservice.entity.Demand;

@RepositoryRestResource(collectionResourceRel = "demands", path = "demands")
@CrossOrigin(exposedHeaders = "*")
public interface DemandRepo extends CrudRepository <Demand, Long> {
    
        @Override
        @RestResource(exported = false)
        void delete(Demand entity);

        @Override
        @RestResource(exported = false)
        void deleteById(Long id);

        @Query(nativeQuery = true,
                value = "SELECT ld.* FROM demand ld, supplier s "+
                        "WHERE s.id=?1 "+
                        "AND s.domain NOT IN "+
                        "   (SELECT s.domain FROM supplier s, paid_link pl, demand ld "+
                                "WHERE pl.supplier_id=s.id AND pl.demand_id=ld.id AND ld.id=?1) "+
                        "AND s.DA >= ld.da_needed "+
                        "AND ld.id in (select ldc.demand_id from demand_categories ldc where ldc.categories_id in "+
                                "(select c.id from category c inner join supplier_categories sc on sc.categories_id=c.id where sc.supplier_id=?1)) "+
                        "AND ld.domain != (SELECT ld.domain FROM demand ld  where ld.id = ?2) "+
                        "AND ld.id NOT IN (SELECT pl.demand_id FROM paid_link pl) "+
                        "ORDER BY s.we_write_fee ASC, "+
                        "   s.sem_rush_uk_jan23traffic DESC, "+
                        "   s.sem_rush_authority_score DESC ")
    Demand[] findDemandForSupplierId(int supplierId, int demandIdToIgnore);

    @Query(nativeQuery = true,
        value = "SELECT ld.* FROM demand ld "+
                "WHERE ld.id NOT IN (SELECT pl.demand_id FROM paid_link pl) "+
                "ORDER BY ld.requested ASC, ld.name ASC")
    Demand[] findUnsatisfiedDemandOrderedByRequested();

    @Query(nativeQuery = true,
        value = "SELECT d.* FROM demand d "+
                "WHERE d.id NOT IN (SELECT pl.demand_id FROM paid_link pl) "+
                "AND d.domain = ?1")
    Demand[] findUnsatisfiedDemandByDomain(String domain);

    @Query(nativeQuery = true,
        value = "SELECT ld.* FROM demand ld "+
                "WHERE ld.id NOT IN (SELECT pl.demand_id FROM paid_link pl) "+
                "ORDER BY ld.da_needed DESC, ld.name ASC")
    Demand[] findUnsatisfiedDemandOrderedByDaNeeded();

    
    Demand[] findByUrlAndAnchorText(String url, String anchorText);

    Demand findById(int id);
}
