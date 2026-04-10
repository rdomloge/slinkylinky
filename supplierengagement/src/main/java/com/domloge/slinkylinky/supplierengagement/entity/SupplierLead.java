package com.domloge.slinkylinky.supplierengagement.entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
@Table(name = "supplier_lead")
public class SupplierLead {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    @Column(nullable = false)
    private String source = "collaborator.pro";

    @Column(nullable = false)
    private String domain;

    private BigDecimal price;
    private String currency;
    private String countries;
    private String language;

    @Column(columnDefinition = "TEXT")
    private String constraints;

    private String contactEmail;
    private LocalDateTime outreachSent;
    private String guid;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private LeadStatus status = LeadStatus.NEW;

    @Column(columnDefinition = "bytea")
    private byte[] fileBlob;

    private String fileName;

    @Column(length = 1024)
    private String googleDocUrl;

    private String declineReason;
    private LocalDateTime scrapedAt;
}
