package com.domloge.slinkylinky.linkservice.repo;

import java.util.List;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.web.bind.annotation.CrossOrigin;

import com.domloge.slinkylinky.linkservice.entity.AtRiskDemandSiteProjection;
import com.domloge.slinkylinky.linkservice.entity.Supplier;
import com.domloge.slinkylinky.linkservice.entity.SupplierOnboardingMonthProjection;

@RepositoryRestResource(collectionResourceRel = "suppliers", path = "suppliers")
@CrossOrigin(exposedHeaders = "*")
public interface SupplierRepo extends PagingAndSortingRepository<Supplier, Long>, CrudRepository <Supplier, Long> {
    
    
    List<Supplier> findByCategories_NameIn(List<String> categories);

    List<Supplier> findByCategoriesIsEmptyAndDisabledFalse();

    @Query("SELECT s FROM Supplier s WHERE SIZE(s.categories) = 0 AND s.disabled = false AND s.thirdParty = false")
    List<Supplier> findByCategoriesIsEmptyAndDisabledFalseAndThirdPartyFalse();

    @Query("SELECT s FROM Supplier s WHERE SIZE(s.categories) = 0 AND s.disabled = false AND s.thirdParty = false")
    Page<Supplier> findByCategoriesIsEmptyAndDisabledFalseAndThirdPartyFalse(Pageable pageable);

    @Query("SELECT s FROM Supplier s WHERE " +
           "(:search = '' OR LOWER(s.name) LIKE LOWER(CONCAT('%', :search, '%')) " +
           "OR LOWER(s.email) LIKE LOWER(CONCAT('%', :search, '%')) " +
           "OR LOWER(s.domain) LIKE LOWER(CONCAT('%', :search, '%'))) " +
           "AND (:includeDisabled = true OR s.disabled = false)")
    Page<Supplier> findBySearchAndFilter(@Param("search") String search,
                                         @Param("includeDisabled") boolean includeDisabled,
                                         Pageable pageable);

    @Query("SELECT s FROM Supplier s WHERE " +
           "(:search = '' OR LOWER(s.name) LIKE LOWER(CONCAT('%', :search, '%')) " +
           "OR LOWER(s.email) LIKE LOWER(CONCAT('%', :search, '%')) " +
           "OR LOWER(s.domain) LIKE LOWER(CONCAT('%', :search, '%'))) " +
           "AND (:includeDisabled = true OR s.disabled = false) " +
           "AND s.domain NOT IN :excludedDomains")
    Page<Supplier> findBySearchAndFilterExcludingDomains(
            @Param("search") String search,
            @Param("includeDisabled") boolean includeDisabled,
            @Param("excludedDomains") List<String> excludedDomains,
            Pageable pageable);


    @Query(nativeQuery = true,
        value = "select s.* from supplier s "+
        "where s.id not in ( "+
        "    select pl.supplier_id from paid_link pl "+
        "        where pl.demand_id in "+
        "            (select demand.id from demand demand where demand.domain = "+
        "                (select demand.domain from demand demand where demand.id=?1)) "+
        "        AND pl.organisation_id = ?2) "+                                               // exclude suppliers already linked for this org
        "AND s.DA >= (select demand.da_needed from demand demand where demand.id=?1) "+         // match DA
        "AND s.id in (select sc.supplier_id from supplier_categories sc where sc.categories_id in "+ // match categories
        "                (select ldc.categories_id from demand_categories ldc join category c on c.id=ldc.categories_id where ldc.demand_id=?1 and c.disabled=false)) "+
        "AND s.third_party = false "+                                                                // exclude third party suppliers
        "AND s.disabled = false "+                                                                   // exclude globally disabled suppliers
        "AND NOT EXISTS (SELECT 1 FROM supplier_tenant_exclusion ste WHERE ste.supplier_id = s.id AND ste.organisation_id = ?2) "+ // exclude tenant-excluded
        "ORDER BY s.we_write_fee ASC, "+
        "   s.da DESC")
    Supplier[] findSuppliersForDemandId(long demandId, UUID orgId);

    Supplier findByDomainIgnoreCase(String domain);

    Supplier[] findByEmailContainsIgnoreCaseOrNameContainsIgnoreCaseOrDomainContainsIgnoreCaseOrCategories_NameInOrDaGreaterThan(String email, String name, String domain, String[] categories, int da);

    @Query("select count(s) from Supplier s")
    long count();

    long countByDisabledFalse();

    @Query(nativeQuery = true,
        value = "SELECT TO_CHAR(to_timestamp(s.created_date / 1000.0), 'YYYY-MM') AS yearMonth, " +
                "       COUNT(s.id) AS count " +
                "FROM supplier s " +
                "WHERE s.created_date > 0 " +
                "AND to_timestamp(s.created_date / 1000.0) >= NOW() - (:months || ' months')::interval " +
                "GROUP BY yearMonth " +
                "ORDER BY yearMonth ASC")
    List<SupplierOnboardingMonthProjection> countNewSuppliersByMonth(@Param("months") int months);

    @Query(nativeQuery = true,
        value = "SELECT ds.id AS id, ds.name AS name, ds.domain AS domain, COUNT(DISTINCT s.id) AS availableCount " +
                "FROM demand_site ds " +
                "JOIN demand_site_categories dsc ON dsc.demand_site_id = ds.id " +
                "JOIN supplier_categories sc     ON sc.categories_id = dsc.categories_id " +
                "JOIN supplier s ON s.id = sc.supplier_id " +
                "    AND s.disabled = false " +
                "    AND s.third_party = false " +
                "    AND s.id NOT IN ( " +
                "        SELECT pl.supplier_id FROM paid_link pl " +
                "        JOIN demand d ON pl.demand_id = d.id " +
                "        WHERE d.domain = ds.domain " +
                "        AND pl.organisation_id = :orgId " +
                "    ) " +
                "    AND NOT EXISTS ( " +
                "        SELECT 1 FROM supplier_tenant_exclusion ste " +
                "        WHERE ste.supplier_id = s.id AND ste.organisation_id = :orgId " +
                "    ) " +
                "WHERE ds.organisation_id = :orgId " +
                "GROUP BY ds.id, ds.name, ds.domain " +
                "HAVING COUNT(DISTINCT s.id) < :threshold " +
                "ORDER BY COUNT(DISTINCT s.id) ASC")
    List<AtRiskDemandSiteProjection> findAtRiskDemandSites(@Param("threshold") int threshold, @Param("orgId") UUID orgId);
}
