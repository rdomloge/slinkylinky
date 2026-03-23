package com.domloge.slinkylinky.woocommerce.repo;

import java.util.Optional;

import org.springframework.data.repository.CrudRepository;

import com.domloge.slinkylinky.woocommerce.entity.OrderLineItemEntity;

public interface OrderLineItemRepo extends CrudRepository <OrderLineItemEntity, Long>{
    
    Optional<OrderLineItemEntity> findByDemandId(long demandId);

    OrderLineItemEntity[] findByLinkedProposalId(long proposalId);
}
