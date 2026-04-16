package com.domloge.slinkylinky.linkservice.repo;

import java.util.UUID;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.data.rest.core.annotation.RestResource;
import org.springframework.web.bind.annotation.CrossOrigin;

import com.domloge.slinkylinky.linkservice.entity.DemandSite;
import com.domloge.slinkylinky.linkservice.entity.DemandSiteCountProjection;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;

@RepositoryRestResource(collectionResourceRel = "demandsites", path = "demandsites")
// @CrossOrigin(originPatterns = {"*host.docker.internal*"})
public interface DemandSiteRepo extends CrudRepository <DemandSite, Long>, PagingAndSortingRepository<DemandSite, Long> {

    /** Hidden from Spring Data REST — exposed via TenantAwareDemandSiteController */
    @Override
    @RestResource(exported = false)
    Page<DemandSite> findAll(Pageable pageable);

    /** Org-scoped paged listing; categories eagerly loaded for the fullDemandSite projection */
    @EntityGraph(attributePaths = {"categories"})
    @RestResource(exported = false)
    Page<DemandSite> findAllByOrganisationId(UUID organisationId, Pageable pageable);

    /** Org-scoped demand sites that have no categories assigned */
    @Query(nativeQuery = true, value =
        "SELECT ds.* FROM demand_site ds " +
        "WHERE ds.organisation_id = ?1 " +
        "AND ds.id NOT IN (SELECT demand_site_id FROM demand_site_categories) " +
        "ORDER BY ds.domain ASC")
    @RestResource(exported = false)
    DemandSite[] findByMissingCategoriesAndOrg(UUID organisationId);

    DemandSite findByDomainIgnoreCase(String domain);

    DemandSite findByDomainIgnoreCaseAndOrganisationId(String domain, UUID organisationId);

    DemandSite[] findByEmailContainsIgnoreCaseOrNameContainsIgnoreCase(String email, String name);

    @Query( nativeQuery=true, value = "SELECT ds.* "+
                                        "FROM demand_site ds "+
                                        "WHERE ds.id NOT IN "+
                                        "(SELECT demand_site_id FROM demand_site_categories) "+
                                        "ORDER BY ds.domain ASC")
    DemandSite[] findByMissingCategories();

    @Query(value="SELECT COUNT(id) FROM demand d WHERE d.demand_site_id=?1", nativeQuery=true)
    int countByDemandSiteId(long demandSiteId);

    @Query(nativeQuery=true, value=
        "SELECT ds.id as id, ds.name as name, ds.domain as domain, COUNT(d.id) as demandCount " +
        "FROM demand_site ds LEFT JOIN demand d ON d.demand_site_id = ds.id " +
        "GROUP BY ds.id, ds.name, ds.domain " +
        "ORDER BY demandCount DESC " +
        "LIMIT :limit")
    List<DemandSiteCountProjection> findTopByDemandCount(int limit);

    @Override
    @RestResource(exported = false)
    void delete(DemandSite entity);

    @Override
    @RestResource(exported = false)
    void deleteById(Long id);
    
}
