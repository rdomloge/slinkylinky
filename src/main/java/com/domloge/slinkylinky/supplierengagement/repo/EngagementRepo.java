package com.domloge.slinkylinky.supplierengagement.repo;

import org.springframework.data.repository.CrudRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.web.bind.annotation.CrossOrigin;

import com.domloge.slinkylinky.supplierengagement.entity.Engagement;

import jakarta.transaction.Transactional;

@RepositoryRestResource(collectionResourceRel = "engagements", path = "engagements")
@CrossOrigin(exposedHeaders = "*")
public interface EngagementRepo extends CrudRepository <Engagement, Long> {
    
    @Transactional
    public Engagement findByGuid(String guid);

}
