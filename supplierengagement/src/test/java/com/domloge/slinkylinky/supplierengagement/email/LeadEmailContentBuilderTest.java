package com.domloge.slinkylinky.supplierengagement.email;

import static org.assertj.core.api.Assertions.assertThat;

import java.math.BigDecimal;

import org.junit.jupiter.api.Test;

class LeadEmailContentBuilderTest {

    private final LeadEmailContentBuilder builder = new LeadEmailContentBuilder();

    @Test
    void calculateSuggestedFee_null_returnsContactUs() {
        assertThat(builder.calculateSuggestedFee(null)).isEqualTo("contact us");
    }

    @Test
    void calculateSuggestedFee_zero_returnsContactUs() {
        // LeadPricing returns null for non-positive inputs → email shows the fallback.
        assertThat(builder.calculateSuggestedFee(BigDecimal.ZERO)).isEqualTo("contact us");
    }

    @Test
    void calculateSuggestedFee_77pt62_returnsCleanInt_70() {
        // 70.00 → stripTrailingZeros().toPlainString() = "70" — no decimals in the email body.
        assertThat(builder.calculateSuggestedFee(new BigDecimal("77.62"))).isEqualTo("70");
    }

    @Test
    void calculateSuggestedFee_25_returns25() {
        assertThat(builder.calculateSuggestedFee(new BigDecimal("25"))).isEqualTo("25");
    }

    @Test
    void calculateSuggestedFee_100_returns90() {
        assertThat(builder.calculateSuggestedFee(new BigDecimal("100"))).isEqualTo("90");
    }
}
