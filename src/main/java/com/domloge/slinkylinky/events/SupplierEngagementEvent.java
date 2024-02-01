package com.domloge.slinkylinky.events;

import lombok.Getter;

public class SupplierEngagementEvent extends BaseEvent {

    public enum EventType {
        PROPOSAL_SENT, RECEIVED_RESPONSE
    }

    public enum Response {
        ACCEPTED, DECLINED
    }
    
    @Getter private long proposalId;

    @Getter private Response response;

    @Getter private EventType type;

    public void buildForSent(long proposalId) {
        this.proposalId = proposalId;
        this.type = EventType.PROPOSAL_SENT;
    }

    //
    // Declined fields
    //

    @Getter private String reason;
    @Getter private boolean doNotContact;

    public void buildForDecline(long proposalId, String reason, boolean doNotContact) {
        this.response = Response.DECLINED;
        this.reason = reason;
        this.doNotContact = doNotContact;
        this.proposalId = proposalId;
        this.type = EventType.RECEIVED_RESPONSE;
    }

    //
    // Accepted fields    
    //
    @Getter private String blogTitle;

    @Getter private String blogUrl;

    @Getter private boolean invoiceUploaded;

    public void buildForAccept(String blogTitle, String blogUrl, boolean invoiceUploaded, long proposalId) {
        this.response = Response.ACCEPTED;
        this.blogTitle = blogTitle;
        this.blogUrl = blogUrl;
        this.invoiceUploaded = invoiceUploaded;
        this.proposalId = proposalId;
        this.type = EventType.RECEIVED_RESPONSE;
    }
}
