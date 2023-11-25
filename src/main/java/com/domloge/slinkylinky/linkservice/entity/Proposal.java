package com.domloge.slinkylinky.linkservice.entity;

import java.time.LocalDateTime;
import java.util.List;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter 
@Setter
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
    
    private boolean contentReady;

    @OneToMany
    private List<PaidLink> paidLinks;
}
