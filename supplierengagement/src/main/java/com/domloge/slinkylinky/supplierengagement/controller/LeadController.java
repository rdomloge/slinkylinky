package com.domloge.slinkylinky.supplierengagement.controller;

import java.io.IOException;
import java.time.Duration;
import java.time.Instant;
import java.time.LocalDateTime;
import java.util.ArrayDeque;
import java.util.Deque;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;
import java.util.stream.Collectors;

import org.apache.hc.client5.http.classic.methods.HttpPost;
import org.apache.hc.client5.http.impl.classic.CloseableHttpClient;
import org.apache.hc.client5.http.impl.classic.CloseableHttpResponse;
import org.apache.hc.client5.http.impl.classic.HttpClients;
import org.apache.hc.core5.http.ContentType;
import org.apache.hc.core5.http.io.entity.StringEntity;
import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.domloge.slinkylinky.common.TenantContext;
import com.domloge.slinkylinky.events.AuditEvent;
import com.domloge.slinkylinky.supplierengagement.entity.LeadStatus;
import com.domloge.slinkylinky.supplierengagement.entity.MappingStatus;
import com.domloge.slinkylinky.supplierengagement.entity.SupplierLead;
import com.domloge.slinkylinky.supplierengagement.email.HttpUtils;
import com.domloge.slinkylinky.supplierengagement.repo.CollaboratorCategoryMappingRepo;
import com.domloge.slinkylinky.supplierengagement.repo.SupplierLeadRepo;
import com.domloge.slinkylinky.supplierengagement.scraper.BrowserDiscoveryQueue;
import com.domloge.slinkylinky.supplierengagement.scraper.CollaboratorAuthSessionService;
import com.domloge.slinkylinky.supplierengagement.scraper.CollaboratorLoginService;
import com.domloge.slinkylinky.supplierengagement.scraper.ContactDiscoveryService;
import com.domloge.slinkylinky.supplierengagement.scraper.LeadOutreachService;
import com.domloge.slinkylinky.supplierengagement.scraper.LeadScraper;
import com.domloge.slinkylinky.supplierengagement.scraper.ScrapeProgress;
import com.domloge.slinkylinky.supplierengagement.scraper.ScrapeStatus;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.mail.MessagingException;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/.rest/leads")
@Slf4j
public class LeadController {

    @Autowired
    private SupplierLeadRepo leadRepo;

    @Autowired
    private List<LeadScraper> scrapers;

    @Autowired
    private ContactDiscoveryService discoveryService;

    @Autowired
    private BrowserDiscoveryQueue browserQueue;

    @Autowired
    private LeadOutreachService outreachService;

    @Autowired
    private CollaboratorCategoryMappingRepo mappingRepo;

    @Autowired
    private HttpUtils httpUtils;

    @Autowired
    private CollaboratorAuthSessionService collaboratorAuthSessionService;

    @Autowired
    private CollaboratorLoginService collaboratorLoginService;

    @Autowired
    private AmqpTemplate auditRabbitTemplate;

    @Value("${linkservice_baseurl}")
    private String linkServiceBase;

    @Value("${collaborator.session.import.max.attempts:5}")
    private int collaboratorImportMaxAttempts;

    @Value("${collaborator.session.import.window.seconds:60}")
    private int collaboratorImportWindowSeconds;

    private final ConcurrentMap<String, Deque<Instant>> collaboratorImportAttempts = new ConcurrentHashMap<>();

    private final ObjectMapper objectMapper = new ObjectMapper();

    // ── Collection listing ────────────────────────────────────────────────────

    /**
     * Returns active leads — excludes those already converted to a Supplier and
     * those that have been dismissed (soft-deleted).
     * Overrides the Spring Data REST default GET /.rest/leads collection endpoint.
     */
    @GetMapping
    @PreAuthorize("hasRole('global_admin')")
    public ResponseEntity<Iterable<SupplierLead>> list() {
        return ResponseEntity.ok(
                leadRepo.findByStatusNotAndDeletedAtIsNullOrderByDomainAsc(LeadStatus.CONVERTED));
    }

    /**
     * Returns dismissed (soft-deleted) leads, for the restore view.
     */
    @GetMapping("/dismissed")
    @PreAuthorize("hasRole('global_admin')")
    public ResponseEntity<Iterable<SupplierLead>> listDismissed() {
        return ResponseEntity.ok(leadRepo.findByDeletedAtIsNotNullOrderByDomainAsc());
    }

    /**
     * Soft-deletes ("dismisses") a lead. The row is kept as a tombstone so the scraper
     * never re-creates the domain on a subsequent scrape. Overrides the Spring Data REST
     * default DELETE /.rest/leads/{id} (which would hard-delete the row).
     */
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('global_admin')")
    public ResponseEntity<Void> dismiss(@PathVariable long id) {
        SupplierLead lead = leadRepo.findById(id).orElse(null);
        if (lead == null) return ResponseEntity.notFound().build();
        if (lead.getDeletedAt() == null) {
            lead.setDeletedAt(LocalDateTime.now());
            lead.setDeletedBy(TenantContext.getUsername());
            leadRepo.save(lead);
            sendLeadAudit("lead dismissed", id, lead.getDomain());
        }
        return ResponseEntity.noContent().build();
    }

    /**
     * Restores a previously dismissed lead, clearing the soft-delete marker so it
     * reappears in the active list.
     */
    @PostMapping("/{id}/undismiss")
    @PreAuthorize("hasRole('global_admin')")
    public ResponseEntity<SupplierLead> undismiss(@PathVariable long id) {
        SupplierLead lead = leadRepo.findById(id).orElse(null);
        if (lead == null) return ResponseEntity.notFound().build();
        if (lead.getDeletedAt() != null) {
            lead.setDeletedAt(null);
            lead.setDeletedBy(null);
            leadRepo.save(lead);
            sendLeadAudit("lead restored", id, lead.getDomain());
        }
        return ResponseEntity.ok(lead);
    }

    private void sendLeadAudit(String what, long id, String domain) {
        AuditEvent ae = new AuditEvent();
        ae.setWho(TenantContext.getUsername());
        TenantContext.getOrganisationId()
            .map(UUID::fromString)
            .ifPresent(ae::setOrganisationId);
        ae.setWhat(what);
        ae.setEventTime(LocalDateTime.now());
        ae.setEntityType("SupplierLead");
        ae.setEntityId(String.valueOf(id));
        ae.setDetail(domain);
        auditRabbitTemplate.convertAndSend(ae);
    }

    // ── Admin endpoints ───────────────────────────────────────────────────────

    /**
     * Trigger a catalog scrape for the given source (default: collaborator.pro).
     * Returns 202 immediately; scrape runs in the background.
     * Returns 409 if a scrape for that source is already running.
     */
    @PostMapping("/scrape")
    @PreAuthorize("hasRole('global_admin')")
    public ResponseEntity<Map<String, Object>> scrape(
            @RequestParam(value = "source", defaultValue = "collaborator.pro") String source,
            @RequestBody(required = false) Map<String, Object> body,
            Authentication authentication) {

        LeadScraper scraper = findScraper(source);
        if (scraper == null) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", "Unknown source: " + source));
        }
        if (scraper.getStatus().isRunning()) {
            return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body(Map.of("error", "Scrape already in progress for " + source));
        }
        String cookies = body != null ? (String) body.get("cookies") : null;
        String authSessionId = body != null ? (String) body.get("authSessionId") : null;
        if (StringUtils.hasText(cookies) && "collaborator.pro".equalsIgnoreCase(source)) {
            return ResponseEntity.badRequest().body(Map.of(
                "error", "Raw cookies are no longer accepted here. Import cookies first via /collaborator/session/import"
            ));
        }
        if ((cookies == null || cookies.isBlank()) && "collaborator.pro".equalsIgnoreCase(source)
                && authSessionId != null && !authSessionId.isBlank()) {
            cookies = collaboratorAuthSessionService.consumeCookies(authSessionId);
            if (cookies == null) {
                return ResponseEntity.badRequest()
                        .body(Map.of("error", "Collaborator session is not ready or has expired"));
            }
        }
        int scrapeLimit = parseIntField(body, "limit", 0);
        // Optional explicit start page (1-based). 0 = not specified → use incremental/beginning.
        int startPage = parseIntField(body, "startPage", 0);

        long projectId = collaboratorAuthSessionService.findProjectId(cookies);

        boolean incremental = body != null && Boolean.TRUE.equals(body.get("incremental"));
        scraper.scrapeAsync(cookies, scrapeLimit, incremental, projectId, startPage);

        String limitDesc = scrapeLimit > 0 ? scrapeLimit + " leads requested" : "unlimited leads requested";
        String startDesc = startPage > 0 ? "page " + startPage : (incremental ? "resume" : "top");
        AuditEvent ae = new AuditEvent();
        ae.setWho(TenantContext.getUsername());
        ae.setWhat(String.format("lead scrape started (%s, start=%s)", limitDesc, startDesc));
        ae.setEventTime(LocalDateTime.now());
        ae.setDetail(String.format("source=%s, limit=%s, incremental=%s, startPage=%s",
                source, scrapeLimit > 0 ? scrapeLimit : "unlimited", incremental,
                startPage > 0 ? startPage : "-"));
        // A scrape is a cross-cutting action with no single target entity, so entityType/
        // entityId are left null (same shape as the "login" audit). organisationId is therefore
        // mandatory — the audit service silently drops records that have neither set.
        TenantContext.getOrganisationId().ifPresentOrElse(
            orgId -> {
                ae.setOrganisationId(UUID.fromString(orgId));
                auditRabbitTemplate.convertAndSend(ae);
            },
            () -> log.warn("Scrape audit for source '{}' not recorded — org_id claim missing "
                    + "from JWT for user {}", source, ae.getWho())
        );

        return ResponseEntity.accepted().body(Map.of("started", true, "source", source));
    }

    /**
     * Imports a manually copied Collaborator Cookie header into a short-lived
     * authenticated session after server-side validation.
     */
    @PostMapping("/collaborator/session/import")
    @PreAuthorize("hasRole('global_admin')")
    public ResponseEntity<CollaboratorAuthSessionService.SessionSnapshot> importCollaboratorCookies(
            @RequestBody(required = false) Map<String, Object> body,
            Authentication authentication) {

        String importedBy = authentication != null ? authentication.getName() : "unknown";
        if (!isImportAllowed(importedBy)) {
            return ResponseEntity.status(HttpStatus.TOO_MANY_REQUESTS).body(
                new CollaboratorAuthSessionService.SessionSnapshot(
                    null,
                    "FAILED",
                    "Too many cookie import attempts. Please wait a minute and retry.",
                    null
                )
            );
        }

        String cookieHeader = body != null ? (String) body.get("cookieHeader") : null;
        CollaboratorAuthSessionService.SessionSnapshot snapshot =
                collaboratorAuthSessionService.importCookies(cookieHeader, importedBy);

        if (!"AUTHENTICATED".equals(snapshot.getStatus())) {
            return ResponseEntity.badRequest().body(snapshot);
        }
        return ResponseEntity.accepted().body(snapshot);
    }

    /**
     * Triggers an automated headless-browser login to Collaborator.pro using credentials
     * supplied in the request body. Uses Playwright + FlareSolverr to bypass Cloudflare.
     *
     * <p>Returns 202 with status {@code AUTHENTICATED} on immediate success, or
     * {@code AWAITING_2FA} when Collaborator.pro requires an email verification code
     * (the browser session is held open; call {@code /collaborator/session/login/verify}
     * with the code to complete login). Returns 400 on failure.
     */
    @PostMapping("/collaborator/session/login")
    @PreAuthorize("hasRole('global_admin')")
    public ResponseEntity<CollaboratorAuthSessionService.SessionSnapshot> autoLogin(
            @RequestBody(required = false) Map<String, String> body) {
        String username = body != null ? body.get("username") : null;
        String password = body != null ? body.get("password") : null;
        CollaboratorAuthSessionService.SessionSnapshot snapshot = collaboratorLoginService.login(username, password);
        if ("AUTHENTICATED".equals(snapshot.getStatus()) || "AWAITING_2FA".equals(snapshot.getStatus())) {
            return ResponseEntity.accepted().body(snapshot);
        }
        return ResponseEntity.badRequest().body(snapshot);
    }

    /**
     * Returns the status of a specific Collaborator auth session by ID.
     * Used by the frontend to re-validate a previously obtained session without re-logging in.
     */
    @GetMapping("/collaborator/session/status")
    @PreAuthorize("hasRole('global_admin')")
    public ResponseEntity<CollaboratorAuthSessionService.SessionSnapshot> sessionStatus(
            @RequestParam("sessionId") String sessionId) {
        if (!StringUtils.hasText(sessionId)) {
            return ResponseEntity.badRequest().body(
                new CollaboratorAuthSessionService.SessionSnapshot(null, "FAILED", "sessionId is required", null)
            );
        }
        return ResponseEntity.ok(collaboratorAuthSessionService.getStatus(sessionId));
    }

    /**
     * Completes a pending 2FA login by submitting the verification code from email.
     * Must be called after {@code /collaborator/session/login} returned {@code AWAITING_2FA}.
     */
    @PostMapping("/collaborator/session/login/verify")
    @PreAuthorize("hasRole('global_admin')")
    public ResponseEntity<CollaboratorAuthSessionService.SessionSnapshot> verify2fa(
            @RequestBody Map<String, String> body) {
        String code = body != null ? body.get("code") : null;
        if (!StringUtils.hasText(code)) {
            return ResponseEntity.badRequest().body(
                new CollaboratorAuthSessionService.SessionSnapshot(null, "FAILED", "Verification code is required", null)
            );
        }
        CollaboratorAuthSessionService.SessionSnapshot snapshot = collaboratorLoginService.submitTwoFactorCode(code.trim());
        if ("AUTHENTICATED".equals(snapshot.getStatus())) {
            return ResponseEntity.accepted().body(snapshot);
        }
        return ResponseEntity.badRequest().body(snapshot);
    }

    private boolean isImportAllowed(String principal) {
        String key = StringUtils.hasText(principal) ? principal : "unknown";
        Instant now = Instant.now();
        Instant cutoff = now.minus(Duration.ofSeconds(Math.max(1, collaboratorImportWindowSeconds)));
        Deque<Instant> attempts = collaboratorImportAttempts.computeIfAbsent(key, k -> new ArrayDeque<>());

        synchronized (attempts) {
            while (!attempts.isEmpty() && attempts.peekFirst().isBefore(cutoff)) {
                attempts.pollFirst();
            }
            if (attempts.size() >= Math.max(1, collaboratorImportMaxAttempts)) {
                return false;
            }
            attempts.addLast(now);
            return true;
        }
    }

    /**
     * Returns the current scrape status for the given source.
     */
    @GetMapping("/scrape/status")
    @PreAuthorize("hasRole('global_admin')")
    public ResponseEntity<ScrapeStatus> scrapeStatus(
            @RequestParam(value = "source", defaultValue = "collaborator.pro") String source) {

        LeadScraper scraper = findScraper(source);
        if (scraper == null) {
            return ResponseEntity.badRequest().build();
        }
        return ResponseEntity.ok(scraper.getStatus());
    }

    /**
     * Returns the resume position (offset/current page) for the given source, so the
     * scrape modal can show where the next scrape will resume and default the start-page input.
     */
    @GetMapping("/scrape/metadata")
    @PreAuthorize("hasRole('global_admin')")
    public ResponseEntity<ScrapeProgress> scrapeMetadata(
            @RequestParam(value = "source", defaultValue = "collaborator.pro") String source) {

        LeadScraper scraper = findScraper(source);
        if (scraper == null) {
            return ResponseEntity.badRequest().build();
        }
        return ResponseEntity.ok(scraper.getProgress());
    }

    /** Defensively parses an optional integer field from the request body (Number or String). */
    private static int parseIntField(Map<String, Object> body, String key, int defaultValue) {
        if (body == null || body.get(key) == null) {
            return defaultValue;
        }
        Object val = body.get(key);
        if (val instanceof Number) {
            return ((Number) val).intValue();
        }
        if (val instanceof String) {
            try {
                return Integer.parseInt(((String) val).trim());
            } catch (NumberFormatException e) {
                return defaultValue;
            }
        }
        return defaultValue;
    }

    /**
     * Attempts to discover a contact email from the lead's website via plain HTTP.
     * If no email is found, the lead is automatically queued for headless-browser discovery.
     */
    @PostMapping("/{id}/discover")
    @PreAuthorize("hasRole('global_admin')")
    public ResponseEntity<SupplierLead> discover(@PathVariable long id) {
        SupplierLead lead = leadRepo.findById(id).orElse(null);
        if (lead == null) return ResponseEntity.notFound().build();
        if (lead.getStatus() == LeadStatus.SEARCHING) return ResponseEntity.ok(lead);
        if (hasPendingMappings(lead)) return ResponseEntity.unprocessableEntity().build();

        lead.setStatus(LeadStatus.SEARCHING);
        leadRepo.save(lead);

        String email = discoveryService.discoverEmail(lead.getDomain());
        if (email != null) {
            lead.setContactEmail(email);
            lead.setStatus(LeadStatus.CONTACT_FOUND);
        } else {
            log.info("No email via HTTP for lead {} ({}) — queuing for browser discovery", id, lead.getDomain());
            lead.setStatus(LeadStatus.BROWSER_QUEUED);
            leadRepo.save(lead);
            browserQueue.enqueue(id);
            return ResponseEntity.ok(lead);
        }
        return ResponseEntity.ok(leadRepo.save(lead));
    }

    /**
     * Re-queues a lead for headless-browser contact discovery.
     * Only permitted when the lead is in CONTACT_NOT_FOUND status.
     */
    @PostMapping("/{id}/requeueBrowser")
    @PreAuthorize("hasRole('global_admin')")
    public ResponseEntity<SupplierLead> requeueBrowser(@PathVariable long id) {
        SupplierLead lead = leadRepo.findById(id).orElse(null);
        if (lead == null) return ResponseEntity.notFound().build();
        if (lead.getStatus() != LeadStatus.CONTACT_NOT_FOUND) {
            return ResponseEntity.badRequest().build();
        }
        lead.setStatus(LeadStatus.BROWSER_QUEUED);
        leadRepo.save(lead);
        browserQueue.enqueue(id);
        return ResponseEntity.ok(lead);
    }

    /**
     * Returns the current browser discovery queue depth and availability.
     */
    @GetMapping("/browser-queue/status")
    @PreAuthorize("hasRole('global_admin')")
    public ResponseEntity<Map<String, Object>> browserQueueStatus() {
        return ResponseEntity.ok(Map.of(
                "queueDepth",       browserQueue.getQueueDepth(),
                "processed",        browserQueue.getProcessed(),
                "browserAvailable", browserQueue.isBrowserAvailable()
        ));
    }

    /**
     * Sends the outreach email to the lead's contact email.
     */
    @PostMapping("/{id}/sendOutreach")
    @PreAuthorize("hasRole('global_admin')")
    public ResponseEntity<SupplierLead> sendOutreach(@PathVariable long id) {
        SupplierLead lead = leadRepo.findById(id).orElse(null);
        if (lead == null) {
            log.error("sendOutreach: lead not found: {}", id);
            return ResponseEntity.notFound().build();
        }
        if (hasPendingMappings(lead)) {
            log.warn("sendOutreach: lead {} has pending mappings", id);
            return ResponseEntity.unprocessableEntity().build();
        }
        try {
            outreachService.sendOutreach(id);
            return ResponseEntity.ok(leadRepo.findById(id).orElseThrow());
        } catch (IllegalArgumentException e) {
            log.error("sendOutreach: IllegalArgumentException for lead {}: {}", id, e.getMessage(), e);
            return ResponseEntity.notFound().build();
        } catch (IllegalStateException e) {
            log.error("sendOutreach: IllegalStateException for lead {}: {}", id, e.getMessage());
            return ResponseEntity.badRequest().build();
        } catch (MessagingException e) {
            log.error("Failed to send outreach for lead {}", id, e);
            return ResponseEntity.internalServerError().build();
        }
    }

    /**
     * Streams the uploaded file blob back to the caller as a download.
     */
    @GetMapping("/{id}/downloadFile")
    @PreAuthorize("hasRole('global_admin')")
    public ResponseEntity<byte[]> downloadFile(@PathVariable long id) {
        SupplierLead lead = leadRepo.findById(id).orElse(null);
        if (lead == null || lead.getFileBlob() == null) return ResponseEntity.notFound().build();

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
        String filename = lead.getFileName() != null ? lead.getFileName() : "sites.bin";
        headers.setContentDispositionFormData("attachment", filename);
        return ResponseEntity.ok().headers(headers).body(lead.getFileBlob());
    }

    /**
     * Converts an ACCEPTED lead into a SlinkyLinky Supplier by calling linkservice.
     */
    @PostMapping("/{id}/convert")
    @PreAuthorize("hasRole('global_admin')")
    public ResponseEntity<?> convertToSupplier(@PathVariable long id, Authentication authentication) {
        SupplierLead lead = leadRepo.findById(id).orElse(null);
        if (lead == null) return ResponseEntity.notFound().build();
        if (hasPendingMappings(lead)) {
            return ResponseEntity.unprocessableEntity()
                    .body(Map.of("error", "Resolve category mappings before converting"));
        }
        if (lead.getCategorySuggestion() != null && !lead.getCategorySuggestion().isBlank()
                && !lead.isCategorySuggestionReviewed()) {
            return ResponseEntity.unprocessableEntity()
                    .body(Map.of("error", "Lead has an unreviewed category suggestion. Review it before converting."));
        }

        try {
            String accessToken = ((JwtAuthenticationToken) authentication).getToken().getTokenValue();
            String url = linkServiceBase + "/suppliers";

            // Resolve categories to linkservice URI references for Spring Data REST.
            // If the admin has set a per-lead override, use those IDs verbatim;
            // otherwise fall back to the global Collaborator → SL mapping table.
            List<String> categoryUris = new java.util.ArrayList<>();
            if (lead.getOverrideSlCategoryIds() != null && !lead.getOverrideSlCategoryIds().isEmpty()) {
                lead.getOverrideSlCategoryIds().forEach(slId ->
                        categoryUris.add(linkServiceBase + "/categories/" + slId));
            } else if (lead.getCategories() != null && !lead.getCategories().isEmpty()) {
                lead.getCategories().stream()
                    .filter(cat -> !cat.isBlank())
                    .forEach(cat -> mappingRepo.findByCollaboratorCategory(cat).ifPresent(m -> {
                        if (m.getStatus() == MappingStatus.MAPPED && m.getSlCategoryId() != null) {
                            categoryUris.add(linkServiceBase + "/categories/" + m.getSlCategoryId());
                        }
                    }));
            }

            // SupplierValidator requires weWriteFeeCurrency to be exactly 1 character
            String currency = (lead.getCurrency() != null && !lead.getCurrency().isBlank())
                    ? lead.getCurrency().substring(0, 1)
                    : "£";

            // weWriteFee = our quoted fee (10% off listed, rounded to 5) — same number
            // the lead saw in the outreach email. Fall back to 0 if no listed price.
            java.math.BigDecimal weWriteFee = com.domloge.slinkylinky.supplierengagement.pricing.LeadPricing
                    .suggestedFee(lead.getPrice());

            Map<String, Object> payload = new java.util.HashMap<>();
            payload.put("name",               lead.getDomain());
            payload.put("email",              lead.getContactEmail() != null ? lead.getContactEmail() : "contact@" + lead.getDomain());
            payload.put("website",            "https://" + lead.getDomain());
            payload.put("domain",             lead.getDomain());
            payload.put("weWriteFee",         weWriteFee != null ? weWriteFee : 0);
            payload.put("weWriteFeeCurrency", currency);
            payload.put("thirdParty",         false);
            payload.put("source",             "Automated outreach");
            payload.put("createdBy",          "supplierengagement-bot");
            if (!categoryUris.isEmpty()) {
                payload.put("categories", categoryUris);
            }

            String json = objectMapper.writeValueAsString(payload);

            HttpPost post = new HttpPost(url);
            post.setHeader("Authorization", "Bearer " + accessToken);
            post.setHeader("Content-Type", "application/json");
            post.setEntity(new StringEntity(json, ContentType.APPLICATION_JSON));

            try (CloseableHttpClient client = HttpClients.createDefault();
                 CloseableHttpResponse response = client.execute(post)) {
                int code = response.getCode();
                if (code == 201 || code == 200) {
                    lead.setStatus(LeadStatus.CONVERTED);
                    leadRepo.save(lead);
                    log.info("Lead {} ({}) converted to Supplier", id, lead.getDomain());

                    AuditEvent ae = new AuditEvent();
                    ae.setWho(TenantContext.getUsername());
                    TenantContext.getOrganisationId()
                        .map(UUID::fromString)
                        .ifPresent(ae::setOrganisationId);
                    ae.setWhat("lead converted to supplier");
                    ae.setEventTime(LocalDateTime.now());
                    ae.setEntityType("SupplierLead");
                    ae.setEntityId(String.valueOf(id));
                    ae.setDetail(lead.getDomain());
                    auditRabbitTemplate.convertAndSend(ae);

                    return ResponseEntity.ok().build();
                } else {
                    log.error("linkservice returned {} when converting lead {}", code, id);
                    return ResponseEntity.status(HttpStatus.BAD_GATEWAY).build();
                }
            }
        } catch (IOException e) {
            log.error("Failed to convert lead {} to Supplier", id, e);
            return ResponseEntity.internalServerError().build();
        }
    }

    /**
     * Admin endpoint: sets the per-lead SL category override and marks the lead's
     * category suggestion (if any) as reviewed. An empty {@code overrideSlCategoryIds}
     * clears any existing override — convert will then fall back to the auto-mapping
     * derived from the global Collaborator → SL category mapping table.
     */
    @PatchMapping("/{id}/categories")
    @PreAuthorize("hasRole('global_admin')")
    public ResponseEntity<SupplierLead> patchCategories(
            @PathVariable long id,
            @RequestBody Map<String, Object> body) {

        SupplierLead lead = leadRepo.findById(id).orElse(null);
        if (lead == null) return ResponseEntity.notFound().build();

        List<Long> ids = new java.util.ArrayList<>();
        Object raw = body != null ? body.get("overrideSlCategoryIds") : null;
        if (raw instanceof List<?>) {
            for (Object o : (List<?>) raw) {
                if (o instanceof Number) {
                    ids.add(((Number) o).longValue());
                } else if (o instanceof String && !((String) o).isBlank()) {
                    try { ids.add(Long.parseLong(((String) o).trim())); }
                    catch (NumberFormatException ignored) { /* skip */ }
                }
            }
        }

        lead.getOverrideSlCategoryIds().clear();
        lead.getOverrideSlCategoryIds().addAll(ids);
        lead.setCategorySuggestionReviewed(true);
        SupplierLead saved = leadRepo.save(lead);

        AuditEvent ae = new AuditEvent();
        ae.setWho(TenantContext.getUsername());
        TenantContext.getOrganisationId()
            .map(UUID::fromString)
            .ifPresent(ae::setOrganisationId);
        ae.setWhat("lead categories overridden");
        ae.setEventTime(LocalDateTime.now());
        ae.setEntityType("SupplierLead");
        ae.setEntityId(String.valueOf(id));
        ae.setDetail(ids.isEmpty() ? "(cleared override)" : ids.stream().map(String::valueOf).collect(Collectors.joining(",")));
        auditRabbitTemplate.convertAndSend(ae);

        return ResponseEntity.ok(saved);
    }

    // ── Public endpoints (whitelisted in SecurityConfig) ─────────────────────

    /**
     * Returns lead details for a given GUID. Used by the public lead response page.
     */
    @GetMapping("/response")
    public ResponseEntity<SupplierLead> getByGuid(@RequestParam("guid") String guid) {
        SupplierLead lead = leadRepo.findByGuid(guid);
        if (lead == null) return ResponseEntity.notFound().build();
        return ResponseEntity.ok(lead);
    }

    /**
     * The lead accepts the partnership invitation.
     * Optionally includes a file of sites they represent and/or a Google Doc URL.
     */
    @PatchMapping(path = "/accept", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<Void> accept(
            @RequestParam("guid") String guid,
            @RequestParam(value = "googleDocUrl", required = false) String googleDocUrl,
            @RequestParam(value = "categorySuggestion", required = false) String categorySuggestion,
            @RequestPart(value = "file", required = false) MultipartFile file) throws IOException {

        SupplierLead lead = leadRepo.findByGuid(guid);
        if (lead == null) return ResponseEntity.notFound().build();
        if (lead.getStatus() == LeadStatus.CONVERTED) {
            // Lead has already been onboarded as a Supplier — refuse to re-open the workflow.
            return ResponseEntity.status(HttpStatus.CONFLICT).build();
        }

        lead.setStatus(LeadStatus.ACCEPTED);
        if (googleDocUrl != null && !googleDocUrl.isBlank()) {
            lead.setGoogleDocUrl(googleDocUrl);
        }
        if (categorySuggestion != null && !categorySuggestion.isBlank()) {
            String trimmed = categorySuggestion.trim();
            lead.setCategorySuggestion(trimmed.length() > 2000 ? trimmed.substring(0, 2000) : trimmed);
            lead.setCategorySuggestionReviewed(false);
        }
        if (file != null && !file.isEmpty()) {
            if (file.getSize() > 5 * 1024 * 1024) {
                return ResponseEntity.status(HttpStatus.PAYLOAD_TOO_LARGE).build();
            }
            lead.setFileBlob(file.getBytes());
            lead.setFileName(file.getOriginalFilename());
        }
        leadRepo.save(lead);
        log.info("Lead {} ({}) accepted", lead.getId(), lead.getDomain());

        AuditEvent ae = new AuditEvent();
        ae.setWho("supplier");
        ae.setWhat("lead response accepted");
        ae.setEventTime(LocalDateTime.now());
        // ae.setEntityType("SupplierLead");
        ae.setEntityId(String.valueOf(lead.getId()));
        ae.setDetail(lead.getDomain());
        auditRabbitTemplate.convertAndSend(ae);

        return ResponseEntity.ok().build();
    }

    /**
     * The lead declines the partnership invitation.
     */
    @PatchMapping("/decline")
    public ResponseEntity<Void> decline(
            @RequestParam("guid") String guid,
            @RequestBody(required = false) Map<String, String> body) {

        SupplierLead lead = leadRepo.findByGuid(guid);
        if (lead == null) return ResponseEntity.notFound().build();
        if (lead.getStatus() == LeadStatus.CONVERTED) {
            // Lead has already been onboarded as a Supplier — refuse to re-open the workflow.
            return ResponseEntity.status(HttpStatus.CONFLICT).build();
        }

        lead.setStatus(LeadStatus.DECLINED);
        if (body != null && body.containsKey("declineReason")) {
            lead.setDeclineReason(body.get("declineReason"));
        }
        leadRepo.save(lead);
        log.info("Lead {} ({}) declined", lead.getId(), lead.getDomain());

        AuditEvent ae = new AuditEvent();
        ae.setWho("supplier");
        ae.setWhat("lead response declined");
        ae.setEventTime(LocalDateTime.now());
        // ae.setEntityType("SupplierLead");
        ae.setEntityId(String.valueOf(lead.getId()));
        ae.setDetail(lead.getDomain());
        auditRabbitTemplate.convertAndSend(ae);

        return ResponseEntity.ok().build();
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    /**
     * Returns the mapping status for a lead — whether it has any categories that
     * still need to be mapped or ignored before workflow actions can proceed.
     */
    @GetMapping("/{id}/mapping-status")
    @PreAuthorize("hasRole('global_admin')")
    public ResponseEntity<Map<String, Object>> mappingStatus(@PathVariable long id) {
        SupplierLead lead = leadRepo.findById(id).orElse(null);
        if (lead == null) return ResponseEntity.notFound().build();

        List<String> pending = pendingCategories(lead);
        return ResponseEntity.ok(Map.of(
                "hasPending",         !pending.isEmpty(),
                "pendingCategories",  pending
        ));
    }

    private boolean hasPendingMappings(SupplierLead lead) {
        return !pendingCategories(lead).isEmpty();
    }

    private List<String> pendingCategories(SupplierLead lead) {
        if (lead.getCategories() == null || lead.getCategories().isEmpty()) return List.of();
        return lead.getCategories().stream()
                .filter(cat -> !cat.isBlank())
                .filter(cat -> mappingRepo.findByCollaboratorCategory(cat)
                        .map(m -> m.getStatus() == MappingStatus.PENDING)
                        .orElse(true))
                .collect(Collectors.toList());
    }

    private LeadScraper findScraper(String source) {
        return scrapers.stream()
                .filter(s -> s.getSourceKey().equalsIgnoreCase(source))
                .findFirst()
                .orElse(null);
    }
}
