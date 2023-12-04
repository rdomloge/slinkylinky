package com.domloge.slinkylinky.linkservice.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter 
@Setter
public class PaidLink {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;
    
    // @Column(nullable = false)
    @ManyToOne
    @JoinColumn(nullable = false, referencedColumnName="id")
    private Supplier supplier;

    // @Column(nullable = false)
    @ManyToOne()
    @JoinColumn(nullable = false, referencedColumnName="id")
    private LinkDemand linkDemand;
}
