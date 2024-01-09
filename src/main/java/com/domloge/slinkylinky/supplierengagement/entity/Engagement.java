package com.domloge.slinkylinky.supplierengagement.entity;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Lob;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter 
@Setter
public class Engagement {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    private String supplierName;

    private String supplierEmail;

    private LocalDateTime supplierEmailSent;

    private String supplierWebsite;

    private String supplierWeWriteFee;

    private String supplierWeWriteFeeCurrency;

    private long proposalId;

    private String guid;

    private EngagementStatus status;

    @Lob
    @Column(columnDefinition="TEXT")
    private String article;
    
}
