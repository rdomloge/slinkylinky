package com.domloge.slinkylinky.linkservice.entity;

import java.util.Set;

import org.hibernate.annotations.Fetch;
import org.hibernate.annotations.FetchMode;
import org.hibernate.envers.Audited;
import org.hibernate.envers.RelationTargetAuditMode;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import com.domloge.slinkylinky.linkservice.Util;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EntityListeners;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Index;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import jakarta.persistence.Version;
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
@Audited
@EntityListeners(AuditingEntityListener.class)
public class Supplier {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    @Column(name = "created_date", nullable = false, updatable = false, columnDefinition = "bigint default 0")
    @CreatedDate
    private long createdDate;

    @Column(name = "modified_date", columnDefinition = "bigint default 0")
    @LastModifiedDate
    private long modifiedDate = 0;

    private String name;
    private String email;
    private int da;
    private String website;
    private String domain;
    private int weWriteFee;
    private String weWriteFeeCurrency;
    private boolean thirdParty;
    private String source;

    private boolean disabled;

    private String createdBy;
    private String updatedBy;   

    @ManyToMany(fetch = FetchType.EAGER)
    @Fetch(FetchMode.SUBSELECT)
    @Audited(targetAuditMode = RelationTargetAuditMode.AUDITED)
    private Set<Category> categories;

    public void setWebsite(String website) {
        this.website = website;
        if(null != website && !website.isEmpty()) {
            this.domain = Util.stripDomain(website);
        }
        else {
            this.domain = null;
        }
    }

    
    @Version
    @Column(name = "version", columnDefinition = "bigint default 0")
    private Long version;
}
