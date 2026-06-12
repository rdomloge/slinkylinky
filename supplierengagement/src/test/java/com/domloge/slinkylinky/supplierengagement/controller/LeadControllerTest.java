package com.domloge.slinkylinky.supplierengagement.controller;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.entry;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Captor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.test.util.ReflectionTestUtils;

import com.domloge.slinkylinky.events.AuditEvent;
import com.domloge.slinkylinky.supplierengagement.entity.LeadStatus;
import com.domloge.slinkylinky.supplierengagement.entity.SupplierLead;
import com.domloge.slinkylinky.supplierengagement.repo.CollaboratorCategoryMappingRepo;
import com.domloge.slinkylinky.supplierengagement.repo.SupplierLeadRepo;

/**
 * Unit tests for the early-return / gating logic of {@link LeadController}.
 *
 * <p>The happy-path {@code convertToSupplier} flow constructs a
 * {@code CloseableHttpClient} inline and posts to linkservice; that requires a
 * refactor to inject the HTTP client before it's unit-testable. Covered here:
 * the public-endpoint guards ({@code CONVERTED} terminal-state check, 404s,
 * suggestion persistence) and the admin {@code patchCategories} endpoint
 * end-to-end.
 */
@ExtendWith(MockitoExtension.class)
class LeadControllerTest {

    @Mock private SupplierLeadRepo leadRepo;
    @Mock private CollaboratorCategoryMappingRepo mappingRepo;
    @Mock private AmqpTemplate auditRabbitTemplate;

    @Captor private ArgumentCaptor<SupplierLead> leadCaptor;
    @Captor private ArgumentCaptor<AuditEvent> auditCaptor;

    private LeadController controller;

    @BeforeEach
    void setUp() {
        controller = new LeadController();
        ReflectionTestUtils.setField(controller, "leadRepo", leadRepo);
        ReflectionTestUtils.setField(controller, "mappingRepo", mappingRepo);
        ReflectionTestUtils.setField(controller, "auditRabbitTemplate", auditRabbitTemplate);
        ReflectionTestUtils.setField(controller, "linkServiceBase", "http://linkservice.test");
    }

    // ── /accept ───────────────────────────────────────────────────────────────

    @Test
    void accept_unknownGuid_returnsNotFound() throws Exception {
        when(leadRepo.findByGuid("missing")).thenReturn(null);

        ResponseEntity<Void> response = controller.accept("missing", null, null, null, null, null, null);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
        verify(leadRepo, never()).save(any());
        verifyNoInteractions(auditRabbitTemplate);
    }

    @Test
    void accept_convertedLead_returns409_andDoesNotMutate() throws Exception {
        SupplierLead lead = leadAt(LeadStatus.CONVERTED);
        lead.setGuid("converted-guid");
        when(leadRepo.findByGuid("converted-guid")).thenReturn(lead);

        ResponseEntity<Void> response = controller.accept("converted-guid", null, "please remove Tech", null, null, null, null);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.CONFLICT);
        verify(leadRepo, never()).save(any());
        verifyNoInteractions(auditRabbitTemplate);
        // Status untouched; suggestion not written.
        assertThat(lead.getStatus()).isEqualTo(LeadStatus.CONVERTED);
        assertThat(lead.getCategorySuggestion()).isNull();
    }

    @Test
    void accept_newLead_persistsSuggestionAndSetsAccepted() throws Exception {
        SupplierLead lead = leadAt(LeadStatus.OUTREACH_SENT);
        lead.setGuid("g1");
        when(leadRepo.findByGuid("g1")).thenReturn(lead);

        ResponseEntity<Void> response = controller.accept("g1", "https://docs.example.com", "  swap Tech for Health  ", 2,
                new java.math.BigDecimal("40"), "  please link to our sister site too  ", null);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        verify(leadRepo).save(leadCaptor.capture());
        SupplierLead saved = leadCaptor.getValue();
        assertThat(saved.getStatus()).isEqualTo(LeadStatus.ACCEPTED);
        assertThat(saved.getCategorySuggestion()).isEqualTo("swap Tech for Health");
        assertThat(saved.isCategorySuggestionReviewed()).isFalse();
        assertThat(saved.getGoogleDocUrl()).isEqualTo("https://docs.example.com");
        // The supplier's chosen links-permitted value (2) is persisted on the lead.
        assertThat(saved.getLinksPermitted()).isEqualTo(2);
        // The fee the supplier quoted for themselves is stored as the agreed fee.
        assertThat(saved.getAgreedFee()).isEqualByComparingTo(new java.math.BigDecimal("40"));
        // The free-text message is trimmed and stored.
        assertThat(saved.getMessage()).isEqualTo("please link to our sister site too");
        // Audit was emitted ("lead response accepted")
        verify(auditRabbitTemplate).convertAndSend(any(AuditEvent.class));
    }

    @Test
    void accept_blankSuggestion_doesNotOverwrite() throws Exception {
        SupplierLead lead = leadAt(LeadStatus.OUTREACH_SENT);
        lead.setGuid("g2");
        lead.setCategorySuggestion("previous note");
        when(leadRepo.findByGuid("g2")).thenReturn(lead);

        controller.accept("g2", null, "   ", null, null, null, null);

        verify(leadRepo).save(leadCaptor.capture());
        assertThat(leadCaptor.getValue().getCategorySuggestion()).isEqualTo("previous note");
    }

    // ── /decline ──────────────────────────────────────────────────────────────

    @Test
    void decline_unknownGuid_returnsNotFound() {
        when(leadRepo.findByGuid("missing")).thenReturn(null);

        ResponseEntity<Void> response = controller.decline("missing", null);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
        verify(leadRepo, never()).save(any());
        verifyNoInteractions(auditRabbitTemplate);
    }

    @Test
    void decline_convertedLead_returns409() {
        SupplierLead lead = leadAt(LeadStatus.CONVERTED);
        lead.setGuid("c");
        when(leadRepo.findByGuid("c")).thenReturn(lead);

        ResponseEntity<Void> response = controller.decline("c", Map.of("declineReason", "too late"));

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.CONFLICT);
        verify(leadRepo, never()).save(any());
        verifyNoInteractions(auditRabbitTemplate);
        assertThat(lead.getStatus()).isEqualTo(LeadStatus.CONVERTED);
        assertThat(lead.getDeclineReason()).isNull();
    }

    @Test
    void decline_persistsReasonAndSetsDeclined() {
        SupplierLead lead = leadAt(LeadStatus.OUTREACH_SENT);
        lead.setGuid("d");
        when(leadRepo.findByGuid("d")).thenReturn(lead);

        ResponseEntity<Void> response = controller.decline("d", Map.of("declineReason", "not interested"));

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        verify(leadRepo).save(leadCaptor.capture());
        assertThat(leadCaptor.getValue().getStatus()).isEqualTo(LeadStatus.DECLINED);
        assertThat(leadCaptor.getValue().getDeclineReason()).isEqualTo("not interested");
        verify(auditRabbitTemplate).convertAndSend(any(AuditEvent.class));
    }

    // ── PATCH /{id}/categories ────────────────────────────────────────────────

    @Test
    void patchCategories_unknownLead_returnsNotFound() {
        when(leadRepo.findById(99L)).thenReturn(Optional.empty());

        ResponseEntity<SupplierLead> response = controller.patchCategories(99L, Map.of());

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
        verify(leadRepo, never()).save(any());
        verifyNoInteractions(auditRabbitTemplate);
    }

    @Test
    void patchCategories_withIds_setsOverrideMarksReviewedEmitsAudit() {
        SupplierLead lead = leadAt(LeadStatus.ACCEPTED);
        lead.setId(7L);
        lead.setDomain("example.com");
        lead.setCategorySuggestion("please add Cars");
        when(leadRepo.findById(7L)).thenReturn(Optional.of(lead));
        when(leadRepo.save(any(SupplierLead.class))).thenAnswer(inv -> inv.getArgument(0));

        Map<String, Object> body = new HashMap<>();
        body.put("overrideSlCategoryIds", List.of(11, 22, 33));

        ResponseEntity<SupplierLead> response = controller.patchCategories(7L, body);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).isSameAs(lead);
        assertThat(lead.getOverrideSlCategoryIds()).containsExactly(11L, 22L, 33L);
        assertThat(lead.isCategorySuggestionReviewed()).isTrue();
        // Suggestion text is not erased — admin's review is acknowledgement, not deletion.
        assertThat(lead.getCategorySuggestion()).isEqualTo("please add Cars");

        verify(auditRabbitTemplate).convertAndSend(auditCaptor.capture());
        AuditEvent audit = auditCaptor.getValue();
        assertThat(audit.getWhat()).isEqualTo("lead categories overridden");
        assertThat(audit.getEntityType()).isEqualTo("SupplierLead");
        assertThat(audit.getEntityId()).isEqualTo("7");
        assertThat(audit.getDetail()).isEqualTo("11,22,33");
    }

    @Test
    void patchCategories_emptyList_clearsOverrideAndStillMarksReviewed() {
        SupplierLead lead = leadAt(LeadStatus.ACCEPTED);
        lead.setId(8L);
        lead.getOverrideSlCategoryIds().addAll(List.of(11L, 22L));
        lead.setCategorySuggestion("actually never mind, your mapping is fine");
        when(leadRepo.findById(8L)).thenReturn(Optional.of(lead));
        when(leadRepo.save(any(SupplierLead.class))).thenAnswer(inv -> inv.getArgument(0));

        controller.patchCategories(8L, Map.of("overrideSlCategoryIds", List.of()));

        assertThat(lead.getOverrideSlCategoryIds()).isEmpty();
        assertThat(lead.isCategorySuggestionReviewed()).isTrue();
        verify(auditRabbitTemplate).convertAndSend(auditCaptor.capture());
        assertThat(auditCaptor.getValue().getDetail()).isEqualTo("(cleared override)");
    }

    @Test
    void patchCategories_handlesNumericAndStringIds() {
        SupplierLead lead = leadAt(LeadStatus.ACCEPTED);
        lead.setId(9L);
        when(leadRepo.findById(9L)).thenReturn(Optional.of(lead));
        when(leadRepo.save(any(SupplierLead.class))).thenAnswer(inv -> inv.getArgument(0));

        controller.patchCategories(9L, Map.of("overrideSlCategoryIds", List.of(1, "2", 3L)));

        assertThat(lead.getOverrideSlCategoryIds()).containsExactly(1L, 2L, 3L);
    }

    // ── PATCH /{id} (edit details) ──────────────────────────────────────────────

    @Test
    void patchLead_unknownLead_returnsNotFound() {
        when(leadRepo.findById(99L)).thenReturn(Optional.empty());

        ResponseEntity<SupplierLead> response = controller.patchLead(99L, Map.of("price", "60"));

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
        verify(leadRepo, never()).save(any());
    }

    @Test
    void patchLead_updatesEditableParameters() {
        SupplierLead lead = leadAt(LeadStatus.NEW);
        lead.setId(5L);
        lead.setPrice(new java.math.BigDecimal("50"));
        lead.setCurrency("GBP");
        when(leadRepo.findById(5L)).thenReturn(Optional.of(lead));
        when(leadRepo.save(any(SupplierLead.class))).thenAnswer(inv -> inv.getArgument(0));

        Map<String, Object> body = new HashMap<>();
        body.put("price", "120");
        body.put("currency", "USD");
        body.put("countries", "United States");
        body.put("language", "English");

        ResponseEntity<SupplierLead> response = controller.patchLead(5L, body);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(lead.getPrice()).isEqualByComparingTo("120");
        assertThat(lead.getCurrency()).isEqualTo("USD");
        assertThat(lead.getCountries()).isEqualTo("United States");
        assertThat(lead.getLanguage()).isEqualTo("English");
        // SL price is derived from the (now updated) price.
        assertThat(lead.getSuggestedFee()).isEqualByComparingTo("110"); // 120 * 0.9 = 108 → nearest 5 = 110
    }

    @Test
    void patchLead_ignoresUnknownAndMalformedFields() {
        SupplierLead lead = leadAt(LeadStatus.NEW);
        lead.setId(6L);
        lead.setPrice(new java.math.BigDecimal("80"));
        when(leadRepo.findById(6L)).thenReturn(Optional.of(lead));
        when(leadRepo.save(any(SupplierLead.class))).thenAnswer(inv -> inv.getArgument(0));

        Map<String, Object> body = new HashMap<>();
        body.put("price", "not-a-number"); // malformed → left unchanged
        body.put("totallyUnknownKey", "x"); // unknown → ignored

        controller.patchLead(6L, body);

        assertThat(lead.getPrice()).isEqualByComparingTo("80");
    }

    @Test
    void patchLead_emailOnStalledLead_advancesToContactFound() {
        SupplierLead lead = leadAt(LeadStatus.CONTACT_NOT_FOUND);
        lead.setId(10L);
        when(leadRepo.findById(10L)).thenReturn(Optional.of(lead));
        when(leadRepo.save(any(SupplierLead.class))).thenAnswer(inv -> inv.getArgument(0));

        controller.patchLead(10L, Map.of("contactEmail", "hello@example.com"));

        assertThat(lead.getContactEmail()).isEqualTo("hello@example.com");
        assertThat(lead.getStatus()).isEqualTo(LeadStatus.CONTACT_FOUND);
    }

    @Test
    void patchLead_emailCorrectionAfterOutreach_doesNotRewindStatus() {
        SupplierLead lead = leadAt(LeadStatus.OUTREACH_SENT);
        lead.setId(11L);
        lead.setContactEmail("old@example.com");
        when(leadRepo.findById(11L)).thenReturn(Optional.of(lead));
        when(leadRepo.save(any(SupplierLead.class))).thenAnswer(inv -> inv.getArgument(0));

        controller.patchLead(11L, Map.of("contactEmail", "new@example.com"));

        assertThat(lead.getContactEmail()).isEqualTo("new@example.com");
        assertThat(lead.getStatus()).isEqualTo(LeadStatus.OUTREACH_SENT); // not rewound
    }

    // ── /convert ──────────────────────────────────────────────────────────────

    @Test
    void convert_unknownLead_returnsNotFound() {
        when(leadRepo.findById(404L)).thenReturn(Optional.empty());

        ResponseEntity<?> response = controller.convertToSupplier(404L, null);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
        verifyNoInteractions(auditRabbitTemplate);
    }

    @Test
    void convert_unreviewedSuggestion_returns422WithErrorBody() {
        SupplierLead lead = leadAt(LeadStatus.ACCEPTED);
        lead.setId(5L);
        lead.setCategorySuggestion("wrong categories");
        lead.setCategorySuggestionReviewed(false);
        // No categories on the lead → hasPendingMappings is false → we reach the suggestion gate.
        when(leadRepo.findById(5L)).thenReturn(Optional.of(lead));

        ResponseEntity<?> response = controller.convertToSupplier(5L, null);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.UNPROCESSABLE_ENTITY);
        assertThat(response.getBody()).isInstanceOf(Map.class);
        @SuppressWarnings("unchecked")
        Map<String, Object> body = (Map<String, Object>) response.getBody();
        assertThat(body).contains(entry("error", "Lead has an unreviewed category suggestion. Review it before converting."));
        verifyNoInteractions(auditRabbitTemplate);
    }

    @Test
    void convert_reviewedSuggestionDoesNotGate() {
        // If the admin has reviewed the suggestion, the gate must NOT fire — the convert
        // would then proceed to the HTTP call, which we don't reach in this test because
        // we don't supply an Authentication. Verifying it gets past the 422 gate is enough.
        SupplierLead lead = leadAt(LeadStatus.ACCEPTED);
        lead.setId(6L);
        lead.setCategorySuggestion("please add Cars");
        lead.setCategorySuggestionReviewed(true);
        when(leadRepo.findById(6L)).thenReturn(Optional.of(lead));

        // Acting on a null Authentication will throw NPE inside the try block (downstream
        // of all our gates), which becomes a 500/throws — that is fine; the assertion is
        // simply that 422 is NOT returned.
        try {
            ResponseEntity<?> response = controller.convertToSupplier(6L, null);
            assertThat(response.getStatusCode()).isNotEqualTo(HttpStatus.UNPROCESSABLE_ENTITY);
        } catch (Exception ignored) {
            // Reaching the HTTP/auth code path means the gate did not fire — that is the assertion.
        }
    }

    // ── DELETE /{id} (dismiss) + /{id}/undismiss ──────────────────────────────

    @Test
    void dismiss_unknownLead_returnsNotFound() {
        when(leadRepo.findById(404L)).thenReturn(Optional.empty());

        ResponseEntity<Void> response = controller.dismiss(404L);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
        verify(leadRepo, never()).save(any());
        verifyNoInteractions(auditRabbitTemplate);
    }

    @Test
    void dismiss_setsDeletedAtAndEmitsAudit() {
        SupplierLead lead = leadAt(LeadStatus.OUTREACH_SENT);
        lead.setId(3L);
        lead.setDomain("example.com");
        when(leadRepo.findById(3L)).thenReturn(Optional.of(lead));

        ResponseEntity<Void> response = controller.dismiss(3L);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.NO_CONTENT);
        verify(leadRepo).save(leadCaptor.capture());
        // Workflow status is preserved — soft-delete is a separate axis.
        assertThat(leadCaptor.getValue().getStatus()).isEqualTo(LeadStatus.OUTREACH_SENT);
        assertThat(leadCaptor.getValue().getDeletedAt()).isNotNull();

        verify(auditRabbitTemplate).convertAndSend(auditCaptor.capture());
        AuditEvent audit = auditCaptor.getValue();
        assertThat(audit.getWhat()).isEqualTo("lead dismissed");
        assertThat(audit.getEntityType()).isEqualTo("SupplierLead");
        assertThat(audit.getEntityId()).isEqualTo("3");
        assertThat(audit.getDetail()).isEqualTo("example.com");
    }

    @Test
    void dismiss_alreadyDismissed_isNoOp_butStillNoContent() {
        SupplierLead lead = leadAt(LeadStatus.NEW);
        lead.setId(4L);
        lead.setDeletedAt(java.time.LocalDateTime.now().minusDays(1));
        when(leadRepo.findById(4L)).thenReturn(Optional.of(lead));

        ResponseEntity<Void> response = controller.dismiss(4L);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.NO_CONTENT);
        verify(leadRepo, never()).save(any());
        verifyNoInteractions(auditRabbitTemplate);
    }

    @Test
    void undismiss_unknownLead_returnsNotFound() {
        when(leadRepo.findById(404L)).thenReturn(Optional.empty());

        ResponseEntity<SupplierLead> response = controller.undismiss(404L);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
        verify(leadRepo, never()).save(any());
        verifyNoInteractions(auditRabbitTemplate);
    }

    @Test
    void undismiss_clearsDeletedMarkerAndEmitsAudit() {
        SupplierLead lead = leadAt(LeadStatus.NEW);
        lead.setId(5L);
        lead.setDomain("revive.com");
        lead.setDeletedAt(java.time.LocalDateTime.now().minusDays(2));
        lead.setDeletedBy("admin");
        when(leadRepo.findById(5L)).thenReturn(Optional.of(lead));

        ResponseEntity<SupplierLead> response = controller.undismiss(5L);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).isSameAs(lead);
        verify(leadRepo).save(leadCaptor.capture());
        assertThat(leadCaptor.getValue().getDeletedAt()).isNull();
        assertThat(leadCaptor.getValue().getDeletedBy()).isNull();

        verify(auditRabbitTemplate).convertAndSend(auditCaptor.capture());
        assertThat(auditCaptor.getValue().getWhat()).isEqualTo("lead restored");
    }

    @Test
    void undismiss_notDismissed_isNoOp() {
        SupplierLead lead = leadAt(LeadStatus.NEW);
        lead.setId(6L);
        when(leadRepo.findById(6L)).thenReturn(Optional.of(lead));

        ResponseEntity<SupplierLead> response = controller.undismiss(6L);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        verify(leadRepo, never()).save(any());
        verifyNoInteractions(auditRabbitTemplate);
    }

    // ── helpers ───────────────────────────────────────────────────────────────

    private static SupplierLead leadAt(LeadStatus status) {
        SupplierLead lead = new SupplierLead();
        lead.setStatus(status);
        return lead;
    }
}
