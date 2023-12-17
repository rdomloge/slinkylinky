package com.domloge.slinkylinky.linkservice.entity;

import java.util.List;

import org.hibernate.annotations.Fetch;
import org.hibernate.annotations.FetchMode;

import com.domloge.slinkylinky.linkservice.Util;

import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Index;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import lombok.Getter;
import lombok.Setter;

@Table(indexes = {@Index(columnList="name"), 
                    @Index(columnList = "email"),
                    @Index(columnList = "domain"),
                    @Index(columnList = "url")},
        uniqueConstraints = {@UniqueConstraint(columnNames = "domain")})
@Entity
@Getter 
@Setter
public class DemandSite {
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    private String name;//
    private String url;//
    private String domain;
    private String createdBy;
    private String email;

    @ManyToMany(fetch = FetchType.EAGER)
    @Fetch(FetchMode.JOIN)
    private List<Category> categories;

    @ManyToMany(fetch = FetchType.LAZY)
    // @Fetch(FetchMode.SUBSELECT)
    private List<Demand> demands;


    public void setDomain(String domain) {
        this.domain = Util.stripDomain(domain); // it's sometimes got www.
    }

    public void setUrl(String url) {
        this.domain = Util.stripDomain(url);
        this.url = url;
    }
}
