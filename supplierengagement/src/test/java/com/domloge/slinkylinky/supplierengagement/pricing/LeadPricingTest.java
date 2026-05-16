package com.domloge.slinkylinky.supplierengagement.pricing;

import static org.assertj.core.api.Assertions.assertThat;

import java.math.BigDecimal;

import org.junit.jupiter.api.Test;

class LeadPricingTest {

    @Test
    void nullInput_returnsNull() {
        assertThat(LeadPricing.suggestedFee(null)).isNull();
    }

    @Test
    void zero_returnsNull() {
        assertThat(LeadPricing.suggestedFee(BigDecimal.ZERO)).isNull();
    }

    @Test
    void negative_returnsNull() {
        assertThat(LeadPricing.suggestedFee(new BigDecimal("-25.00"))).isNull();
    }

    @Test
    void typicalListing_77pt62_quotes70() {
        // 77.62 * 0.9 = 69.858  →  /5 = 13.9716  →  HALF_UP = 14  →  *5 = 70.00
        assertThat(LeadPricing.suggestedFee(new BigDecimal("77.62")))
            .isEqualByComparingTo(new BigDecimal("70.00"));
    }

    @Test
    void roundHundred_quotes90() {
        assertThat(LeadPricing.suggestedFee(new BigDecimal("100")))
            .isEqualByComparingTo(new BigDecimal("90.00"));
    }

    @Test
    void discountedHitsExact5_22pt50_quotes20() {
        // 22.50 * 0.9 = 20.25  →  /5 = 4.05  →  HALF_UP = 4  →  *5 = 20.00
        assertThat(LeadPricing.suggestedFee(new BigDecimal("22.50")))
            .isEqualByComparingTo(new BigDecimal("20.00"));
    }

    @Test
    void halfwayBoundary_25_quotes25() {
        // 25 * 0.9 = 22.50  →  /5 = 4.5  →  HALF_UP = 5  →  *5 = 25.00
        assertThat(LeadPricing.suggestedFee(new BigDecimal("25")))
            .isEqualByComparingTo(new BigDecimal("25.00"));
    }

    @Test
    void smallValueRoundsUp_3_quotes5() {
        // 3 * 0.9 = 2.7  →  /5 = 0.54  →  HALF_UP = 1  →  *5 = 5.00
        assertThat(LeadPricing.suggestedFee(new BigDecimal("3")))
            .isEqualByComparingTo(new BigDecimal("5.00"));
    }

    @Test
    void verySmallValue_2pt77_quotes0() {
        // 2.77 * 0.9 = 2.493  →  /5 = 0.4986  →  HALF_UP = 0  →  0.00
        // (documented edge case — raws below ~£2.78 round to zero)
        assertThat(LeadPricing.suggestedFee(new BigDecimal("2.77")))
            .isEqualByComparingTo(new BigDecimal("0.00"));
    }

    @Test
    void resultAlwaysHasScale2() {
        assertThat(LeadPricing.suggestedFee(new BigDecimal("77.62")).scale()).isEqualTo(2);
        assertThat(LeadPricing.suggestedFee(new BigDecimal("100")).scale()).isEqualTo(2);
    }
}
