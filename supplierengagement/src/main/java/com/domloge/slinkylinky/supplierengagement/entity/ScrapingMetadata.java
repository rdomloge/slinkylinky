package com.domloge.slinkylinky.supplierengagement.entity;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

/**
 * Tracks the pagination offset for each scraping source.
 * The offset represents the absolute position in the source catalog (total items consumed).
 * This enables incremental scraping: resume from where the last scrape left off.
 */
@Entity
@Getter
@Setter
@Table(name = "scraping_metadata")
public class ScrapingMetadata {

    /**
     * Source identifier, e.g. "collaborator.pro". Primary key.
     */
    @Id
    @Column(nullable = false, unique = true)
    private String source;

    /**
     * Absolute offset position in the source catalog.
     * Represents the total number of items consumed (including discarded known suppliers).
     * When resuming an incremental scrape, start from this offset.
     */
    @Column(nullable = false)
    private int lastOffset = 0;

    /**
     * Timestamp of the last successful scrape completion.
     */
    private LocalDateTime lastScrapedAt;
}
