package com.domloge.slinkylinky.stats.entity;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Index;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(
    uniqueConstraints = @UniqueConstraint(columnNames = "supplierId"),
    indexes = {
        @Index(columnList = "supplierId"),
        @Index(columnList = "domain")
    }
)
@Getter
@Setter
public class SupplierResponsiveness {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    private long supplierId;

    private String domain;

    @Column(columnDefinition = "double precision default 0")
    private double avgResponseDays;

    @Column(columnDefinition = "integer default 0")
    private int sampleSize;

    private LocalDateTime lastCalculated;
}
