package com.domloge.slinkylinky.linkservice.repo;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.web.bind.annotation.CrossOrigin;

import com.domloge.slinkylinky.linkservice.entity.Supplier;

@RepositoryRestResource(collectionResourceRel = "suppliers", path = "suppliers")
@CrossOrigin(exposedHeaders = "*")
public interface SupplierRepo extends PagingAndSortingRepository<Supplier, Long>, CrudRepository <Supplier, Long> {
    
    
    List<Supplier> findByCategories_NameIn(List<String> categories);


    @Query(nativeQuery = true,
        value = "select s.* from supplier s "+
        "where s.id not in ( "+
        "    select pl.supplier_id from paid_link pl "+
        "        where pl.demand_id in "+
        "            (select demand.id from demand demand where demand.domain = "+
        "                (select demand.domain from demand demand where demand.id=?1))) "+      // exclude suppliers that already have a paid link for this domain
        "AND s.DA >= (select demand.da_needed from demand demand where demand.id=?1) "+         // match DA
        "AND s.id in (select sc.supplier_id from supplier_categories sc where sc.categories_id in "+ // match categories
        "                (select ldc.categories_id from demand_categories ldc join category c on c.id=ldc.categories_id where ldc.demand_id=?1 and c.disabled=false)) "+
        "AND s.third_party = false "+                                                                // exclude third party suppliers
        "AND s.disabled = false "+                                                                   // exclude disabled suppliers                        
        "ORDER BY s.we_write_fee ASC, "+                                    
        "   s.sem_rush_uk_jan23traffic DESC, "+
        "   s.sem_rush_authority_score DESC")
    Supplier[] findSuppliersForDemandId(long demandId);

    Supplier findByDomainIgnoreCase(String domain);

    Supplier[] findByEmailContainsIgnoreCaseOrNameContainsIgnoreCaseOrCategories_NameIn(String email, String name, String... categories);

    @Query("select count(s) from Supplier s")
    long findCount();
}
