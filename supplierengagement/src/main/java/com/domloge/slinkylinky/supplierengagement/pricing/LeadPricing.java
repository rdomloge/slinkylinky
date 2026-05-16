package com.domloge.slinkylinky.supplierengagement.pricing;

import java.math.BigDecimal;
import java.math.RoundingMode;

/**
 * Centralised pricing logic for turning a supplier's listed catalogue price into
 * the fee we suggest to them in outreach and use as their {@code weWriteFee} at
 * convert time.
 *
 * <p>Policy: 10% margin (we quote 90% of listed), rounded to the nearest multiple
 * of 5 in the same currency. Returning {@code null} signals "no quote available"
 * — callers decide how to render that (the email shows "contact us"; the convert
 * payload falls back to 0).
 */
public final class LeadPricing {

    private static final BigDecimal DISCOUNT_MULTIPLIER = new BigDecimal("0.9");
    private static final BigDecimal ROUNDING_STEP       = BigDecimal.valueOf(5);

    private LeadPricing() {}

    public static BigDecimal suggestedFee(BigDecimal raw) {
        if (raw == null || raw.signum() <= 0) return null;
        BigDecimal discounted = raw.multiply(DISCOUNT_MULTIPLIER);
        BigDecimal steps      = discounted.divide(ROUNDING_STEP, 0, RoundingMode.HALF_UP);
        return steps.multiply(ROUNDING_STEP).setScale(2, RoundingMode.HALF_UP);
    }
}
