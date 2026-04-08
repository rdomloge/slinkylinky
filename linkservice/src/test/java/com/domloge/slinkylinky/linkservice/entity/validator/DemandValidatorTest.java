package com.domloge.slinkylinky.linkservice.entity.validator;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.time.LocalDateTime;

import org.junit.jupiter.api.Test;
import org.springframework.validation.BeanPropertyBindingResult;
import org.springframework.validation.Errors;

import com.domloge.slinkylinky.linkservice.entity.Demand;

/**
 * Unit tests for DemandValidator — Rule 12 in linkservice/CLAUDE.md.
 *
 * Note: Demand.setUrl() automatically derives the domain via Util.stripDomain, so url
 * and domain are always set together. A test for "domain missing but url present" would
 * require reflection to bypass the setter; since url and domain are coupled in production
 * code, the "missing url" case covers the scenario where both are absent.
 *
 * Note: DemandValidator previously had a bug where it used lowercase "createdby"/"updatedby"
 * in rejectValue — these were non-functional in Spring 6.x. Fixed in DemandValidator to
 * use camelCase "createdBy"/"updatedBy" to match the bean property names.
 */
public class DemandValidatorTest {

    private final DemandValidator validator = new DemandValidator();

    private Errors validate(Demand d) {
        BeanPropertyBindingResult errors = new BeanPropertyBindingResult(d, "demand");
        validator.validate(d, errors);
        return errors;
    }

    // ─── Happy path ───────────────────────────────────────────────────────────

    @Test
    void validNewDemand_noErrors() {
        assertFalse(validate(validNewDemand()).hasErrors());
    }

    @Test
    void validUpdateDemand_withUpdatedBy_noErrors() {
        Demand d = validNewDemand();
        d.setId(1L);
        d.setUpdatedBy("admin");
        assertFalse(validate(d).hasErrors());
    }

    // ─── requested ───────────────────────────────────────────────────────────

    @Test
    void missingRequested_rejectsRequested() {
        Demand d = validNewDemand();
        d.setRequested(null);
        assertTrue(validate(d).hasFieldErrors("requested"));
    }

    // ─── daNeeded ────────────────────────────────────────────────────────────

    @Test
    void daNeededZero_rejectsDaNeeded() {
        Demand d = validNewDemand();
        d.setDaNeeded(0);
        assertTrue(validate(d).hasFieldErrors("daNeeded"));
    }

    @Test
    void daNeededNegative_rejectsDaNeeded() {
        Demand d = validNewDemand();
        d.setDaNeeded(-1);
        assertTrue(validate(d).hasFieldErrors("daNeeded"));
    }

    // ─── url / domain ────────────────────────────────────────────────────────

    @Test
    void missingUrl_rejectsUrl() {
        // Demand with no url set: both url and domain remain null
        Demand d = new Demand();
        d.setRequested(LocalDateTime.now());
        d.setDaNeeded(20);
        d.setSource("SEO campaign");
        d.setCreatedBy("admin");
        // url deliberately not set → url and domain both null
        assertTrue(validate(d).hasFieldErrors("url"));
    }

    @Test
    void missingUrl_alsoCausesMissingDomain() {
        // Since url drives domain, a missing url leaves domain null too
        Demand d = new Demand();
        d.setRequested(LocalDateTime.now());
        d.setDaNeeded(20);
        d.setSource("SEO campaign");
        d.setCreatedBy("admin");
        assertTrue(validate(d).hasFieldErrors("domain"));
    }

    // ─── source ──────────────────────────────────────────────────────────────

    @Test
    void missingSource_rejectsSource() {
        Demand d = validNewDemand();
        d.setSource(null);
        assertTrue(validate(d).hasFieldErrors("source"));
    }

    // ─── createdBy ───────────────────────────────────────────────────────────

    @Test
    void missingCreatedBy_rejectsCreatedBy() {
        Demand d = validNewDemand();
        d.setCreatedBy(null);
        assertTrue(validate(d).hasFieldErrors("createdBy"));
    }

    // ─── updatedBy (update path) ──────────────────────────────────────────────

    @Test
    void updateDemand_missingUpdatedBy_rejectsUpdatedBy() {
        Demand d = validNewDemand();
        d.setId(1L); // simulate an existing entity (id > 0)
        // updatedBy deliberately not set → validator rejects it
        assertTrue(validate(d).hasFieldErrors("updatedBy"));
    }

    // ─── Helper ───────────────────────────────────────────────────────────────

    private Demand validNewDemand() {
        Demand d = new Demand();
        d.setRequested(LocalDateTime.now());
        d.setDaNeeded(20);
        d.setUrl("https://www.example.com"); // also sets domain = "example.com" via Demand.setUrl
        d.setSource("SEO campaign");
        d.setCreatedBy("admin");
        return d;
    }
}
