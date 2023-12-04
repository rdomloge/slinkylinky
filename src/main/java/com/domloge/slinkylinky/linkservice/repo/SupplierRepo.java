package com.domloge.slinkylinky.linkservice.repo;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.web.bind.annotation.CrossOrigin;

import com.domloge.slinkylinky.linkservice.entity.Supplier;

@RepositoryRestResource(collectionResourceRel = "suppliers", path = "suppliers")
@CrossOrigin(originPatterns = {"*localhost*"})
public interface SupplierRepo extends PagingAndSortingRepository<Supplier, Long>, CrudRepository <Supplier, Long> {
    
    
    List<Supplier> findByCategories_NameIn(List<String> categories);


    @Query(nativeQuery = true,
        value = "SELECT s.* FROM supplier s, supplier_categories sc, link_demand ld, link_demand_categories ldc "+
                "WHERE ld.id=?1 "+
                "AND sc.categories_id=ldc.categories_id "+
                "AND ldc.link_demand_id=ld.id "+
                "AND sc.supplier_id=s.id "+
                "AND s.domain NOT IN "+
                "   (SELECT s.domain FROM supplier s, paid_link pl, link_demand ld "+
                        "WHERE pl.supplier_id=s.id AND pl.link_demand_id=ld.id) "+
                "AND s.DA >= ld.da_needed "+
                "ORDER BY s.we_write_fee ASC, "+
                "   s.sem_rush_uk_jan23traffic DESC, "+
                "   s.sem_rush_authority_score DESC")
    Supplier[] findSuppliersForLinkDemandId(int linkDemandId);

    Supplier findByDomainIgnoreCase(String domain);

    Supplier[] findByEmailContainsIgnoreCaseOrNameContainsIgnoreCaseOrCategories_NameIn(String email, String name, String... categories);

    long count();
}
