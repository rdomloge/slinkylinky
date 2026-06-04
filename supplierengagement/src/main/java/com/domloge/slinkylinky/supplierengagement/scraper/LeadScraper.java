package com.domloge.slinkylinky.supplierengagement.scraper;

public interface LeadScraper {

    /** Unique identifier for the source, e.g. "collaborator.pro" */
    String getSourceKey();

    /**
     * Start a long-running async scrape. Returns immediately; progress tracked via {@link #getStatus()}.
     * @param cookies Raw Cookie header value to inject (e.g. from browser DevTools). May be null/blank,
     *                in which case the scraper falls back to its configured session cookies.
     * @param scrapeLimit Number of brand-new leads to add. 0 = no limit (use config default). Positive = override config.
     * @param incremental If true, resume from the last offset stored in metadata. If false, start from the beginning.
     *                    Ignored when {@code startPage > 0}.
     * @param startPage Explicit 1-based page to start from. 0 = not specified (use incremental/beginning).
     *                  When > 0, overrides {@code incremental}.
     */
    void scrapeAsync(String cookies, int scrapeLimit, boolean incremental, long projectId, int startPage);

    /** Current scrape status: whether it's running and how many leads found so far. */
    ScrapeStatus getStatus();

    /** Resume position (offset/page) for this source, derived from persisted scraping metadata. */
    ScrapeProgress getProgress();
}
