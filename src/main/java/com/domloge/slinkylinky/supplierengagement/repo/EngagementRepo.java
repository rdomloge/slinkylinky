package com.domloge.slinkylinky.supplierengagement.repo;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.RequestBody;

import com.domloge.slinkylinky.supplierengagement.entity.Engagement;

import jakarta.transaction.Transactional;

@RepositoryRestResource(collectionResourceRel = "engagements", path = "engagements")
@CrossOrigin(exposedHeaders = "*")
public interface EngagementRepo extends CrudRepository <Engagement, Long> {
    
    @Transactional
    public Engagement findByGuid(String guid);

    
    

}
