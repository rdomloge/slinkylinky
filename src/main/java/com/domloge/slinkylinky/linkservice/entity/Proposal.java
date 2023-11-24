package com.domloge.slinkylinky.linkservice.entity;

import java.time.LocalDate;
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

    private LocalDate dateSentToSupplier;
    private LocalDate dateAcceptedBySupplier;
    private LocalDate dateBlogLive;
    private LocalDate dateInvoiceReceived;
    private LocalDate dateInvoicePaid;
    
    private boolean contentReady;
    private boolean proposalSent;
    private boolean proposalAccepted;
    private boolean blogLive;
    private boolean invoiceReceived;

    @OneToMany
    private List<PaidLink> paidLinks;
}
