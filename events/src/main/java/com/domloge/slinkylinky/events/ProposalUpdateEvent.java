package com.domloge.slinkylinky.events;

import lombok.Getter;


public class ProposalUpdateEvent extends BaseEvent {

    public enum ProposalEventType {
        CREATED, UPDATED, DELETED
    }

    
    /** For object mappers */
    public ProposalUpdateEvent() {
    }

    public ProposalUpdateEvent(ProposalEventType type) {
        this.type = type;
    }

    @Getter private String article;
    @Getter private long proposalId;

    @Getter private ProposalEventType type;

    @Getter private String supplierName;
    @Getter private String supplierEmail;
    @Getter private String supplierWebsite;
    @Getter private int supplierWeWriteFee;
    @Getter private String supplierWeWriteFeeCurrency;
    @Getter private boolean supplierIs3rdParty;
    
    public void setProposalDetails(String article, long proposalId) {
        this.article = article;
        this.proposalId = proposalId;
    }

    public void setSupplierDetails(String supplierName, String supplierEmail, String supplierWebsite, 
            int supplierWeWriteFee, String supplierWeWriteFeeCurrency, boolean supplierIs3rdParty) {
                
        this.supplierName = supplierName;
        this.supplierEmail = supplierEmail;
        this.supplierWebsite = supplierWebsite;
        this.supplierWeWriteFee = supplierWeWriteFee;
        this.supplierWeWriteFeeCurrency = supplierWeWriteFeeCurrency;
        this.supplierIs3rdParty = supplierIs3rdParty;
    }
}