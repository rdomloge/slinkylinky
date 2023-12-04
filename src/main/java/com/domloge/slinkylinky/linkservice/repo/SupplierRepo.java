package com.domloge.slinkylinky.linkservice.repo;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.web.bind.annotation.CrossOrigin;

import com.domloge.slinkylinky.linkservice.entity.Supplier;

@RepositoryRestResource(collectionResourceRel = "suppliers", path = "suppliers")
@CrossOrigin()
public interface SupplierRepo extends PagingAndSortingRepository<Supplier, Long>, CrudRepository <Supplier, Long> {
    
    
    List<Supplier> findByCategories_NameIn(List<String> categories);


    @Query(nativeQuery = true,
        value = "select s.* from supplier s "+
        "left outer join supplier_categories sc on sc.supplier_id=s.id "+
        "left outer join link_demand_categories ldc on ldc.link_demand_id=?1 "+
        "where s.id not in ( "+
        "    select pl.supplier_id from paid_link pl "+
        "        where pl.id in "+
        "            (select demand.id from link_demand demand where demand.domain = "+
        "                (select demand.domain from link_demand demand where demand.id = 108))) "+
        "AND s.DA >= (select demand.da_needed from link_demand demand where demand.id=108) "+
        "AND sc.categories_id=ldc.categories_id")
    Supplier[] findSuppliersForLinkDemandId(int linkDemandId);

    Supplier findByDomainIgnoreCase(String domain);

    Supplier[] findByEmailContainsIgnoreCaseOrNameContainsIgnoreCaseOrCategories_NameIn(String email, String name, String... categories);

    long count();
}
