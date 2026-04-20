package com.domloge.slinkylinky.audit;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.time.LocalDateTime;
import java.util.UUID;

import org.junit.jupiter.api.Test;
import org.springframework.validation.BeanPropertyBindingResult;
import org.springframework.validation.Errors;

class AuditValidatorTest {

    private final AuditValidator validator = new AuditValidator();

    private AuditRecord createValidRecord() {
        AuditRecord ar = new AuditRecord();
        ar.setWho("testuser");
        ar.setWhat("test action");
        ar.setEventTime(LocalDateTime.now());
        ar.setEntityType("Proposal");
        ar.setDetail("test detail");
        ar.setOrganisationId(UUID.randomUUID());
        return ar;
    }

    @Test
    void validate_allFieldsPresent_noErrors() {
        AuditRecord ar = createValidRecord();
        Errors errors = new BeanPropertyBindingResult(ar, "auditRecord");

        validator.validate(ar, errors);

        assertFalse(errors.hasErrors());
    }

    @Test
    void validate_missingOrganisationId_nonGlobalType_rejectsField() {
        AuditRecord ar = createValidRecord();
        ar.setOrganisationId(null);
        ar.setEntityType("Proposal");
        Errors errors = new BeanPropertyBindingResult(ar, "auditRecord");

        validator.validate(ar, errors);

        assertTrue(errors.hasErrors());
        assertTrue(errors.hasFieldErrors("organisationId"));
    }

    @Test
    void validate_missingOrganisationId_blacklistedSupplier_passes() {
        AuditRecord ar = createValidRecord();
        ar.setOrganisationId(null);
        ar.setEntityType("BlackListedSupplier");
        Errors errors = new BeanPropertyBindingResult(ar, "auditRecord");

        validator.validate(ar, errors);

        assertFalse(errors.hasFieldErrors("organisationId"));
    }

    @Test
    void validate_missingOrganisationId_category_passes() {
        AuditRecord ar = createValidRecord();
        ar.setOrganisationId(null);
        ar.setEntityType("Category");
        Errors errors = new BeanPropertyBindingResult(ar, "auditRecord");

        validator.validate(ar, errors);

        assertFalse(errors.hasFieldErrors("organisationId"));
    }

    @Test
    void validate_missingOrganisationId_nullEntityType_rejectsBoth() {
        AuditRecord ar = createValidRecord();
        ar.setOrganisationId(null);
        ar.setEntityType(null);
        Errors errors = new BeanPropertyBindingResult(ar, "auditRecord");

        validator.validate(ar, errors);

        assertTrue(errors.hasErrors());
        assertTrue(errors.hasFieldErrors("entityType"));
        assertTrue(errors.hasFieldErrors("organisationId"));
    }

    @Test
    void validate_missingWho_rejectsField() {
        AuditRecord ar = createValidRecord();
        ar.setWho(null);
        Errors errors = new BeanPropertyBindingResult(ar, "auditRecord");

        validator.validate(ar, errors);

        assertTrue(errors.hasFieldErrors("who"));
    }

    @Test
    void validate_blankWho_rejectsField() {
        AuditRecord ar = createValidRecord();
        ar.setWho("   ");
        Errors errors = new BeanPropertyBindingResult(ar, "auditRecord");

        validator.validate(ar, errors);

        assertTrue(errors.hasFieldErrors("who"));
    }

    @Test
    void validate_missingEventTime_rejectsField() {
        AuditRecord ar = createValidRecord();
        ar.setEventTime(null);
        Errors errors = new BeanPropertyBindingResult(ar, "auditRecord");

        validator.validate(ar, errors);

        assertTrue(errors.hasFieldErrors("eventTime"));
    }

    @Test
    void validate_missingWhat_rejectsField() {
        AuditRecord ar = createValidRecord();
        ar.setWhat(null);
        Errors errors = new BeanPropertyBindingResult(ar, "auditRecord");

        validator.validate(ar, errors);

        assertTrue(errors.hasFieldErrors("what"));
    }

    @Test
    void validate_missingDetail_rejectsField() {
        AuditRecord ar = createValidRecord();
        ar.setDetail(null);
        Errors errors = new BeanPropertyBindingResult(ar, "auditRecord");

        validator.validate(ar, errors);

        assertTrue(errors.hasFieldErrors("detail"));
    }
}
