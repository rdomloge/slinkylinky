package com.domloge.slinkylinky.linkservice.entity;

import java.util.List;

import com.domloge.slinkylinky.linkservice.Util;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(uniqueConstraints = {@UniqueConstraint(columnNames = "domain")})
@Getter 
@Setter
public class Supplier {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    private String name;
    private String email;
    private int da;
    private String website;
    private String domain;
    private int weWriteFee;
    private int semRushAuthorityScore;
    private int semRushUkMonthlyTraffic;
    private int semRushUkJan23Traffic;

    @ManyToMany
    private List<Category> categories;

    public void setWebsite(String website) {
        this.website = website;
        this.domain = Util.stripDomain(website);
    }
}
