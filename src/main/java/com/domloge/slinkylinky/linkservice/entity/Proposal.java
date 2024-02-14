package com.domloge.slinkylinky.linkservice.entity;

import java.time.LocalDateTime;
import java.util.List;

import org.hibernate.annotations.Fetch;
import org.hibernate.annotations.FetchMode;
import org.hibernate.envers.Audited;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Index;
import jakarta.persistence.Lob;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import jakarta.persistence.Version;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(uniqueConstraints = {@UniqueConstraint(columnNames = "liveLinkUrl")}, indexes = {@Index(columnList = "dateCreated")})
@Getter 
@Setter
@Audited
public class Proposal {
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;
    
    private LocalDateTime dateCreated;

    private LocalDateTime dateSentToSupplier;
    private boolean proposalSent;

    private LocalDateTime dateAcceptedBySupplier;
    private boolean proposalAccepted;

    private LocalDateTime dateBlogLive;
    private boolean blogLive;

    private LocalDateTime dateInvoiceReceived;
    private boolean invoiceReceived;

    private LocalDateTime dateInvoicePaid;
    private boolean invoicePaid;
    
    private boolean contentReady;

    private String liveLinkUrl;
    private String liveLinkTitle;

    private String createdBy;

    private String updatedBy;

    @Column(columnDefinition = "bigint default 0")
    private long supplierSnapshotVersion;

    @Lob
    @Column(columnDefinition="TEXT")
    private String article;

    @OneToMany(fetch = FetchType.EAGER)
    @Fetch(FetchMode.SUBSELECT)
    @Audited
    private List<PaidLink> paidLinks;


    @Version
    @Column(name = "version", columnDefinition = "bigint not null default 1")
    private Long version;
}
