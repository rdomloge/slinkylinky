package com.domloge.slinkylinky.supplierengagement.controller;

import java.time.LocalDateTime;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.domloge.slinkylinky.supplierengagement.entity.Engagement;
import com.domloge.slinkylinky.supplierengagement.entity.EngagementStatus;
import com.domloge.slinkylinky.supplierengagement.repo.EngagementRepo;

import lombok.extern.slf4j.Slf4j;

/**
 * Read-only engagement query endpoints used by the dashboard and other admin views.
 *
 * <p>Public-facing engagement mutations (accept/decline) live in {@link UploadController};
 * this controller is for authenticated admin queries only.</p>
 */
@RestController
@RequestMapping("/.rest/engagements")
@Slf4j
public class EngagementSupportController {

    @Autowired
    private EngagementRepo engagementRepo;

    /**
     * Returns engagements that are still within their 2-business-day response window,
     * ordered by {@code supplierEmailSent} ascending so the most urgent appear first.
     *
     * <p>Each item includes a pre-calculated {@code expiresAt} so callers don't need
     * to implement business-day arithmetic themselves.</p>
     */
    @GetMapping("/expiring-soon")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<List<Map<String, Object>>> getExpiringSoon() {
        LocalDateTime twoBusinessDaysAgo = calculateTwoBusinessDaysAgo();
        List<Engagement> active = engagementRepo
                .findByStatusAndSupplierEmailSentAfterOrderBySupplierEmailSentAsc(
                        EngagementStatus.NEW, twoBusinessDaysAgo);

        List<Map<String, Object>> result = active.stream()
                .map(e -> {
                    Map<String, Object> dto = new LinkedHashMap<>();
                    dto.put("id", e.getId());
                    dto.put("supplierName", e.getSupplierName());
                    dto.put("proposalId", e.getProposalId());
                    dto.put("supplierEmailSent",
                            e.getSupplierEmailSent() != null ? e.getSupplierEmailSent().toString() : null);
                    dto.put("expiresAt",
                            e.getSupplierEmailSent() != null ? calculateExpiresAt(e.getSupplierEmailSent()).toString() : null);
                    return dto;
                })
                .collect(Collectors.toList());

        return ResponseEntity.ok(result);
    }

    /** Returns the datetime that is exactly 2 business days (Mon–Fri) before now. */
    private LocalDateTime calculateTwoBusinessDaysAgo() {
        LocalDateTime dt = LocalDateTime.now();
        int businessDays = 0;
        while (businessDays < 2) {
            dt = dt.minusDays(1);
            if (dt.getDayOfWeek().getValue() <= 5) {
                businessDays++;
            }
        }
        return dt;
    }

    /** Returns the datetime 2 business days after {@code sentAt}. */
    private LocalDateTime calculateExpiresAt(LocalDateTime sentAt) {
        LocalDateTime dt = sentAt;
        int businessDays = 0;
        while (businessDays < 2) {
            dt = dt.plusDays(1);
            if (dt.getDayOfWeek().getValue() <= 5) {
                businessDays++;
            }
        }
        return dt;
    }
}
