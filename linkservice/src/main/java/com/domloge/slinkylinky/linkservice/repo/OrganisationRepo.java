package com.domloge.slinkylinky.linkservice.repo;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import com.domloge.slinkylinky.linkservice.entity.Organisation;

// Not auto-exposed via Spring Data REST — accessed only through OrganisationController (Phase 6)
@RepositoryRestResource(exported = false)
public interface OrganisationRepo extends CrudRepository<Organisation, UUID>, PagingAndSortingRepository<Organisation, UUID> {

    Optional<Organisation> findBySlug(String slug);
}
