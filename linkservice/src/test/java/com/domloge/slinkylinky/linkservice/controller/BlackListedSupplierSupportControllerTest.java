package com.domloge.slinkylinky.linkservice.controller;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;

import com.domloge.slinkylinky.linkservice.config.TenantContextTest;
import com.domloge.slinkylinky.linkservice.repo.BlackListedSupplierRepo;

/**
 * Integration tests for BlackListedSupplierSupportController — Rule 10 in linkservice/CLAUDE.md.
 *
 * Covers the two endpoints used during supplier onboarding:
 *   - isBlackListed: checks whether a domain is blacklisted (domain stripping tested)
 *   - addBlackListed: adds a domain; rejects if already present
 */
@SpringBootTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
public class BlackListedSupplierSupportControllerTest {

    @Autowired
    private BlackListedSupplierSupportController controller;

    @Autowired
    private BlackListedSupplierRepo blackListedSupplierRepo;

    @MockBean(name = "auditRabbitTemplate")
    private AmqpTemplate auditRabbitTemplate;

    @MockBean(name = "proposalsRabbitTemplate")
    private AmqpTemplate proposalsRabbitTemplate;

    @MockBean(name = "supplierRabbitTemplate")
    private AmqpTemplate supplierRabbitTemplate;

    @BeforeEach
    void setup() {
        blackListedSupplierRepo.deleteAll();
        TenantContextTest.setSecurityContext("testuser", "00000000-0000-0000-0000-000000000001", List.of("global_admin"));
    }

    @org.junit.jupiter.api.AfterEach
    void clearContext() {
        SecurityContextHolder.clearContext();
    }

    // ─── isBlackListed ────────────────────────────────────────────────────────

    @Test
    void isBlackListed_domainNotInDatabase_returnsFalse() {
        ResponseEntity<Boolean> resp = controller.isBlackListed("https://www.notblacklisted.com");
        assertEquals(HttpStatusCode.valueOf(200), resp.getStatusCode());
        assertFalse(resp.getBody());
    }

    @Test
    void isBlackListed_domainIsBlacklisted_returnsTrue() {
        // Add a blacklisted domain first
        controller.addBlackListed("https://www.spammy.com", "{}", 10, 80);

        ResponseEntity<Boolean> resp = controller.isBlackListed("https://www.spammy.com");
        assertEquals(HttpStatusCode.valueOf(200), resp.getStatusCode());
        assertTrue(resp.getBody());
    }

    @Test
    void isBlackListed_fullUrlWithSubdomain_stripsToDomainAndFindsMatch() {
        // The blacklisted entry is stored as "spamsite.com" (stripped)
        controller.addBlackListed("spamsite.com", "{}", 5, 90);

        // Query with a full URL containing a subdomain — should still find the match
        ResponseEntity<Boolean> resp = controller.isBlackListed("https://www.spamsite.com/page");
        assertEquals(HttpStatusCode.valueOf(200), resp.getStatusCode());
        assertTrue(resp.getBody(), "Domain lookup should strip subdomain and match stored entry");
    }

    // ─── addBlackListed ───────────────────────────────────────────────────────

    @Test
    void addBlackListed_newDomain_returns200TrueAndPersists() {
        ResponseEntity<Boolean> resp = controller.addBlackListed(
                "https://www.badsite.com", "{\"traffic\":100}", 15, 70);

        assertEquals(HttpStatusCode.valueOf(200), resp.getStatusCode());
        assertTrue(resp.getBody());

        // Verify persisted
        assertNotNull(blackListedSupplierRepo.findByDomainIgnoreCase("badsite.com"),
                "The blacklisted domain should have been saved to the database");
    }

    @Test
    void addBlackListed_domainAlreadyBlacklisted_returns400False() {
        // Add once
        controller.addBlackListed("duplicate.com", "{}", 20, 30);

        // Try to add the same domain again
        ResponseEntity<Boolean> resp = controller.addBlackListed("duplicate.com", "{}", 20, 30);

        assertEquals(HttpStatusCode.valueOf(400), resp.getStatusCode());
        assertFalse(resp.getBody());
    }
}
