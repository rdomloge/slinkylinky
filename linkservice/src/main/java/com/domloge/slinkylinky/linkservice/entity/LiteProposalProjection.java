package com.domloge.slinkylinky.linkservice.entity;

import java.time.LocalDateTime;
import org.springframework.data.rest.core.config.Projection;

@Projection(name = "liteProposal", types = {Proposal.class})
public interface LiteProposalProjection {

    long getId();

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

    LitePaidLinkProjection[] getPaidLinks();

    boolean isDoNotExpire();
}
