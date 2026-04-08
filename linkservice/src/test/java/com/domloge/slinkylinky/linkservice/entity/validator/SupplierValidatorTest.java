package com.domloge.slinkylinky.linkservice.entity.validator;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.Test;
import org.springframework.validation.BeanPropertyBindingResult;
import org.springframework.validation.Errors;

import com.domloge.slinkylinky.linkservice.entity.Supplier;

/**
 * Unit tests for SupplierValidator — Rule 11 in linkservice/CLAUDE.md.
 *
 * Third-party suppliers bypass most field constraints (only name length >= 2 is enforced).
 * Non-third-party suppliers must satisfy all field rules described in Rule 11.
 */
public class SupplierValidatorTest {

    private final SupplierValidator validator = new SupplierValidator();

    private Errors validate(Supplier s) {
        BeanPropertyBindingResult errors = new BeanPropertyBindingResult(s, "supplier");
        validator.validate(s, errors);
        return errors;
    }

    // ─── Happy path ───────────────────────────────────────────────────────────

    @Test
    void validNonThirdPartySupplier_noErrors() {
        assertFalse(validate(validNonThirdParty()).hasErrors());
    }

    @Test
    void validThirdPartySupplier_noErrors() {
        Supplier s = new Supplier();
        s.setCreatedBy("admin");
        s.setName("3rd Party Blog");
        s.setThirdParty(true);
        // email, website, domain, da, fee deliberately absent — all skipped for third-party
        assertFalse(validate(s).hasErrors());
    }

    // ─── Name ────────────────────────────────────────────────────────────────

    @Test
    void missingName_rejectsName() {
        Supplier s = validNonThirdParty();
        s.setName(null);
        assertTrue(validate(s).hasFieldErrors("name"));
    }

    @Test
    void nameTooShort_rejectsName() {
        Supplier s = validNonThirdParty();
        s.setName("X"); // 1 char, below minimum 2
        assertTrue(validate(s).hasFieldErrors("name"));
    }

    // ─── Email ───────────────────────────────────────────────────────────────

    @Test
    void missingEmail_rejectsEmail() {
        Supplier s = validNonThirdParty();
        s.setEmail(null);
        assertTrue(validate(s).hasFieldErrors("email"));
    }

    @Test
    void emailTooShort_rejectsEmail() {
        Supplier s = validNonThirdParty();
        s.setEmail("a@b"); // 3 chars, below minimum 5
        assertTrue(validate(s).hasFieldErrors("email"));
    }

    // ─── Website / domain ────────────────────────────────────────────────────

    @Test
    void missingWebsite_rejectsWebsite() {
        Supplier s = validNonThirdParty();
        s.setWebsite(null); // Supplier.setWebsite(null) also nulls out domain
        assertTrue(validate(s).hasFieldErrors("website"));
    }

    @Test
    void missingWebsite_alsoRejectsDomain() {
        // setWebsite(null) clears domain too — both fields should be rejected
        Supplier s = validNonThirdParty();
        s.setWebsite(null);
        assertTrue(validate(s).hasFieldErrors("domain"));
    }

    // ─── Domain Authority ────────────────────────────────────────────────────

    @Test
    void daBelowZero_rejectsDa() {
        Supplier s = validNonThirdParty();
        s.setDa(-1);
        assertTrue(validate(s).hasFieldErrors("da"));
    }

    @Test
    void daAbove100_rejectsDa() {
        Supplier s = validNonThirdParty();
        s.setDa(101);
        assertTrue(validate(s).hasFieldErrors("da"));
    }

    @Test
    void daAtZero_isValid() {
        Supplier s = validNonThirdParty();
        s.setDa(0);
        assertFalse(validate(s).hasFieldErrors("da"));
    }

    @Test
    void daAt100_isValid() {
        Supplier s = validNonThirdParty();
        s.setDa(100);
        assertFalse(validate(s).hasFieldErrors("da"));
    }

    // ─── weWriteFee ──────────────────────────────────────────────────────────

    @Test
    void weWriteFeeBelowZero_rejectsWeWriteFee() {
        Supplier s = validNonThirdParty();
        s.setWeWriteFee(-1);
        assertTrue(validate(s).hasFieldErrors("weWriteFee"));
    }

    @Test
    void weWriteFeeAboveMaximum_rejectsWeWriteFee() {
        Supplier s = validNonThirdParty();
        s.setWeWriteFee(1_000_001);
        assertTrue(validate(s).hasFieldErrors("weWriteFee"));
    }

    // ─── weWriteFeeCurrency ──────────────────────────────────────────────────

    @Test
    void missingCurrency_rejectsCurrency() {
        Supplier s = validNonThirdParty();
        s.setWeWriteFeeCurrency(null);
        assertTrue(validate(s).hasFieldErrors("weWriteFeeCurrency"));
    }

    @Test
    void currencyMoreThanOneChar_rejectsCurrency() {
        Supplier s = validNonThirdParty();
        s.setWeWriteFeeCurrency("££");
        assertTrue(validate(s).hasFieldErrors("weWriteFeeCurrency"));
    }

    // ─── Third-party bypass ──────────────────────────────────────────────────

    @Test
    void thirdPartySupplier_emailWebsiteDomainDaFeeNotRequired() {
        Supplier s = new Supplier();
        s.setCreatedBy("admin");
        s.setName("3P Supplier");
        s.setThirdParty(true);
        Errors errors = validate(s);
        assertFalse(errors.hasFieldErrors("email"));
        assertFalse(errors.hasFieldErrors("website"));
        assertFalse(errors.hasFieldErrors("domain"));
        assertFalse(errors.hasFieldErrors("da"));
        assertFalse(errors.hasFieldErrors("weWriteFee"));
        assertFalse(errors.hasFieldErrors("weWriteFeeCurrency"));
    }

    // ─── Helper ───────────────────────────────────────────────────────────────

    private Supplier validNonThirdParty() {
        Supplier s = new Supplier();
        s.setCreatedBy("admin");
        s.setName("Valid Supplier");
        s.setEmail("valid@example.com");
        s.setWebsite("www.example.com"); // Supplier.setWebsite also derives domain via Util.stripDomain
        s.setDa(50);
        s.setWeWriteFee(500);
        s.setWeWriteFeeCurrency("£");
        return s;
    }
}
