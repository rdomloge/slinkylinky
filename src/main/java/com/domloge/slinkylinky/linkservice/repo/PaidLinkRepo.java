package com.domloge.slinkylinky.linkservice.repo;

import org.springframework.data.repository.CrudRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import com.domloge.slinkylinky.linkservice.entity.PaidLink;

@RepositoryRestResource(collectionResourceRel = "paidlinks", path = "paidlinks")
public interface PaidLinkRepo extends CrudRepository <PaidLink, Long> {
    
    // void createByBlogger_IdAndClient_Id(int logger_id, int client_id);

}
