package com.domloge.slinkylinky.linkservice.repo;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.data.rest.core.annotation.RestResource;
import org.springframework.web.bind.annotation.CrossOrigin;

import com.domloge.slinkylinky.linkservice.entity.Demand;

@RepositoryRestResource(collectionResourceRel = "demands", path = "demands")
@CrossOrigin(exposedHeaders = "*")
public interface DemandRepo extends CrudRepository<Demand, Long> {

        @Override
        @RestResource(exported = false)
        void delete(Demand entity);

        @Override
        @RestResource(exported = false)
        void deleteById(Long id);

        @Query(nativeQuery = true, value = "SELECT d.* FROM demand d, supplier s " +
                        "WHERE s.id=?1 " +
                        "AND d.domain NOT IN " +
                        "(SELECT d.domain FROM demand d " +
                        "JOIN paid_link pl on pl.demand_id=d.id " +
                        "JOIN supplier s on pl.supplier_id=s.id " +
                        "WHERE s.domain = " +
                        "       (select s.domain from supplier s where s.id=?1)) " + // get the domain of the supplier
                        "AND s.DA >= d.da_needed " +
                        "AND d.id in (select ldc.demand_id from demand_categories ldc where ldc.categories_id in " +
                        "(select c.id from category c inner join supplier_categories sc on sc.categories_id=c.id where sc.supplier_id=?1 and c.disabled=false)) "
                        +
                        "AND d.domain != (SELECT d.domain FROM demand d  where d.id = ?2) " +
                        "AND d.id NOT IN (SELECT pl.demand_id FROM paid_link pl) " +
                        "ORDER BY s.we_write_fee ASC, " +
                        "       s.da DESC")
        Demand[] findDemandForSupplierId(long supplierId, long demandIdToIgnore);

        @Query(nativeQuery = true, value = "SELECT d.* FROM demand d " +
                        "WHERE d.id NOT IN (SELECT pl.demand_id FROM paid_link pl) " +
                        "ORDER BY d.requested ASC, d.name ASC")
        Demand[] findUnsatisfiedDemandOrderedByRequested();

        @Query(nativeQuery = true, value = "SELECT d.* FROM demand d " +
                        "WHERE d.id NOT IN (SELECT pl.demand_id FROM paid_link pl) " +
                        "AND d.domain = ?1")
        Demand[] findUnsatisfiedDemandByDomain(String domain);

        @Query(nativeQuery = true, value = "SELECT d.* FROM demand d " +
                        "WHERE d.id NOT IN (SELECT pl.demand_id FROM paid_link pl) " +
                        "ORDER BY d.da_needed DESC, d.name ASC")
        Demand[] findUnsatisfiedDemandOrderedByDaNeeded();

        Demand[] findByUrlAndAnchorText(String url, String anchorText);

        Demand findById(int id);
}
