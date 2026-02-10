package com.domloge.slinkylinky.linkservice.entity;

import java.time.LocalDateTime;

import org.springframework.cglib.core.Local;
import org.springframework.data.rest.core.config.Projection;

@Projection(name="fullProposal", types = {Proposal.class})
public interface FullProposalProjection {

    LocalDateTime getDateCreated();

    LocalDateTime getDateSentToSupplier();

    boolean isProposalSent();

    LocalDateTime getDateAcceptedBySupplier();

    boolean isProposalAccepted();

    LocalDateTime getDateBlogLive();

    boolean isBlogLive();

    LocalDateTime getDateInvoiceReceived();

    boolean isInvoiceReceived();

    LocalDateTime getDateInvoicePaid();

    boolean isInvoicePaid();

    boolean isContentReady();

    boolean isValidated();

    LocalDateTime getDateValidated();

    String getLiveLinkUrl();

    String getLiveLinkTitle();

    long getSupplierSnapshotVersion();

    FullPaidLinkProjection[] getPaidLinks();

    boolean isDoNotExpire();
    
}
