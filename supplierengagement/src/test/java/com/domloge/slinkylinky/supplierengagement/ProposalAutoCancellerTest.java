package com.domloge.slinkylinky.supplierengagement;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.argThat;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Properties;
import java.util.function.Consumer;
import java.util.stream.Stream;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;
import org.mockito.ArgumentCaptor;
import org.mockito.Captor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.test.util.ReflectionTestUtils;

import com.domloge.slinkylinky.events.AuditEvent;
import com.domloge.slinkylinky.supplierengagement.email.ContentBuilder;
import com.domloge.slinkylinky.supplierengagement.email.EmailBuilder;
import com.domloge.slinkylinky.supplierengagement.email.EmailSender;
import com.domloge.slinkylinky.supplierengagement.email.HttpUtils;
import com.domloge.slinkylinky.supplierengagement.email.Proposal;
import com.domloge.slinkylinky.supplierengagement.entity.Engagement;
import com.domloge.slinkylinky.supplierengagement.entity.EngagementStatus;
import com.domloge.slinkylinky.supplierengagement.repo.EngagementRepo;

import jakarta.mail.MessagingException;
import jakarta.mail.Session;
import jakarta.mail.internet.MimeMessage;

@ExtendWith(MockitoExtension.class)
class ProposalAutoCancellerTest {

    @Mock
    private EngagementRepo engagementRepo;

    @Mock
    private EmailSender emailSender;

    @Mock
    private EmailBuilder emailBuilder;

    @Mock
    private ContentBuilder contentBuilder;

    @Mock
    private HttpUtils httpUtils;

    @Mock
    private AmqpTemplate auditRabbitTemplate;

    @Captor
    private ArgumentCaptor<Engagement> engagementCaptor;

    @Captor
    private ArgumentCaptor<AuditEvent> auditCaptor;

    private ProposalAutoCanceller canceller;

    @BeforeEach
    void setUp() {
        canceller = new ProposalAutoCanceller();
        ReflectionTestUtils.setField(canceller, "engagementRepo", engagementRepo);
        ReflectionTestUtils.setField(canceller, "emailSender", emailSender);
        ReflectionTestUtils.setField(canceller, "emailBuilder", emailBuilder);
        ReflectionTestUtils.setField(canceller, "contentBuilder", contentBuilder);
        ReflectionTestUtils.setField(canceller, "httpUtils", httpUtils);
        ReflectionTestUtils.setField(canceller, "auditRabbitTemplate", auditRabbitTemplate);
    }

    @Test
    void findExpiredProposals_happyPath_expiresAuditsAbortsAndEmails() throws Exception {
        Engagement engagement = expiredEngagement(10L, 501L);
        Proposal proposal = proposal();
        MimeMessage message = mimeMessage();
        when(engagementRepo.findByStatusAndSupplierEmailSentBefore(any(), any()))
            .thenReturn(new Engagement[] { engagement });
        when(httpUtils.loadProposal(501L)).thenReturn(proposal);
        when(contentBuilder.buildEngagementExpiredContent(engagement, proposal)).thenReturn("expired-content");
        when(emailBuilder.buildEngagementExpiredMessage(engagement, "expired-content")).thenReturn(message);

        canceller.findExpiredProposals();

        verify(engagementRepo).findByStatusAndSupplierEmailSentBefore(
            org.mockito.ArgumentMatchers.eq(EngagementStatus.NEW),
            argThat(timestamp -> timestamp != null && timestamp.isBefore(LocalDateTime.now())));
        verify(engagementRepo).save(engagementCaptor.capture());
        Engagement saved = engagementCaptor.getValue();
        assertEquals(EngagementStatus.EXPIRED, saved.getStatus());

        verify(auditRabbitTemplate).convertAndSend(auditCaptor.capture());
        AuditEvent audit = auditCaptor.getValue();
        assertEquals("501", audit.getEntityId());
        assertEquals("Engagement expired", audit.getWhat());
        assertTrue(audit.getDetail().contains("expired for proposal 501"));
        assertNotNull(audit.getEventTime());

        verify(httpUtils).abortProposal(501L);
        verify(emailSender).send(message, 501L);
    }

    @Test
    void findExpiredProposals_missingProposal_skipsAbortAndEmail() throws Exception {
        Engagement engagement = expiredEngagement(11L, 601L);
        when(engagementRepo.findByStatusAndSupplierEmailSentBefore(any(), any()))
            .thenReturn(new Engagement[] { engagement });
        when(httpUtils.loadProposal(601L)).thenReturn(null);

        canceller.findExpiredProposals();

        verify(engagementRepo).save(engagementCaptor.capture());
        assertEquals(EngagementStatus.EXPIRED, engagementCaptor.getValue().getStatus());
        verify(auditRabbitTemplate).convertAndSend(any(AuditEvent.class));
        verify(httpUtils, never()).abortProposal(anyLong());
        verify(contentBuilder, never()).buildEngagementExpiredContent(any(), any());
        verify(emailBuilder, never()).buildEngagementExpiredMessage(any(), any());
        verify(emailSender, never()).send(any(MimeMessage.class), anyLong());
    }

    @Test
    void findExpiredProposals_doNotExpire_skipsAbortAndEmail() throws Exception {
        Engagement engagement = expiredEngagement(12L, 701L);
        Proposal proposal = proposal();
        proposal.setDoNotExpire(true);
        when(engagementRepo.findByStatusAndSupplierEmailSentBefore(any(), any()))
            .thenReturn(new Engagement[] { engagement });
        when(httpUtils.loadProposal(701L)).thenReturn(proposal);

        canceller.findExpiredProposals();

        verify(engagementRepo).save(any(Engagement.class));
        verify(auditRabbitTemplate).convertAndSend(any(AuditEvent.class));
        verify(httpUtils, never()).abortProposal(anyLong());
        verify(emailBuilder, never()).buildEngagementExpiredMessage(any(), any());
        verify(emailSender, never()).send(any(MimeMessage.class), anyLong());
    }

    @ParameterizedTest(name = "invalid proposal state {0} skips abort and email")
    @MethodSource("invalidProposalStates")
    void findExpiredProposals_invalidProposalStates_skipAbortAndEmail(String name, Consumer<Proposal> mutator)
            throws Exception {
        Engagement engagement = expiredEngagement(13L, 801L);
        Proposal proposal = proposal();
        mutator.accept(proposal);
        when(engagementRepo.findByStatusAndSupplierEmailSentBefore(any(), any()))
            .thenReturn(new Engagement[] { engagement });
        when(httpUtils.loadProposal(801L)).thenReturn(proposal);

        canceller.findExpiredProposals();

        verify(engagementRepo).save(any(Engagement.class));
        verify(auditRabbitTemplate).convertAndSend(any(AuditEvent.class));
        verify(httpUtils, never()).abortProposal(anyLong());
        verify(emailBuilder, never()).buildEngagementExpiredMessage(any(), any());
        verify(emailSender, never()).send(any(MimeMessage.class), anyLong());
    }

    @Test
    void findExpiredProposals_abortIOException_isSwallowedAndLaterEngagementStillProcesses() throws Exception {
        Engagement first = expiredEngagement(14L, 901L);
        Engagement second = expiredEngagement(15L, 902L);
        Proposal proposal = proposal();
        MimeMessage message = mimeMessage();
        when(engagementRepo.findByStatusAndSupplierEmailSentBefore(any(), any()))
            .thenReturn(new Engagement[] { first, second });
        when(httpUtils.loadProposal(901L)).thenReturn(proposal);
        when(httpUtils.loadProposal(902L)).thenReturn(proposal);
        doThrow(new IOException("boom")).when(httpUtils).abortProposal(901L);
        doNothing().when(httpUtils).abortProposal(902L);
        when(contentBuilder.buildEngagementExpiredContent(any(Engagement.class), any(Proposal.class))).thenReturn("expired-content");
        when(emailBuilder.buildEngagementExpiredMessage(any(Engagement.class), org.mockito.ArgumentMatchers.eq("expired-content")))
            .thenReturn(message);

        assertDoesNotThrow(() -> canceller.findExpiredProposals());

        verify(httpUtils).abortProposal(901L);
        verify(httpUtils).abortProposal(902L);
        verify(emailSender).send(message, 902L);
    }

    @Test
    void findExpiredProposals_emailMessagingException_isSwallowed() throws Exception {
        Engagement engagement = expiredEngagement(16L, 1001L);
        Proposal proposal = proposal();
        MimeMessage message = mimeMessage();
        when(engagementRepo.findByStatusAndSupplierEmailSentBefore(any(), any()))
            .thenReturn(new Engagement[] { engagement });
        when(httpUtils.loadProposal(1001L)).thenReturn(proposal);
        when(contentBuilder.buildEngagementExpiredContent(engagement, proposal)).thenReturn("expired-content");
        when(emailBuilder.buildEngagementExpiredMessage(engagement, "expired-content")).thenReturn(message);
        doThrow(new MessagingException("send failed")).when(emailSender).send(message, 1001L);

        assertDoesNotThrow(() -> canceller.findExpiredProposals());

        verify(httpUtils).abortProposal(1001L);
        verify(emailSender).send(message, 1001L);
    }

    private static Stream<Arguments> invalidProposalStates() {
        return Stream.of(
            Arguments.of("proposalAccepted", (Consumer<Proposal>) proposal -> proposal.setProposalAccepted(true)),
            Arguments.of("blogLive", (Consumer<Proposal>) proposal -> proposal.setBlogLive(true)),
            Arguments.of("invoiceReceived", (Consumer<Proposal>) proposal -> proposal.setInvoiceReceived(true)),
            Arguments.of("invoicePaid", (Consumer<Proposal>) proposal -> proposal.setInvoicePaid(true))
        );
    }

    private static Engagement expiredEngagement(long id, long proposalId) {
        Engagement engagement = new Engagement();
        engagement.setId(id);
        engagement.setProposalId(proposalId);
        engagement.setGuid("guid-" + proposalId);
        engagement.setSupplierName("Supplier " + proposalId);
        engagement.setSupplierWebsite("supplier" + proposalId + ".test");
        engagement.setSupplierEmailSent(LocalDateTime.now().minusDays(3));
        engagement.setStatus(EngagementStatus.NEW);
        return engagement;
    }

    private static Proposal proposal() {
        Proposal proposal = new Proposal();
        proposal.setId(1L);
        proposal.setPaidLinks(java.util.List.of());
        return proposal;
    }

    private static MimeMessage mimeMessage() {
        return new MimeMessage(Session.getInstance(new Properties()));
    }
}
