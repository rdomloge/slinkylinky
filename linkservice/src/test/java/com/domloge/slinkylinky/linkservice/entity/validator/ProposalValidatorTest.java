package com.domloge.slinkylinky.linkservice.entity.validator;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.ArrayList;
import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.validation.BeanPropertyBindingResult;
import org.springframework.validation.Errors;

import com.domloge.slinkylinky.linkservice.entity.PaidLink;
import com.domloge.slinkylinky.linkservice.entity.Proposal;

/**
 * Unit tests for ProposalValidator — Rule 1 in linkservice/CLAUDE.md.
 *
 * A Proposal must contain between 1 and 3 PaidLinks (inclusive).
 * Zero PaidLinks, null PaidLinks, or more than 3 are all invalid.
 */
public class ProposalValidatorTest {

    private final ProposalValidator validator = new ProposalValidator();

    private Errors validate(Proposal p) {
        BeanPropertyBindingResult errors = new BeanPropertyBindingResult(p, "proposal");
        validator.validate(p, errors);
        return errors;
    }

    // ─── Happy path ───────────────────────────────────────────────────────────

    @Test
    void onePaidLink_isValid() {
        assertFalse(validate(proposalWith(1)).hasFieldErrors("paidLinks"));
    }

    @Test
    void twoPaidLinks_isValid() {
        assertFalse(validate(proposalWith(2)).hasFieldErrors("paidLinks"));
    }

    @Test
    void threePaidLinks_isValid_boundary() {
        assertFalse(validate(proposalWith(3)).hasFieldErrors("paidLinks"));
    }

    // ─── Rejection cases ─────────────────────────────────────────────────────

    @Test
    void nullPaidLinks_rejectsPaidLinks() {
        Proposal p = new Proposal();
        p.setCreatedBy("admin");
        p.setPaidLinks(null);
        assertTrue(validate(p).hasFieldErrors("paidLinks"));
    }

    @Test
    void emptyPaidLinks_rejectsPaidLinks() {
        Proposal p = new Proposal();
        p.setCreatedBy("admin");
        p.setPaidLinks(List.of());
        assertTrue(validate(p).hasFieldErrors("paidLinks"));
    }

    @Test
    void fourPaidLinks_rejectsPaidLinks() {
        assertTrue(validate(proposalWith(4)).hasFieldErrors("paidLinks"));
    }

    // ─── createdBy ───────────────────────────────────────────────────────────

    @Test
    void missingCreatedBy_rejectsCreatedBy() {
        Proposal p = proposalWith(1);
        p.setCreatedBy(null);
        assertTrue(validate(p).hasFieldErrors("createdBy"));
    }

    // ─── updatedBy (update path) ──────────────────────────────────────────────

    @Test
    void updateProposal_missingUpdatedBy_rejectsUpdatedBy() {
        Proposal p = proposalWith(1);
        p.setId(1L); // simulate an existing entity (id > 0)
        // updatedBy deliberately not set
        assertTrue(validate(p).hasFieldErrors("updatedBy"));
    }

    // ─── Helper ───────────────────────────────────────────────────────────────

    private Proposal proposalWith(int paidLinkCount) {
        Proposal p = new Proposal();
        p.setCreatedBy("admin");
        List<PaidLink> links = new ArrayList<>();
        for (int i = 0; i < paidLinkCount; i++) {
            links.add(new PaidLink());
        }
        p.setPaidLinks(links);
        return p;
    }
}
