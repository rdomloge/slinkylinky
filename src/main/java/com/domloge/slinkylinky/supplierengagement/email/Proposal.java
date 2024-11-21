package com.domloge.slinkylinky.supplierengagement.email;

import java.time.LocalDateTime;
import java.util.List;

import lombok.Getter;
import lombok.Setter;

@Getter 
@Setter
public class Proposal {
    
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

    private long supplierSnapshotVersion;

    private String article;

    private List<PaidLink> paidLinks;

    private boolean doNotExpire;


    private Long version;
}
