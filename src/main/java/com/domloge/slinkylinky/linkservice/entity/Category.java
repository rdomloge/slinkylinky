package com.domloge.slinkylinky.linkservice.entity;

import org.hibernate.envers.Audited;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Index;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import jakarta.persistence.Version;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(uniqueConstraints = {@UniqueConstraint(columnNames = "name")}, 
        indexes = @Index(columnList = "name"))
@Getter 
@Setter
@Audited
public class Category {
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    private String name;

    @Column(columnDefinition = "boolean default false")
    private boolean disabled;

    private String createdBy;

    private String updatedBy;

    public Category() {
    }

    public Category(String name) {
        this.name = name;
    }

    
    @Version
    @Column(name = "version", columnDefinition = "bigint default 0")
    private Long version;
}
