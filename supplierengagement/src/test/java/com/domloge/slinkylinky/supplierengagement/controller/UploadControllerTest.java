package com.domloge.slinkylinky.supplierengagement.controller;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.Mockito.doReturn;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

import java.io.IOException;
import java.util.List;
import java.util.Properties;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Captor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.test.util.ReflectionTestUtils;
import org.springframework.web.client.RestTemplate;

import com.domloge.slinkylinky.events.AuditEvent;
import com.domloge.slinkylinky.events.SupplierEngagementEvent;
import com.domloge.slinkylinky.supplierengagement.email.ContentBuilder;
import com.domloge.slinkylinky.supplierengagement.email.EmailBuilder;
import com.domloge.slinkylinky.supplierengagement.email.EmailSender;
import com.domloge.slinkylinky.supplierengagement.email.HttpUtils;
import com.domloge.slinkylinky.supplierengagement.entity.Engagement;
import com.domloge.slinkylinky.supplierengagement.entity.EngagementStatus;
import com.domloge.slinkylinky.supplierengagement.repo.EngagementRepo;

import jakarta.mail.MessagingException;
import jakarta.mail.Session;
import jakarta.mail.internet.MimeMessage;

@ExtendWith(MockitoExtension.class)
class UploadControllerTest {

    private static final String LINKSERVICE_BASE = "https://linkservice.test";

    @Mock
    private EngagementRepo engagementRepo;

    @Mock
    private AmqpTemplate auditRabbitTemplate;

    @Mock
    private EmailBuilder emailBuilder;

    @Mock
    private EmailSender emailSender;

    @Mock
    private ContentBuilder contentBuilder;

    @Mock
    private HttpUtils httpUtils;

    @Mock
    private RestTemplate restTemplate;

    @Captor
    private ArgumentCaptor<Engagement> engagementCaptor;

    @Captor
    private ArgumentCaptor<AuditEvent> auditCaptor;

    @Captor
    private ArgumentCaptor<HttpEntity<?>> httpEntityCaptor;

    private UploadController controller;

    @BeforeEach
    void setUp() {
        controller = new UploadController();
        ReflectionTestUtils.setField(controller, "engagementRepo", engagementRepo);
        ReflectionTestUtils.setField(controller, "auditRabbitTemplate", auditRabbitTemplate);
        ReflectionTestUtils.setField(controller, "emailBuilder", emailBuilder);
        ReflectionTestUtils.setField(controller, "emailSender", emailSender);
        ReflectionTestUtils.setField(controller, "contentBuilder", contentBuilder);
        ReflectionTestUtils.setField(controller, "httpUtils", httpUtils);
        ReflectionTestUtils.setField(controller, "restTemplate", restTemplate);
        ReflectionTestUtils.setField(controller, "linkService_base", LINKSERVICE_BASE);
    }

    @Test
    void decline_unknownGuid_returnsNotFoundWithoutSideEffects() throws Exception {
        when(engagementRepo.findByGuid("missing-guid")).thenReturn(null);

        ResponseEntity<Object> response = controller.decline("missing-guid", declineRequest("reason", true));

        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
        verify(engagementRepo, never()).save(any(Engagement.class));
        verifyNoInteractions(auditRabbitTemplate, emailBuilder, emailSender, contentBuilder, httpUtils, restTemplate);
    }

    @Test
    void decline_success_updatesStatePublishesAuditsSendsEmailAndPostsEvent() throws Exception {
        Engagement dbEngagement = existingEngagement(42L, 9001L, "known-guid");
        MimeMessage message = mimeMessage();
        when(engagementRepo.findByGuid("known-guid")).thenReturn(dbEngagement);
        when(contentBuilder.buildForDecline(any())).thenReturn("decline-content");
        when(emailBuilder.buildSupplierDeclinedMessage(dbEngagement, "decline-content")).thenReturn(message);
        when(httpUtils.fetchAccessToken()).thenReturn("token-123");
        doReturn(ResponseEntity.ok().build())
            .when(restTemplate).postForEntity(anyString(), any(HttpEntity.class), isNull());

        ResponseEntity<Object> response = controller.decline("known-guid", declineRequest("too expensive", true));

        assertEquals(HttpStatus.OK, response.getStatusCode());

        verify(engagementRepo).save(engagementCaptor.capture());
        Engagement saved = engagementCaptor.getValue();
        assertEquals(EngagementStatus.DECLINED, saved.getStatus());
        assertEquals("too expensive", saved.getDeclinedReason());
        assertTrue(saved.isDoNotContact());

        verify(auditRabbitTemplate, org.mockito.Mockito.times(2)).convertAndSend(auditCaptor.capture());
        List<AuditEvent> audits = auditCaptor.getAllValues();
        assertEquals("Proposal declined by supplier", audits.get(0).getWhat());
        assertEquals("DNC: true // Reason: too expensive", audits.get(0).getDetail());
        assertEquals("Supplier-declined warning email sent", audits.get(1).getWhat());
        assertEquals("decline-content", audits.get(1).getDetail());

        verify(emailSender).send(message, 9001L);
        verify(httpUtils).fetchAccessToken();
        verify(restTemplate).postForEntity(anyString(), httpEntityCaptor.capture(), isNull());
        HttpEntity<?> request = httpEntityCaptor.getValue();
        assertEquals("Bearer token-123", request.getHeaders().getFirst("Authorization"));
        SupplierEngagementEvent event = (SupplierEngagementEvent) request.getBody();
        assertNotNull(event);
        assertEquals(SupplierEngagementEvent.EventType.RECEIVED_RESPONSE, event.getType());
        assertEquals(SupplierEngagementEvent.Response.DECLINED, event.getResponse());
        assertEquals(9001L, event.getProposalId());
        assertEquals("too expensive", event.getReason());
        assertTrue(event.isDoNotContact());
    }

    @Test
    void decline_downstreamError_throwsIOExceptionAfterLocalWork() throws Exception {
        Engagement dbEngagement = existingEngagement(7L, 7007L, "error-guid");
        MimeMessage message = mimeMessage();
        when(engagementRepo.findByGuid("error-guid")).thenReturn(dbEngagement);
        when(contentBuilder.buildForDecline(any())).thenReturn("decline-content");
        when(emailBuilder.buildSupplierDeclinedMessage(dbEngagement, "decline-content")).thenReturn(message);
        when(httpUtils.fetchAccessToken()).thenReturn("token-456");
        doReturn(ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build())
            .when(restTemplate).postForEntity(anyString(), any(HttpEntity.class), isNull());

        IOException ex = assertThrows(IOException.class,
            () -> controller.decline("error-guid", declineRequest("not interested", false)));

        assertTrue(ex.getMessage().contains("Failed to send event to linkservice"));
        verify(engagementRepo).save(any(Engagement.class));
        verify(auditRabbitTemplate, org.mockito.Mockito.times(2)).convertAndSend(any(AuditEvent.class));
        verify(emailSender).send(message, 7007L);
        verify(restTemplate).postForEntity(anyString(), any(HttpEntity.class), isNull());
    }

    @Test
    void decline_emailBuilderMessagingException_isSwallowedAndRequestStillPosts() throws Exception {
        Engagement dbEngagement = existingEngagement(8L, 8008L, "mail-guid");
        when(engagementRepo.findByGuid("mail-guid")).thenReturn(dbEngagement);
        when(contentBuilder.buildForDecline(any())).thenReturn("decline-content");
        when(emailBuilder.buildSupplierDeclinedMessage(dbEngagement, "decline-content"))
            .thenThrow(new MessagingException("boom"));
        when(httpUtils.fetchAccessToken()).thenReturn("token-789");
        doReturn(ResponseEntity.ok().build())
            .when(restTemplate).postForEntity(anyString(), any(HttpEntity.class), isNull());

        ResponseEntity<Object> response = controller.decline("mail-guid", declineRequest("bad timing", false));

        assertEquals(HttpStatus.OK, response.getStatusCode());
        verify(auditRabbitTemplate).convertAndSend(auditCaptor.capture());
        assertEquals("Proposal declined by supplier", auditCaptor.getValue().getWhat());
        verify(emailSender, never()).send(any(MimeMessage.class), anyLong());
        verify(restTemplate).postForEntity(anyString(), any(HttpEntity.class), isNull());
    }

    @Test
    void accept_unknownGuid_returnsNotFoundWithoutSideEffects() throws Exception {
        when(engagementRepo.findByGuid("missing-guid")).thenReturn(null);

        ResponseEntity<Object> response = controller.update("missing-guid", acceptRequest("Blog title", "https://blog.test/post", "https://invoice.test/1"));

        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
        verify(engagementRepo, never()).save(any(Engagement.class));
        verifyNoInteractions(auditRabbitTemplate, httpUtils, restTemplate, emailBuilder, emailSender, contentBuilder);
    }

    @Test
    void accept_success_updatesStateAuditsAndPostsAcceptEvent() throws Exception {
        Engagement dbEngagement = existingEngagement(21L, 2121L, "accept-guid");
        when(engagementRepo.findByGuid("accept-guid")).thenReturn(dbEngagement);
        when(httpUtils.fetchAccessToken()).thenReturn("accept-token");
        doReturn(ResponseEntity.ok().build())
            .when(restTemplate).postForEntity(anyString(), any(HttpEntity.class), isNull());

        ResponseEntity<Object> response = controller.update("accept-guid",
            acceptRequest("My Blog", "https://blog.test/accepted", "https://invoice.test/accepted"));

        assertEquals(HttpStatus.OK, response.getStatusCode());
        verify(engagementRepo).save(engagementCaptor.capture());
        Engagement saved = engagementCaptor.getValue();
        assertEquals(EngagementStatus.ACCEPTED, saved.getStatus());
        assertEquals("My Blog", saved.getBlogTitle());
        assertEquals("https://blog.test/accepted", saved.getBlogUrl());
        assertEquals("https://invoice.test/accepted", saved.getInvoiceUrl());

        verify(auditRabbitTemplate).convertAndSend(auditCaptor.capture());
        AuditEvent audit = auditCaptor.getValue();
        assertEquals("Proposal accepted by supplier", audit.getWhat());
        assertEquals("Blog title: My Blog, Blog URL: https://blog.test/accepted", audit.getDetail());

        verify(restTemplate).postForEntity(anyString(), httpEntityCaptor.capture(), isNull());
        HttpEntity<?> request = httpEntityCaptor.getValue();
        assertEquals("Bearer accept-token", request.getHeaders().getFirst("Authorization"));
        SupplierEngagementEvent event = (SupplierEngagementEvent) request.getBody();
        assertNotNull(event);
        assertEquals(SupplierEngagementEvent.EventType.RECEIVED_RESPONSE, event.getType());
        assertEquals(SupplierEngagementEvent.Response.ACCEPTED, event.getResponse());
        assertEquals(2121L, event.getProposalId());
        assertEquals("My Blog", event.getBlogTitle());
        assertEquals("https://blog.test/accepted", event.getBlogUrl());
    }

    @Test
    void accept_downstreamError_throwsIOExceptionAfterPersistenceAndAudit() throws Exception {
        Engagement dbEngagement = existingEngagement(33L, 3333L, "accept-error-guid");
        when(engagementRepo.findByGuid("accept-error-guid")).thenReturn(dbEngagement);
        when(httpUtils.fetchAccessToken()).thenReturn("accept-token");
        doReturn(ResponseEntity.status(HttpStatus.BAD_GATEWAY).build())
            .when(restTemplate).postForEntity(anyString(), any(HttpEntity.class), isNull());

        IOException ex = assertThrows(IOException.class,
            () -> controller.update("accept-error-guid",
                acceptRequest("Pending Blog", "https://blog.test/pending", "https://invoice.test/pending")));

        assertTrue(ex.getMessage().contains("Failed to send event to linkservice"));
        verify(engagementRepo).save(any(Engagement.class));
        verify(auditRabbitTemplate).convertAndSend(any(AuditEvent.class));
        verify(restTemplate).postForEntity(anyString(), any(HttpEntity.class), isNull());
    }

    private static Engagement existingEngagement(long id, long proposalId, String guid) {
        Engagement engagement = new Engagement();
        engagement.setId(id);
        engagement.setProposalId(proposalId);
        engagement.setGuid(guid);
        engagement.setSupplierName("Supplier Name");
        engagement.setSupplierWebsite("supplier.test");
        engagement.setStatus(EngagementStatus.NEW);
        return engagement;
    }

    private static Engagement declineRequest(String reason, boolean doNotContact) {
        Engagement engagement = new Engagement();
        engagement.setDeclinedReason(reason);
        engagement.setDoNotContact(doNotContact);
        return engagement;
    }

    private static Engagement acceptRequest(String blogTitle, String blogUrl, String invoiceUrl) {
        Engagement engagement = new Engagement();
        engagement.setBlogTitle(blogTitle);
        engagement.setBlogUrl(blogUrl);
        engagement.setInvoiceUrl(invoiceUrl);
        return engagement;
    }

    private static MimeMessage mimeMessage() {
        return new MimeMessage(Session.getInstance(new Properties()));
    }
}
