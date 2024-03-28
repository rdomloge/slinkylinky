package com.domloge.slinkylinky.linkservice.entity;

import java.time.LocalDateTime;

import org.hibernate.envers.Audited;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Index;
import jakarta.persistence.Lob;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(uniqueConstraints = {@UniqueConstraint(columnNames = "domain")}, 
        indexes = @Index(columnList = "domain"))
@Getter 
@Setter
public class BlackListedSupplier {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    @NotNull
    private String createdBy;

    @NotNull
    private LocalDateTime dateCreated;

    @NotNull
    private String domain;

    private int da;

    private int spamRating;

    @Lob
    @Column(columnDefinition="TEXT")
    private String dataPointsJson;
    
}
