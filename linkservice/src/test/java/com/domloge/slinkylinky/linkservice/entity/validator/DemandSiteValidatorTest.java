package com.domloge.slinkylinky.linkservice.entity.validator;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.Test;
import org.springframework.validation.BeanPropertyBindingResult;
import org.springframework.validation.Errors;

import com.domloge.slinkylinky.linkservice.entity.Demand;
import com.domloge.slinkylinky.linkservice.entity.DemandSite;

/**
 * Unit tests for DemandSiteValidator.
 *
 * DemandSiteValidator enforces:
 *   1. createdBy must not be null (always required)
 *   2. name must not be null and must have trimmed length >= 3
 *   3. updatedBy must not be null when id > 0 (update path)
 */
public class DemandSiteValidatorTest {

    private final DemandSiteValidator validator = new DemandSiteValidator();

    private Errors validate(DemandSite ds) {
        BeanPropertyBindingResult errors = new BeanPropertyBindingResult(ds, "demandSite");
        validator.validate(ds, errors);
        return errors;
    }

    // ─── supports() ──────────────────────────────────────────────────────────

    @Test
    void supports_DemandClass_returnsTrue() {
        assertTrue(validator.supports(DemandSite.class));
    }

    @Test
    void supports_OtherClass_returnsFalse() {
        assertFalse(validator.supports(Demand.class));
    }

    // ─── Happy path ──────────────────────────────────────────────────────────

    @Test
    void validNewDemandSite_noErrors() {
        assertFalse(validate(validNewDemandSite()).hasErrors());
    }

    @Test
    void validUpdatedDemandSite_noErrors() {
        DemandSite ds = validNewDemandSite();
        ds.setId(1L);
        ds.setUpdatedBy("admin");
        assertFalse(validate(ds).hasErrors());
    }

    // ─── createdBy ───────────────────────────────────────────────────────────

    @Test
    void missingCreatedBy_rejectsCreatedBy() {
        DemandSite ds = validNewDemandSite();
        ds.setCreatedBy(null);
        assertTrue(validate(ds).hasFieldErrors("createdBy"));
    }

    // ─── name ────────────────────────────────────────────────────────────────

    @Test
    void missingName_rejectsName() {
        DemandSite ds = validNewDemandSite();
        ds.setName(null);
        assertTrue(validate(ds).hasFieldErrors("name"));
    }

    @Test
    void nameTooShort_rejectsName() {
        DemandSite ds = validNewDemandSite();
        ds.setName("ab");
        assertTrue(validate(ds).hasFieldErrors("name"));
    }

    @Test
    void nameExactlyThreeChars_noError() {
        DemandSite ds = validNewDemandSite();
        ds.setName("abc");
        assertFalse(validate(ds).hasErrors());
    }

    @Test
    void nameWithPaddingWhitespace_noError() {
        DemandSite ds = validNewDemandSite();
        ds.setName("  abc  ");
        assertFalse(validate(ds).hasErrors());
    }

    @Test
    void nameOnlyWhitespace_rejectsName() {
        DemandSite ds = validNewDemandSite();
        ds.setName("   ");
        assertTrue(validate(ds).hasFieldErrors("name"));
    }

    // ─── updatedBy (update path) ─────────────────────────────────────────────

    @Test
    void updateDemandSite_missingUpdatedBy_rejectsUpdatedBy() {
        DemandSite ds = validNewDemandSite();
        ds.setId(1L); // simulate an existing entity (id > 0)
        // updatedBy deliberately not set → validator rejects it
        assertTrue(validate(ds).hasFieldErrors("updatedBy"));
    }

    @Test
    void newDemandSite_noUpdatedBy_noError() {
        DemandSite ds = validNewDemandSite();
        ds.setId(0L); // id == 0 means new entity
        // updatedBy not required for new entities
        assertFalse(validate(ds).hasErrors());
    }

    @Test
    void updateDemandSite_withUpdatedBy_noError() {
        DemandSite ds = validNewDemandSite();
        ds.setId(1L);
        ds.setUpdatedBy("admin");
        assertFalse(validate(ds).hasErrors());
    }

    @Test
    void updateDemandSite_emptyUpdatedBy_rejectsUpdatedBy() {
        DemandSite ds = validNewDemandSite();
        ds.setId(1L);
        ds.setUpdatedBy(""); // empty string should also be rejected
        assertTrue(validate(ds).hasFieldErrors("updatedBy"));
    }

    // ─── Helper ───────────────────────────────────────────────────────────────

    private DemandSite validNewDemandSite() {
        DemandSite ds = new DemandSite();
        ds.setName("Example Demand Site");
        ds.setCreatedBy("admin");
        return ds;
    }
}
