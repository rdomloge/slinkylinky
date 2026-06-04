package com.domloge.slinkylinky.supplierengagement.scraper;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicReference;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.domloge.slinkylinky.supplierengagement.email.HttpUtils;
import com.domloge.slinkylinky.supplierengagement.entity.CollaboratorCategoryMapping;
import com.domloge.slinkylinky.supplierengagement.entity.LeadStatus;
import com.domloge.slinkylinky.supplierengagement.entity.MappingStatus;
import com.domloge.slinkylinky.supplierengagement.entity.ScrapingMetadata;
import com.domloge.slinkylinky.supplierengagement.entity.SupplierLead;
import com.domloge.slinkylinky.supplierengagement.repo.CollaboratorCategoryMappingRepo;
import com.domloge.slinkylinky.supplierengagement.repo.ScrapingMetadataRepo;
import com.domloge.slinkylinky.supplierengagement.repo.SupplierLeadRepo;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.slf4j.Slf4j;

/**
 * Scrapes the Collaborator.pro catalog via their JSON API endpoint.
 *
 * <p>The catalog API at {@code /catalog/api/data/load} returns paginated JSON —
 * no browser or DOM scraping required. Authentication is handled by injecting
 * session cookies obtained from a manual browser login (bypassing Cloudflare).</p>
 *
 * <p>Data available per item: domain name, publication price + currency, categories.
 * Language and countries are not present in the API response.</p>
 */
@Service
@Slf4j
public class CollaboratorLeadScraper implements LeadScraper {

    private static final String SOURCE_KEY  = "collaborator.pro";
    private static final String API_URL     = "https://collaborator.pro/catalog/api/data/load";
    private static final int    PAGE_SIZE   = 20;
    private static final String USER_AGENT  =
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 " +
            "(KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36";

    /** Maps Collaborator currency codes to display symbols. */
    private static final Map<String, String> CURRENCY_SYMBOLS = Map.of(
        "GBP", "£",
        "USD", "$",
        "EUR", "€",
        "UAH", "₴",
        "PLN", "zł"
    );

    // /** Collaborator.pro project ID. Configurable per deployment; defaults to the known value. */
    // @Value("${collaborator.project.id:128180}")
    // private String projectId;

    /** Maximum items to scrape. 0 = no limit (production). Set to a small number for testing. */
    @Value("${collaborator.scrape.limit:0}")
    private int scrapeLimit;

    /**
     * Fallback session cookies used when no per-request cookies are supplied.
     * Set {@code COLLABORATOR_SESSION_COOKIES} in the environment / K8s secret.
     */
    @Value("${collaborator.session.cookies:}")
    private String sessionCookies;

    @Value("${linkservice_baseurl}")
    private String linkServiceBase;

    @Autowired
    private HttpUtils httpUtils;

    @Autowired
    private SupplierLeadRepo leadRepo;

    @Autowired
    private CollaboratorCategoryMappingRepo mappingRepo;

    @Autowired
    private ScrapingMetadataRepo scrapingMetadataRepo;

    private final AtomicBoolean running    = new AtomicBoolean(false);
    private final AtomicInteger leadsFound = new AtomicInteger(0);
    private final AtomicReference<String> lastError = new AtomicReference<>(null);
    private final ObjectMapper  mapper     = new ObjectMapper();

    @Override
    public String getSourceKey() { return SOURCE_KEY; }

    @Override
    public ScrapeStatus getStatus() {
        return new ScrapeStatus(running.get(), leadsFound.get(), SOURCE_KEY, lastError.get());
    }

    @Override
    public ScrapeProgress getProgress() {
        ScrapingMetadata metadata = scrapingMetadataRepo.findById(SOURCE_KEY).orElse(null);
        int offset = metadata != null ? metadata.getLastOffset() : 0;
        int currentPage = (offset / PAGE_SIZE) + 1;
        return new ScrapeProgress(offset, currentPage, PAGE_SIZE,
                metadata != null ? metadata.getLastScrapedAt() : null);
    }

    @Override
    @Async
    public void scrapeAsync(String cookiesOverride, int limitOverride, boolean incremental, long projectId, int startPage) {
        if (!running.compareAndSet(false, true)) {
            log.warn("Scrape already in progress — ignoring duplicate trigger");
            return;
        }
        leadsFound.set(0);
        lastError.set(null);

        String effectiveCookies = StringUtils.hasText(cookiesOverride) ? cookiesOverride : sessionCookies;
        if (!StringUtils.hasText(effectiveCookies)) {
            log.error("No session cookies provided — scrape aborted. " +
                      "Paste cookies from Chrome DevTools into the scrape modal.");
            running.set(false);
            return;
        }

        // The limit is a STOP CONDITION: how many brand-new leads to add. 0 = unlimited (config default).
        int effectiveLimit = limitOverride > 0 ? limitOverride : scrapeLimit;

        // Resolve where to start. Precedence: explicit startPage > incremental resume > beginning.
        int startOffset;
        if (startPage > 0) {
            startOffset = (startPage - 1) * PAGE_SIZE;
            log.info("Scrape starting from explicit page {} (offset {}) — project_id={}, target={}",
                    startPage, startOffset, projectId, targetDesc(effectiveLimit));
        } else if (incremental) {
            ScrapingMetadata metadata = scrapingMetadataRepo.findById(SOURCE_KEY).orElse(null);
            startOffset = metadata != null ? metadata.getLastOffset() : 0;
            log.info("Incremental scrape: resuming from offset {} (page {}) — project_id={}, target={}",
                    startOffset, (startOffset / PAGE_SIZE) + 1, projectId, targetDesc(effectiveLimit));
        } else {
            startOffset = 0;
            log.info("Starting fresh scrape from the top — project_id={}, target={}",
                    projectId, targetDesc(effectiveLimit));
        }

        try {
            HttpClient client = HttpClient.newBuilder()
                    .followRedirects(HttpClient.Redirect.NORMAL)
                    .build();

            int startPageNum = (startOffset / PAGE_SIZE) + 1;
            int skipWithinFirstPage = startOffset % PAGE_SIZE;

            int page = startPageNum;
            int totalConsumed = 0;       // items examined this run; advances the resume offset
            int newLeadsFound = 0;       // brand-new rows actually inserted
            int totalCount = 0;          // total catalogue size, from the API pagination block
            boolean reachedEnd = false;  // true once the catalogue runs out

            while (true) {
                String url = API_URL + "?project_id=" + projectId
                        + "&page=" + page + "&per-page=" + PAGE_SIZE;

                HttpRequest request = HttpRequest.newBuilder()
                        .uri(URI.create(url))
                        .header("Cookie", effectiveCookies)
                        .header("User-Agent", USER_AGENT)
                        .header("Accept", "application/json")
                        .header("Referer", "https://collaborator.pro/catalog/creator/article?project_id=" + projectId)
                        .GET()
                        .build();

                HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

                if (response.statusCode() != 200) {
                    log.error("API returned HTTP {} on page {} — cookies may be expired", response.statusCode(), page);
                    lastError.set("API returned HTTP " + response.statusCode() + " — cookies may be expired");
                    break;
                }

                JsonNode root = mapper.readTree(response.body());
                if (!root.path("status").asBoolean(false)) {
                    int code = root.path("statusCode").asInt();
                    log.error("API status=false (statusCode={}) — session invalid or project not accessible", code);
                    lastError.set("Session invalid or project not accessible (statusCode=" + code + ")");
                    break;
                }

                JsonNode data = root.path("data");
                if (page == startPageNum) {
                    totalCount = data.path("pagination").path("totalCount").asInt(0);
                    log.info("Catalog reports {} items total (page size {})", totalCount, PAGE_SIZE);
                }

                JsonNode items = data.path("items");
                int itemsReturned = items.isArray() ? items.size() : 0;

                // An empty page means we've run off the end of the catalogue.
                if (itemsReturned == 0) {
                    reachedEnd = true;
                    break;
                }

                int indexOnPage = 0;
                boolean limitReached = false;
                for (JsonNode item : items) {
                    // On the first page, skip items before our offset position within the page.
                    if (page == startPageNum && indexOnPage < skipWithinFirstPage) {
                        indexOnPage++;
                        continue;
                    }
                    indexOnPage++;
                    totalConsumed++;

                    LeadDto dto = parseItem(item);
                    if (!StringUtils.hasText(dto.domain)) {
                        log.debug("Skipping item with no domain");
                        continue;
                    }
                    if (isKnownSupplier(dto.domain)) {
                        log.debug("Skipping {} — already a supplier in linkservice", dto.domain);
                        continue;
                    }

                    // Existing rows never count toward the target. Dismissed tombstones are
                    // skipped entirely; live leads are refreshed but do not advance the count.
                    SupplierLead existing = leadRepo.findByDomainAndSource(dto.domain, SOURCE_KEY);
                    if (existing != null && existing.getDeletedAt() != null) {
                        log.debug("Skipping {} — previously dismissed", dto.domain);
                        continue;
                    }
                    if (existing != null) {
                        try {
                            refreshExisting(existing, dto);
                        } catch (Exception e) {
                            log.warn("Failed to refresh existing lead {}: {}", dto.domain, e.getMessage());
                        }
                        continue;
                    }

                    // Brand-new domain — only a successful insert advances the count.
                    try {
                        insertNew(dto);
                    } catch (Exception e) {
                        log.warn("Failed to insert new lead {}: {}", dto.domain, e.getMessage());
                        continue;
                    }
                    newLeadsFound++;
                    leadsFound.set(newLeadsFound);

                    if (effectiveLimit > 0 && newLeadsFound >= effectiveLimit) {
                        limitReached = true;
                        break;
                    }
                }

                log.info("Page {} done — {} consumed this run, {} new leads inserted", page, totalConsumed, newLeadsFound);

                // Persist resume position after each page: offset = just past everything consumed.
                saveScrapingMetadata(startOffset + totalConsumed);

                if (limitReached) {
                    log.info("Target of {} new leads reached — stopping", effectiveLimit);
                    return;
                }

                // End of catalogue: we've consumed every item the API reports. We deliberately
                // do NOT treat a short page (fewer than PAGE_SIZE items) as the end — the API can
                // return short pages mid-catalogue, and doing so stopped scrapes early.
                if (totalCount > 0 && (startOffset + totalConsumed) >= totalCount) {
                    reachedEnd = true;
                    break;
                }

                page++;
                Thread.sleep(200); // be polite to the server
            }

            if (reachedEnd) {
                // Wrap back to the top so the next scrape picks up newly-added bloggers.
                log.info("Reached the end of the catalogue — resetting resume offset to 0 (inserted {} new leads)", newLeadsFound);
                saveScrapingMetadata(0);
            }

        } catch (InterruptedException ie) {
            Thread.currentThread().interrupt();
            log.warn("Scrape interrupted");
        } catch (Exception e) {
            log.error("Collaborator.pro scrape failed", e);
        } finally {
            running.set(false);
            log.info("Collaborator.pro scrape finished. New leads inserted: {}", leadsFound.get());
        }
    }

    private static String targetDesc(int effectiveLimit) {
        return effectiveLimit > 0 ? effectiveLimit + " new leads" : "unlimited";
    }

    /**
     * Saves or updates the scraping metadata with the given absolute offset.
     * @param newOffset The absolute item offset to resume from on the next scrape.
     */
    private void saveScrapingMetadata(int newOffset) {
        try {
            ScrapingMetadata metadata = scrapingMetadataRepo.findById(SOURCE_KEY)
                    .orElseGet(() -> new ScrapingMetadata());
            metadata.setSource(SOURCE_KEY);
            metadata.setLastOffset(newOffset);
            metadata.setLastScrapedAt(LocalDateTime.now());
            scrapingMetadataRepo.save(metadata);
        } catch (Exception e) {
            log.warn("Failed to save scraping metadata: {}", e.getMessage());
        }
    }

    // ── Private helpers ───────────────────────────────────────────────────────

    /**
     * Returns true if linkservice already has a Supplier for this domain.
     * A null/blank domain always returns false so the item is processed normally.
     */
    private boolean isKnownSupplier(String domain) {
        if (!StringUtils.hasText(domain)) return false;
        try {
            String url = linkServiceBase + "/suppliers/search/findByDomainIgnoreCase?domain=" + domain;
            return httpUtils.get(url) != null;
        } catch (Exception e) {
            log.warn("Could not check linkservice for domain {} — treating as unknown: {}", domain, e.getMessage());
            return false;
        }
    }

    private LeadDto parseItem(JsonNode item) {
        LeadDto dto = new LeadDto();
        dto.domain = item.path("name").asText(null);

        // Price: pricePublicationRaw is a clean numeric value; currency is the last 3 chars
        // of the formatted string, e.g. "77.62 GBP" → currency "GBP".
        // Store the raw listed price on the lead — our suggested fee (the discounted +
        // rounded number we quote in outreach and convert with) is derived from this via
        // LeadPricing.suggestedFee. Keep raw here so the source data stays auditable.
        JsonNode formats = item.path("price").path("formats");
        if (formats.isArray() && formats.size() > 0) {
            JsonNode fmt = formats.get(0);
            double raw = fmt.path("pricePublicationRaw").asDouble(0);
            if (raw > 0) {
                dto.price = BigDecimal.valueOf(raw).setScale(2, RoundingMode.HALF_UP);
            }
            String priceStr = fmt.path("pricePublication").asText("");
            // Format: "77.62 GBP" — currency code is the last token after the space
            int lastSpace = priceStr.lastIndexOf(' ');
            if (lastSpace >= 0 && lastSpace < priceStr.length() - 1) {
                String code = priceStr.substring(lastSpace + 1).trim();
                dto.currency = CURRENCY_SYMBOLS.getOrDefault(code, code);
            }
        }

        // Categories: parse at the integration point into a clean list
        JsonNode cats = item.path("columns").path("categories");
        if (cats.isArray() && cats.size() > 0) {
            cats.forEach(c -> {
                String t = c.path("text").asText(null);
                if (StringUtils.hasText(t)) dto.categories.add(t);
            });
        }

        return dto;
    }

    /** Inserts a brand-new lead row. Caller is responsible for the new-lead count. */
    private void insertNew(LeadDto dto) {
        SupplierLead lead = new SupplierLead();
        lead.setSource(SOURCE_KEY);
        lead.setDomain(dto.domain);
        lead.setPrice(dto.price);
        lead.setCurrency(dto.currency);
        lead.setCategories(dto.categories);
        lead.setStatus(LeadStatus.NEW);
        lead.setScrapedAt(LocalDateTime.now());
        leadRepo.save(lead);
        syncCategoryMappings(dto.categories);
    }

    /** Refreshes catalog data on an existing lead; never resets outreach progress, never counts. */
    private void refreshExisting(SupplierLead existing, LeadDto dto) {
        existing.setPrice(dto.price);
        existing.setCurrency(dto.currency);
        existing.setCategories(dto.categories);
        leadRepo.save(existing);
        syncCategoryMappings(dto.categories);
    }

    /**
     * Ensures every category string in the lead's constraints has a row in the mapping
     * table. New categories are created with status PENDING; existing MAPPED/IGNORED
     * entries are left unchanged so accumulated mappings are preserved.
     */
    private void syncCategoryMappings(List<String> categories) {
        if (categories == null || categories.isEmpty()) return;
        for (String cat : categories) {
            if (cat.isEmpty()) continue;
            if (mappingRepo.findByCollaboratorCategory(cat).isEmpty()) {
                CollaboratorCategoryMapping mapping = new CollaboratorCategoryMapping();
                mapping.setCollaboratorCategory(cat);
                mapping.setStatus(MappingStatus.PENDING);
                try {
                    mappingRepo.save(mapping);
                } catch (Exception e) {
                    // Race condition: another thread inserted the same category between the
                    // findByCollaboratorCategory check and the save — safe to ignore.
                    log.debug("Category mapping already exists for '{}' — skipping", cat);
                }
            }
        }
    }

    // ── Internal DTO ─────────────────────────────────────────────────────────

    private static class LeadDto {
        String       domain;
        BigDecimal   price;
        String       currency;
        List<String> categories = new ArrayList<>();
    }
}
