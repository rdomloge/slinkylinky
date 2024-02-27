package com.domloge.slinkylinky.woocommerce.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
@Table(name = "lineItem")
public class OrderLineItemEntity {
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Getter @Setter protected long id;

    @Column(unique = true)
    private long demandId;

    private Long linkedProposalId;

    @Column(columnDefinition = "boolean default false")
    private boolean proposalComplete = false;
}
