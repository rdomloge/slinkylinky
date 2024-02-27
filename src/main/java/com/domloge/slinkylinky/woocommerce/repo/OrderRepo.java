package com.domloge.slinkylinky.woocommerce.repo;

import java.util.Optional;

import org.springframework.data.repository.CrudRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.web.bind.annotation.CrossOrigin;

import com.domloge.slinkylinky.woocommerce.entity.OrderEntity;


@RepositoryRestResource(collectionResourceRel = "orders", path = "orders")
@CrossOrigin(originPatterns = {"*localhost*"})
public interface OrderRepo extends CrudRepository <OrderEntity, Long>  {

    Optional<OrderEntity> findByExternalId(long externalId);

    OrderEntity findByLineItems_demandIdEquals(long demandId);
    
}
