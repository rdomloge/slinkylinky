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
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicReference;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.domloge.slinkylinky.supplierengagement.email.HttpUtils;
import com.domloge.slinkylinky.supplierengagement.entity.LeadStatus;
import com.domloge.slinkylinky.supplierengagement.entity.SupplierLead;
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
    private static final int    PAGE_SIZE   = 100;
    private static final String USER_AGENT  =
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 " +
            "(KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36";

    /** Collaborator.pro project ID. Configurable per deployment; defaults to the known value. */
    @Value("${collaborator.project.id:128180}")
    private String projectId;

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
    @Async
    public void scrapeAsync(String cookiesOverride, int limitOverride) {
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

        // Use the override limit if provided (> 0), otherwise use the config limit
        int effectiveLimit = limitOverride > 0 ? limitOverride : scrapeLimit;

        log.info("Starting Collaborator.pro API scrape (project_id={}, limit={})",
                projectId, effectiveLimit > 0 ? effectiveLimit : "unlimited");

        try {
            HttpClient client = HttpClient.newBuilder()
                    .followRedirects(HttpClient.Redirect.NORMAL)
                    .build();

            int page       = 1;
            int totalPages = 1; // updated after first response
            int itemsSeen  = 0; // counts items processed against the limit; existing suppliers excluded

            do {
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

                JsonNode data       = root.path("data");
                JsonNode pagination = data.path("pagination");
                totalPages = pagination.path("totalPageCount").asInt(1);

                if (page == 1) {
                    log.info("Catalog has {} items across {} pages (page size {})",
                            pagination.path("totalCount").asInt(),
                            totalPages,
                            PAGE_SIZE);
                }

                JsonNode items = data.path("items");
                for (JsonNode item : items) {
                    LeadDto dto = parseItem(item);
                    if (isKnownSupplier(dto.domain)) {
                        log.debug("Skipping {} — already a supplier in linkservice", dto.domain);
                        continue;
                    }
                    if (effectiveLimit > 0 && itemsSeen >= effectiveLimit) {
                        log.info("Scrape limit of {} reached — stopping early", effectiveLimit);
                        return;
                    }
                    itemsSeen++;
                    try {
                        upsert(dto);
                    } catch (Exception e) {
                        log.warn("Failed to upsert item {}: {}", itemsSeen, e.getMessage());
                    }
                }
                log.info("Page {}/{} done — {} items seen, {} upserted",
                        page, totalPages, itemsSeen, leadsFound.get());

                page++;

                // Small pause to be respectful of the server
                if (page <= totalPages) Thread.sleep(200);

            } while (page <= totalPages);

        } catch (InterruptedException ie) {
            Thread.currentThread().interrupt();
            log.warn("Scrape interrupted");
        } catch (Exception e) {
            log.error("Collaborator.pro scrape failed", e);
        } finally {
            running.set(false);
            log.info("Collaborator.pro scrape finished. Total leads upserted: {}", leadsFound.get());
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
        // of the formatted string, e.g. "77.62 GBP" → currency "GBP"
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
                dto.currency = priceStr.substring(lastSpace + 1).trim();
            }
        }

        // Categories → stored in the constraints field (closest semantic match)
        JsonNode cats = item.path("columns").path("categories");
        if (cats.isArray() && cats.size() > 0) {
            List<String> texts = new ArrayList<>();
            cats.forEach(c -> {
                String t = c.path("text").asText(null);
                if (StringUtils.hasText(t)) texts.add(t);
            });
            if (!texts.isEmpty()) dto.constraints = String.join(", ", texts);
        }

        return dto;
    }

    private void upsert(LeadDto dto) {
        if (!StringUtils.hasText(dto.domain)) return;

        SupplierLead existing = leadRepo.findByDomainAndSource(dto.domain, SOURCE_KEY);
        if (existing != null) {
            // Refresh catalog data; never reset outreach progress
            existing.setPrice(dto.price);
            existing.setCurrency(dto.currency);
            existing.setConstraints(dto.constraints);
            leadRepo.save(existing);
        } else {
            SupplierLead lead = new SupplierLead();
            lead.setSource(SOURCE_KEY);
            lead.setDomain(dto.domain);
            lead.setPrice(dto.price);
            lead.setCurrency(dto.currency);
            lead.setConstraints(dto.constraints);
            lead.setStatus(LeadStatus.NEW);
            lead.setScrapedAt(LocalDateTime.now());
            leadRepo.save(lead);
        }
        leadsFound.incrementAndGet();
    }

    // ── Internal DTO ─────────────────────────────────────────────────────────

    private static class LeadDto {
        String     domain;
        BigDecimal price;
        String     currency;
        String     constraints; // categories from the API
    }
}
