package com.domloge.slinkylinky.supplierengagement.controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.apache.hc.client5.http.classic.methods.HttpPost;
import org.apache.hc.client5.http.impl.classic.CloseableHttpClient;
import org.apache.hc.client5.http.impl.classic.CloseableHttpResponse;
import org.apache.hc.client5.http.impl.classic.HttpClients;
import org.apache.hc.core5.http.ContentType;
import org.apache.hc.core5.http.io.entity.StringEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
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

import com.domloge.slinkylinky.supplierengagement.entity.LeadStatus;
import com.domloge.slinkylinky.supplierengagement.entity.SupplierLead;
import com.domloge.slinkylinky.supplierengagement.email.HttpUtils;
import com.domloge.slinkylinky.supplierengagement.repo.SupplierLeadRepo;
import com.domloge.slinkylinky.supplierengagement.scraper.ContactDiscoveryService;
import com.domloge.slinkylinky.supplierengagement.scraper.LeadOutreachService;
import com.domloge.slinkylinky.supplierengagement.scraper.LeadScraper;
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
    private LeadOutreachService outreachService;

    @Autowired
    private HttpUtils httpUtils;

    @Value("${linkservice_baseurl}")
    private String linkServiceBase;

    private final ObjectMapper objectMapper = new ObjectMapper();

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
            @RequestBody(required = false) Map<String, Object> body) {

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
        int scrapeLimit = 0;
        if (body != null && body.get("limit") != null) {
            Object limitObj = body.get("limit");
            if (limitObj instanceof Number) {
                scrapeLimit = ((Number) limitObj).intValue();
            } else if (limitObj instanceof String) {
                try {
                    scrapeLimit = Integer.parseInt((String) limitObj);
                } catch (NumberFormatException e) {
                    // ignore, use default 0
                }
            }
        }
        scraper.scrapeAsync(cookies, scrapeLimit);
        return ResponseEntity.accepted().body(Map.of("started", true, "source", source));
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
     * Attempts to discover a contact email from the lead's website.
     * Updates the lead's contactEmail and status.
     */
    @PostMapping("/{id}/discover")
    @PreAuthorize("hasRole('global_admin')")
    public ResponseEntity<SupplierLead> discover(@PathVariable long id) {
        SupplierLead lead = leadRepo.findById(id).orElse(null);
        if (lead == null) return ResponseEntity.notFound().build();

        String email = discoveryService.discoverEmail(lead.getDomain());
        if (email != null) {
            lead.setContactEmail(email);
            lead.setStatus(LeadStatus.CONTACT_FOUND);
        } else {
            log.info("No email found for lead {} ({})", id, lead.getDomain());
        }
        return ResponseEntity.ok(leadRepo.save(lead));
    }

    /**
     * Sends the outreach email to the lead's contact email.
     */
    @PostMapping("/{id}/sendOutreach")
    @PreAuthorize("hasRole('global_admin')")
    public ResponseEntity<Void> sendOutreach(@PathVariable long id) {
        try {
            outreachService.sendOutreach(id);
            return ResponseEntity.ok().build();
        } catch (IllegalArgumentException e) {
            return ResponseEntity.notFound().build();
        } catch (IllegalStateException e) {
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
    public ResponseEntity<Void> convertToSupplier(@PathVariable long id) {
        SupplierLead lead = leadRepo.findById(id).orElse(null);
        if (lead == null) return ResponseEntity.notFound().build();

        try {
            String accessToken = httpUtils.fetchAccessToken();
            String url = linkServiceBase + "/suppliers";

            Map<String, Object> payload = Map.of(
                    "name",               lead.getDomain(),
                    "email",              lead.getContactEmail() != null ? lead.getContactEmail() : "",
                    "website",            "https://" + lead.getDomain(),
                    "domain",             lead.getDomain(),
                    "weWriteFee",         0,
                    "weWriteFeeCurrency", lead.getCurrency() != null ? lead.getCurrency() : "",
                    "thirdParty",         false,
                    "source",             lead.getSource()
            );

            String json = objectMapper.writeValueAsString(payload);

            HttpPost post = new HttpPost(url);
            post.setHeader("Authorization", "Bearer " + accessToken);
            post.setHeader("Content-Type", "application/json");
            post.setEntity(new StringEntity(json, ContentType.APPLICATION_JSON));

            try (CloseableHttpClient client = HttpClients.createDefault();
                 CloseableHttpResponse response = client.execute(post)) {
                int code = response.getCode();
                if (code == 201 || code == 200) {
                    log.info("Lead {} ({}) converted to Supplier", id, lead.getDomain());
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
            @RequestPart(value = "file", required = false) MultipartFile file) throws IOException {

        SupplierLead lead = leadRepo.findByGuid(guid);
        if (lead == null) return ResponseEntity.notFound().build();

        lead.setStatus(LeadStatus.ACCEPTED);
        if (googleDocUrl != null && !googleDocUrl.isBlank()) {
            lead.setGoogleDocUrl(googleDocUrl);
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

        lead.setStatus(LeadStatus.DECLINED);
        if (body != null && body.containsKey("declineReason")) {
            lead.setDeclineReason(body.get("declineReason"));
        }
        leadRepo.save(lead);
        log.info("Lead {} ({}) declined", lead.getId(), lead.getDomain());
        return ResponseEntity.ok().build();
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    private LeadScraper findScraper(String source) {
        return scrapers.stream()
                .filter(s -> s.getSourceKey().equalsIgnoreCase(source))
                .findFirst()
                .orElse(null);
    }
}
