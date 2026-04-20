package com.domloge.slinkylinky.woocommerce.sync;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Captor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.util.ReflectionTestUtils;

import com.domloge.slinkylinky.events.ProposalUpdateEvent;
import com.domloge.slinkylinky.events.ProposalUpdateEvent.ProposalEventType;
import com.domloge.slinkylinky.woocommerce.entity.OrderEntity;
import com.domloge.slinkylinky.woocommerce.entity.OrderLineItemEntity;
import com.domloge.slinkylinky.woocommerce.repo.OrderLineItemRepo;
import com.domloge.slinkylinky.woocommerce.repo.OrderRepo;

@ExtendWith(MockitoExtension.class)
class ProposalEventProcessorTest {

    private static final String LINKSERVICE_BASE = "https://linkservice.test";

    @Mock
    private HttpUtils httpUtils;

    @Mock
    private OrderLineItemRepo lineItemRepo;

    @Mock
    private OrderRepo orderRepo;

    @Mock
    private CommercePortalFacade commercePortalFacade;

    @Mock
    private LinkDetailsSender linkDetailsSender;

    @Captor
    private ArgumentCaptor<OrderLineItemEntity> lineItemCaptor;

    @Captor
    private ArgumentCaptor<OrderEntity> orderCaptor;

    private ProposalEventProcessor processor;

    @BeforeEach
    void setUp() {
        processor = new ProposalEventProcessor();
        ReflectionTestUtils.setField(processor, "httpUtils", httpUtils);
        ReflectionTestUtils.setField(processor, "lineItemRepo", lineItemRepo);
        ReflectionTestUtils.setField(processor, "orderRepo", orderRepo);
        ReflectionTestUtils.setField(processor, "commercePortalFacade", commercePortalFacade);
        ReflectionTestUtils.setField(processor, "linkDetailsSender", linkDetailsSender);
        ReflectionTestUtils.setField(processor, "linkService_base", LINKSERVICE_BASE);
    }

    @Test
    void processProposalCreatedEvent_tracksMatchingDemandIdsAndSavesLinkedLineItems() throws Exception {
        ProposalUpdateEvent event = createdEvent(321L);
        OrderLineItemEntity trackedLineItem = lineItem(11L, 101L, false);
        when(httpUtils.get(LINKSERVICE_BASE + "/proposals/321/paidLinks")).thenReturn(paidLinksJson(
            paidLinkJson(9001L, "https://api.test/demands/101{?projection}")));
        when(httpUtils.get("https://api.test/demands/101")).thenReturn(demandJson(101L));
        when(lineItemRepo.findByDemandId(101L)).thenReturn(Optional.of(trackedLineItem));

        processor.processProposalCreatedEvent(event);

        verify(lineItemRepo).save(lineItemCaptor.capture());
        OrderLineItemEntity saved = lineItemCaptor.getValue();
        assertEquals(321L, saved.getLinkedProposalId());
        assertEquals(101L, saved.getDemandId());
    }

    @Test
    void processProposalCreatedEvent_nullPaidLinksResponse_returnsEarly() throws Exception {
        ProposalUpdateEvent event = createdEvent(322L);
        when(httpUtils.get(LINKSERVICE_BASE + "/proposals/322/paidLinks")).thenReturn(null);

        processor.processProposalCreatedEvent(event);

        verify(lineItemRepo, never()).save(org.mockito.ArgumentMatchers.any(OrderLineItemEntity.class));
        verify(orderRepo, never()).findByLineItems_demandIdEquals(org.mockito.ArgumentMatchers.anyLong());
    }

    @Test
    void processProposalCreatedEvent_mixedTrackedAndUntrackedPaidLinks_updatesOnlyTrackedItems() throws Exception {
        ProposalUpdateEvent event = createdEvent(323L);
        OrderLineItemEntity trackedLineItem = lineItem(12L, 201L, false);
        when(httpUtils.get(LINKSERVICE_BASE + "/proposals/323/paidLinks")).thenReturn(paidLinksJson(
            paidLinkJson(9002L, "https://api.test/demands/201{?projection}"),
            paidLinkJson(9003L, "https://api.test/demands/202{?projection}")));
        when(httpUtils.get("https://api.test/demands/201")).thenReturn(demandJson(201L));
        when(httpUtils.get("https://api.test/demands/202")).thenReturn(demandJson(202L));
        when(lineItemRepo.findByDemandId(201L)).thenReturn(Optional.of(trackedLineItem));
        when(lineItemRepo.findByDemandId(202L)).thenReturn(Optional.empty());

        processor.processProposalCreatedEvent(event);

        verify(lineItemRepo).save(lineItemCaptor.capture());
        assertEquals(323L, lineItemCaptor.getValue().getLinkedProposalId());
        verify(lineItemRepo, never()).save(org.mockito.ArgumentMatchers.argThat(li -> li.getDemandId() == 202L));
    }

    @Test
    void processProposalUpdatedEvent_whenNoLinkedLineItems_skipsProposalFetch() throws Exception {
        ProposalUpdateEvent event = updatedEvent(401L);
        when(lineItemRepo.findByLinkedProposalId(401L)).thenReturn(new OrderLineItemEntity[0]);

        processor.processProposalUpdatedEvent(event);

        verify(httpUtils, never()).get(anyString());
        verifyNoInteractions(orderRepo, commercePortalFacade, linkDetailsSender);
    }

    @Test
    void processProposalUpdatedEvent_liveProposalCompletesOrderAndSendsEmailWhenLastItemFinishes() throws Exception {
        ProposalUpdateEvent event = updatedEvent(402L);
        OrderLineItemEntity trackedLineItem = lineItem(21L, 301L, false);
        OrderEntity order = order(77L, 5001L, false, trackedLineItem);
        when(lineItemRepo.findByLinkedProposalId(402L)).thenReturn(new OrderLineItemEntity[] { trackedLineItem });
        when(httpUtils.get(LINKSERVICE_BASE + "/proposals/402")).thenReturn(proposalFlagsJson(true));
        when(orderRepo.findByLineItems_demandIdEquals(301L)).thenReturn(order);
        when(commercePortalFacade.completeOrder(5001L)).thenReturn("completed");

        processor.processProposalUpdatedEvent(event);

        verify(lineItemRepo).save(lineItemCaptor.capture());
        OrderLineItemEntity savedLineItem = lineItemCaptor.getValue();
        assertTrue(savedLineItem.isProposalComplete());

        verify(commercePortalFacade).completeOrder(5001L);
        verify(linkDetailsSender).send(order);
        verify(orderRepo).save(orderCaptor.capture());
        OrderEntity savedOrder = orderCaptor.getValue();
        assertTrue(savedOrder.isLinkDetailsEmailSent());
        assertNotNull(savedOrder.getLinkDetailsEmailSentDate());
    }

    @Test
    void processProposalUpdatedEvent_liveProposalWithRemainingIncompleteItems_doesNotCompleteOrder() throws Exception {
        ProposalUpdateEvent event = updatedEvent(403L);
        OrderLineItemEntity completingLineItem = lineItem(22L, 302L, false);
        OrderLineItemEntity stillIncompleteLineItem = lineItem(23L, 303L, false);
        OrderEntity order = order(78L, 5002L, false, completingLineItem, stillIncompleteLineItem);
        when(lineItemRepo.findByLinkedProposalId(403L)).thenReturn(new OrderLineItemEntity[] { completingLineItem });
        when(httpUtils.get(LINKSERVICE_BASE + "/proposals/403")).thenReturn(proposalFlagsJson(true));
        when(orderRepo.findByLineItems_demandIdEquals(302L)).thenReturn(order);

        processor.processProposalUpdatedEvent(event);

        verify(lineItemRepo).save(lineItemCaptor.capture());
        assertTrue(lineItemCaptor.getValue().isProposalComplete());
        verify(commercePortalFacade, never()).completeOrder(org.mockito.ArgumentMatchers.anyLong());
        verify(linkDetailsSender, never()).send(org.mockito.ArgumentMatchers.any(OrderEntity.class));
        verify(orderRepo, never()).save(org.mockito.ArgumentMatchers.any(OrderEntity.class));
    }

    @Test
    void processProposalUpdatedEvent_liveProposalAlreadyEmailed_skipsDuplicateCompletionAndEmail() throws Exception {
        ProposalUpdateEvent event = updatedEvent(404L);
        OrderLineItemEntity trackedLineItem = lineItem(24L, 304L, false);
        OrderEntity order = order(79L, 5003L, true, trackedLineItem);
        order.setLinkDetailsEmailSentDate(LocalDateTime.now().minusDays(1));
        when(lineItemRepo.findByLinkedProposalId(404L)).thenReturn(new OrderLineItemEntity[] { trackedLineItem });
        when(httpUtils.get(LINKSERVICE_BASE + "/proposals/404")).thenReturn(proposalFlagsJson(true));
        when(orderRepo.findByLineItems_demandIdEquals(304L)).thenReturn(order);

        processor.processProposalUpdatedEvent(event);

        assertFalse(trackedLineItem.isProposalComplete());
        verify(lineItemRepo, never()).save(org.mockito.ArgumentMatchers.any(OrderLineItemEntity.class));
        verify(commercePortalFacade, never()).completeOrder(org.mockito.ArgumentMatchers.anyLong());
        verify(linkDetailsSender, never()).send(org.mockito.ArgumentMatchers.any(OrderEntity.class));
        verify(orderRepo, never()).save(org.mockito.ArgumentMatchers.any(OrderEntity.class));
    }

    @Test
    void processProposalUpdatedEvent_nonLiveProposal_flipsCompleteLineItemBackToIncomplete() throws Exception {
        ProposalUpdateEvent event = updatedEvent(405L);
        OrderLineItemEntity trackedLineItem = lineItem(25L, 305L, true);
        OrderEntity order = order(80L, 5004L, false, trackedLineItem);
        when(lineItemRepo.findByLinkedProposalId(405L)).thenReturn(new OrderLineItemEntity[] { trackedLineItem });
        when(httpUtils.get(LINKSERVICE_BASE + "/proposals/405")).thenReturn(proposalFlagsJson(false));
        when(orderRepo.findByLineItems_demandIdEquals(305L)).thenReturn(order);

        processor.processProposalUpdatedEvent(event);

        verify(lineItemRepo).save(lineItemCaptor.capture());
        assertFalse(lineItemCaptor.getValue().isProposalComplete());
        verify(commercePortalFacade, never()).completeOrder(org.mockito.ArgumentMatchers.anyLong());
        verify(linkDetailsSender, never()).send(org.mockito.ArgumentMatchers.any(OrderEntity.class));
        verify(orderRepo, never()).save(org.mockito.ArgumentMatchers.any(OrderEntity.class));
    }

    @Test
    void processProposalUpdatedEvent_nullProposalLookup_returnsEarly() throws Exception {
        ProposalUpdateEvent event = updatedEvent(406L);
        OrderLineItemEntity trackedLineItem = lineItem(26L, 306L, false);
        when(lineItemRepo.findByLinkedProposalId(406L)).thenReturn(new OrderLineItemEntity[] { trackedLineItem });
        when(httpUtils.get(LINKSERVICE_BASE + "/proposals/406")).thenReturn(null);

        processor.processProposalUpdatedEvent(event);

        verify(orderRepo, never()).findByLineItems_demandIdEquals(org.mockito.ArgumentMatchers.anyLong());
        verify(lineItemRepo, never()).save(org.mockito.ArgumentMatchers.any(OrderLineItemEntity.class));
        verifyNoInteractions(commercePortalFacade, linkDetailsSender);
    }

    private static ProposalUpdateEvent createdEvent(long proposalId) {
        ProposalUpdateEvent event = new ProposalUpdateEvent(ProposalEventType.CREATED);
        event.setProposalDetails("article", proposalId);
        return event;
    }

    private static ProposalUpdateEvent updatedEvent(long proposalId) {
        ProposalUpdateEvent event = new ProposalUpdateEvent(ProposalEventType.UPDATED);
        event.setProposalDetails("article", proposalId);
        return event;
    }

    private static OrderLineItemEntity lineItem(long id, long demandId, boolean proposalComplete) {
        OrderLineItemEntity lineItem = new OrderLineItemEntity();
        lineItem.setId(id);
        lineItem.setDemandId(demandId);
        lineItem.setProposalComplete(proposalComplete);
        lineItem.setLinkedProposalId(999L);
        return lineItem;
    }

    private static OrderEntity order(long id, long externalId, boolean emailSent, OrderLineItemEntity... lineItems) {
        OrderEntity order = new OrderEntity();
        order.setId(id);
        order.setExternalId(externalId);
        order.setLineItems(List.of(lineItems));
        order.setLinkDetailsEmailSent(emailSent);
        order.setCustomerName("Customer");
        order.setBillingEmailAddress("customer@test.example");
        order.setShippingEmailAddress("customer@test.example");
        return order;
    }

    private static String paidLinksJson(String... paidLinks) {
        return "{\"_embedded\":{\"paidlinks\":[" + String.join(",", paidLinks) + "]}}";
    }

    private static String paidLinkJson(long id, String demandHref) {
        return "{\"id\":" + id + ",\"_links\":{\"demand\":{\"href\":\"" + demandHref + "\"}}}";
    }

    private static String demandJson(long id) {
        return "{\"id\":" + id + "}";
    }

    private static String proposalFlagsJson(boolean blogLive) {
        return "{\"blogLive\":" + blogLive + "}";
    }
}
