package com.domloge.slinkylinky.supplierengagement.scraper;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * Resume position for a scraping source, derived from the persisted
 * {@code scraping_metadata} row. Surfaced to the UI so the operator can see how
 * far through the catalogue the next scrape will resume, and optionally override
 * the start page.
 */
@Getter
@AllArgsConstructor
public class ScrapeProgress {
    /** Absolute item offset stored in metadata (total items consumed so far). */
    private final int lastOffset;
    /** 1-based page the next resume will start on, i.e. {@code lastOffset / pageSize + 1}. */
    private final int currentPage;
    /** Page size used to translate offset ↔ page. */
    private final int pageSize;
    /** When the last scrape ran, or null if never. */
    private final LocalDateTime lastScrapedAt;
}
