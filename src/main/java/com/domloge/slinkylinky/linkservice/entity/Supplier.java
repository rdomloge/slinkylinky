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

@Entity
@Table(uniqueConstraints = {@UniqueConstraint(columnNames = "domain")},
        indexes = {@Index(columnList = "domain"), 
                    @Index(columnList = "da"),
                    @Index(columnList = "name"),
                    @Index(columnList = "email")})
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
    private String weWriteFeeCurrency;
    private int semRushAuthorityScore;
    private int semRushUkMonthlyTraffic;
    private int semRushUkJan23Traffic;
    private boolean thirdParty;

    private boolean disabled;

    private String createdBy;
    private String updatedBy;   

    @ManyToMany(fetch = FetchType.EAGER)
    @Fetch(FetchMode.SUBSELECT)
    private List<Category> categories;

    public void setWebsite(String website) {
        this.website = website;
        if(null != website && !website.isEmpty()) {
            this.domain = Util.stripDomain(website);
        }
        else {
            this.domain = null;
        }
    }
}
