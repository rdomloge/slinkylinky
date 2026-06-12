package com.domloge.slinkylinky.supplierengagement.entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.CollectionTable;
import jakarta.persistence.Column;
import jakarta.persistence.ElementCollection;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.domloge.slinkylinky.supplierengagement.pricing.LeadPricing;

import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
@Table(name = "supplier_lead")
public class SupplierLead {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    @Column(nullable = false)
    private String source = "collaborator.pro";

    @Column(nullable = false)
    private String domain;

    private BigDecimal price;
    private String currency;
    private String countries;
    private String language;

    /**
     * Fee the lead has explicitly quoted in their reply (e.g. "my fee is X").
     * When set, it overrides BOTH the listed {@link #price} and the derived SL price
     * everywhere — see {@link #getEffectiveFee()} and the convert flow.
     */
    private BigDecimal agreedFee;

    /**
     * How many links this supplier permits on a single page. We only support 2 or 3
     * (never 1). Defaults to 3. Carried onto the Supplier at convert time and honoured
     * when bundling a proposal.
     */
    @Column(name = "links_permitted", nullable = false)
    private Integer linksPermitted = 3;

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "supplier_lead_category", joinColumns = @JoinColumn(name = "lead_id"))
    @Column(name = "category")
    private List<String> categories = new ArrayList<>();

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "supplier_lead_sl_category", joinColumns = @JoinColumn(name = "lead_id"))
    @Column(name = "sl_category_id")
    private List<Long> overrideSlCategoryIds = new ArrayList<>();

    private String contactEmail;
    private LocalDateTime outreachSent;
    private String guid;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private LeadStatus status = LeadStatus.NEW;

    @Column(columnDefinition = "bytea")
    private byte[] fileBlob;

    private String fileName;

    @Column(length = 1024)
    private String googleDocUrl;

    private String declineReason;
    private LocalDateTime scrapedAt;

    /**
     * Soft-delete ("dismiss") marker. When set, the lead is hidden from the active
     * list and is treated as a tombstone by the scraper so the domain is never
     * re-created on a subsequent scrape. Cleared on undismiss.
     */
    private LocalDateTime deletedAt;
    private String deletedBy;

    @Column(name = "category_suggestion", length = 2000)
    private String categorySuggestion;

    /**
     * Free-text message the lead left when responding (specific terms, other sites
     * they own, sale variations, etc.). Captured on the public response page so leads
     * don't have to reply to the outreach email; surfaced in the leads drawer.
     */
    @Column(name = "lead_message", length = 4000)
    private String message;

    @Column(name = "category_suggestion_reviewed", nullable = false)
    private boolean categorySuggestionReviewed = false;

    /** Derived: our quoted fee — 10% off the listed price, rounded to the nearest 5. */
    @Transient
    @JsonProperty(value = "suggestedFee", access = JsonProperty.Access.READ_ONLY)
    public java.math.BigDecimal getSuggestedFee() {
        return LeadPricing.suggestedFee(this.price);
    }

    /**
     * The fee we will actually use for this lead: the agreed fee they quoted if present,
     * otherwise the derived SL price. This is the number used as {@code weWriteFee} at
     * convert time.
     */
    @Transient
    @JsonProperty(value = "effectiveFee", access = JsonProperty.Access.READ_ONLY)
    public java.math.BigDecimal getEffectiveFee() {
        return this.agreedFee != null ? this.agreedFee : LeadPricing.suggestedFee(this.price);
    }
}
