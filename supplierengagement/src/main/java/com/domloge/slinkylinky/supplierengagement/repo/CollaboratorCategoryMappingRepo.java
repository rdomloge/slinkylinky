package com.domloge.slinkylinky.supplierengagement.repo;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.domloge.slinkylinky.supplierengagement.entity.CollaboratorCategoryMapping;
import com.domloge.slinkylinky.supplierengagement.entity.MappingStatus;

public interface CollaboratorCategoryMappingRepo extends JpaRepository<CollaboratorCategoryMapping, Long> {

    Optional<CollaboratorCategoryMapping> findByCollaboratorCategory(String collaboratorCategory);

    List<CollaboratorCategoryMapping> findAllByStatus(MappingStatus status);

    List<CollaboratorCategoryMapping> findAllByOrderByStatusAscCollaboratorCategoryAsc();
}
