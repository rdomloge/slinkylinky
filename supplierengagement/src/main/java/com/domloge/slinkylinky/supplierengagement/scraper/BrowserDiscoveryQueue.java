package com.domloge.slinkylinky.supplierengagement.scraper;

import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.atomic.AtomicInteger;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Service;

import com.domloge.slinkylinky.supplierengagement.entity.LeadStatus;
import com.domloge.slinkylinky.supplierengagement.entity.SupplierLead;
import com.domloge.slinkylinky.supplierengagement.repo.SupplierLeadRepo;

import lombok.extern.slf4j.Slf4j;

/**
 * Queue and worker for headless-browser-based contact discovery.
 *
 * <p>A single daemon thread blocks on a {@link LinkedBlockingQueue} of lead IDs.
 * It holds one Playwright {@link BrowserContactDiscoveryService.PlaywrightSession}
 * for its lifetime, processing leads one at a time. If the browser fails to
 * initialise, the queue is still available but {@link #isBrowserAvailable()} returns
 * false so callers can warn the user.
 */
@Service
@Slf4j
public class BrowserDiscoveryQueue {

    private final LinkedBlockingQueue<Long> queue = new LinkedBlockingQueue<>();
    private final AtomicInteger processed = new AtomicInteger(0);
    private volatile boolean browserAvailable = false;

    @Autowired
    private SupplierLeadRepo leadRepo;

    @Autowired
    private BrowserContactDiscoveryService browserDiscovery;

    /** Adds a lead ID to the browser discovery queue. */
    public void enqueue(long leadId) {
        queue.offer(leadId);
        log.info("Lead {} queued for browser discovery (queue depth: {})", leadId, queue.size());
    }

    /** Current number of leads waiting in the queue (not counting the one being processed). */
    public int getQueueDepth() {
        return queue.size();
    }

    /** Total number of leads fully processed (success or failure) since startup. */
    public int getProcessed() {
        return processed.get();
    }

    /** Whether Playwright/Chromium initialised successfully at startup. */
    public boolean isBrowserAvailable() {
        return browserAvailable;
    }

    @EventListener(ApplicationReadyEvent.class)
    public void startWorker() {
        // Re-enqueue any leads that were mid-discovery when the application last stopped
        int requeued = 0;
        for (SupplierLead lead : leadRepo.findByStatus(LeadStatus.BROWSER_QUEUED)) {
            queue.offer(lead.getId());
            requeued++;
        }
        if (requeued > 0) {
            log.info("Re-enqueued {} BROWSER_QUEUED lead(s) from database after startup", requeued);
        }

        Thread worker = new Thread(this::workerLoop, "browser-discovery-worker");
        worker.setDaemon(true);
        worker.start();
        log.info("Browser discovery worker thread started");
    }

    private void workerLoop() {
        BrowserContactDiscoveryService.PlaywrightSession session;
        try {
            session = browserDiscovery.openSession();
        } catch (Exception e) {
            log.error("Browser discovery unavailable — failed to launch Chromium: {}", e.getMessage());
            return;
        }

        browserAvailable = true;
        try (session) {
            while (!Thread.currentThread().isInterrupted()) {
                try {
                    Long leadId = queue.take(); // blocks until work arrives
                    processLead(leadId, session);
                    processed.incrementAndGet();
                } catch (InterruptedException ie) {
                    Thread.currentThread().interrupt();
                    break;
                } catch (Exception e) {
                    log.error("Unexpected error in browser discovery worker", e);
                }
            }
        } finally {
            browserAvailable = false;
            log.info("Browser discovery worker stopped");
        }
    }

    private void processLead(long leadId, BrowserContactDiscoveryService.PlaywrightSession session) {
        SupplierLead lead = leadRepo.findById(leadId).orElse(null);
        if (lead == null) {
            log.warn("Lead {} not found in repository — skipping", leadId);
            return;
        }
        if (lead.getStatus() != LeadStatus.BROWSER_QUEUED) {
            log.debug("Lead {} status is {} (not BROWSER_QUEUED) — skipping", leadId, lead.getStatus());
            return;
        }

        log.info("Browser discovery starting for lead {} ({})", leadId, lead.getDomain());
        try {
            String email = browserDiscovery.discoverEmail(lead.getDomain(), session);
            if (email != null) {
                lead.setContactEmail(email);
                lead.setStatus(LeadStatus.CONTACT_FOUND);
                log.info("Browser discovery found email for lead {} ({}): {}", leadId, lead.getDomain(), email);
            } else {
                lead.setStatus(LeadStatus.CONTACT_NOT_FOUND);
                log.info("Browser discovery exhausted for lead {} ({}) — no email found", leadId, lead.getDomain());
            }
        } catch (Exception e) {
            lead.setStatus(LeadStatus.CONTACT_NOT_FOUND);
            log.error("Browser discovery threw exception for lead {} ({}) — marking as CONTACT_NOT_FOUND",
                    leadId, lead.getDomain(), e);
        } finally {
            try {
                leadRepo.save(lead);
            } catch (Exception e) {
                log.error("Failed to persist status for lead {} after browser discovery", leadId, e);
            }
        }
    }
}
