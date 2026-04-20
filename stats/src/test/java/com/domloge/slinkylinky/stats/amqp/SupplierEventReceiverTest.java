package com.domloge.slinkylinky.stats.amqp;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.doReturn;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.util.ReflectionTestUtils;
import org.springframework.web.client.RestTemplate;

import com.domloge.slinkylinky.events.SupplierEvent;
import com.domloge.slinkylinky.stats.moz.DaChecker;
import com.domloge.slinkylinky.stats.moz.SpamChecker;
import com.domloge.slinkylinky.stats.repo.DaRepo;
import com.domloge.slinkylinky.stats.repo.SpamRepo;
import com.domloge.slinkylinky.stats.repo.TrafficRepo;
import com.domloge.slinkylinky.stats.semrush.Semrush;
import com.domloge.slinkylinky.stats.sync.LinkServiceUpdater;
import com.domloge.slinkylinky.stats.sync.Sync;
import com.domloge.slinkylinky.stats.sync.TransientSyncException;

@ExtendWith(MockitoExtension.class)
class SupplierEventReceiverTest {

    @Mock
    private TrafficRepo trafficRepo;

    @Mock
    private DaRepo daRepo;

    @Mock
    private SpamRepo spamRepo;

    @Mock
    private LinkServiceUpdater linkServiceUpdater;

    private RestTemplate restTemplate;
    private Semrush semrush;
    private DaChecker daChecker;
    private SpamChecker spamChecker;
    private Sync sync;
    private SupplierEventReceiver receiver;

    @BeforeEach
    void setUp() {
        restTemplate = mock(RestTemplate.class);
        semrush = new Semrush(restTemplate);
        daChecker = mock(DaChecker.class);
        spamChecker = mock(SpamChecker.class);

        Sync realSync = new Sync(restTemplate);
        ReflectionTestUtils.setField(realSync, "trafficRepo", trafficRepo);
        ReflectionTestUtils.setField(realSync, "daRepo", daRepo);
        ReflectionTestUtils.setField(realSync, "spamRepo", spamRepo);
        ReflectionTestUtils.setField(realSync, "semrush", semrush);
        ReflectionTestUtils.setField(realSync, "daChecker", daChecker);
        ReflectionTestUtils.setField(realSync, "spamChecker", spamChecker);
        ReflectionTestUtils.setField(realSync, "linkServiceUpdater", linkServiceUpdater);
        sync = spy(realSync);

        receiver = new SupplierEventReceiver(restTemplate);
        ReflectionTestUtils.setField(receiver, "sync", sync);
        ReflectionTestUtils.setField(receiver, "trafficRepo", trafficRepo);
        ReflectionTestUtils.setField(receiver, "semrush", semrush);
        ReflectionTestUtils.setField(receiver, "daRepo", daRepo);
        ReflectionTestUtils.setField(receiver, "spamRepo", spamRepo);
        ReflectionTestUtils.setField(receiver, "daChecker", daChecker);
        ReflectionTestUtils.setField(receiver, "spamChecker", spamChecker);
        ReflectionTestUtils.setField(receiver, "linkServiceUpdater", linkServiceUpdater);
    }

    @Test
    void receiveMessage_createdEvent_runsTrafficDaSpamSyncAndPushesDaWhenChanged() throws Exception {
        doReturn(12).doReturn(2).doReturn(1)
            .when(sync).syncSupplier(any(), any(), any(), anyInt());

        receiver.receiveMessage(createdEventJson(SupplierEvent.EventType.CREATED, "example.com", 55L));

        verify(sync).syncSupplier(any(), org.mockito.ArgumentMatchers.same(trafficRepo), any(), org.mockito.ArgumentMatchers.eq(12));
        verify(sync).syncSupplier(any(), org.mockito.ArgumentMatchers.same(daRepo), any(), org.mockito.ArgumentMatchers.eq(1));
        verify(sync).syncSupplier(any(), org.mockito.ArgumentMatchers.same(spamRepo), any(), org.mockito.ArgumentMatchers.eq(1));
        verify(linkServiceUpdater).pushLatestDaToLinkservice(org.mockito.ArgumentMatchers.argThat(supplier ->
            supplier.getId() == 55L && "example.com".equals(supplier.getDomain())));
    }

    @Test
    void receiveMessage_createdEventWithUnchangedDa_skipsPush() throws Exception {
        doReturn(12).doReturn(0).doReturn(1)
            .when(sync).syncSupplier(any(), any(), any(), anyInt());

        receiver.receiveMessage(createdEventJson(SupplierEvent.EventType.CREATED, "steady.example", 77L));

        verify(sync).syncSupplier(any(), org.mockito.ArgumentMatchers.same(trafficRepo), any(), org.mockito.ArgumentMatchers.eq(12));
        verify(sync).syncSupplier(any(), org.mockito.ArgumentMatchers.same(daRepo), any(), org.mockito.ArgumentMatchers.eq(1));
        verify(sync).syncSupplier(any(), org.mockito.ArgumentMatchers.same(spamRepo), any(), org.mockito.ArgumentMatchers.eq(1));
        verify(linkServiceUpdater, never()).pushLatestDaToLinkservice(any());
    }

    @Test
    void receiveMessage_unsupportedEventType_skipsAllSyncWork() {
        receiver.receiveMessage(createdEventJson(SupplierEvent.EventType.DISABLED, "disabled.example", 88L));

        verifyNoInteractions(sync, linkServiceUpdater);
    }

    @Test
    void receiveMessage_invalidJson_skipsAllSyncWork() {
        receiver.receiveMessage("not-json");

        verifyNoInteractions(sync, linkServiceUpdater);
    }

    @Test
    void receiveMessage_transientSyncException_stopsFurtherWorkAndDoesNotPush() throws Exception {
        doReturn(12).doThrow(new TransientSyncException())
            .when(sync).syncSupplier(any(), any(), any(), anyInt());

        receiver.receiveMessage(createdEventJson(SupplierEvent.EventType.CREATED, "flaky.example", 99L));

        verify(sync).syncSupplier(any(), org.mockito.ArgumentMatchers.same(trafficRepo), any(), org.mockito.ArgumentMatchers.eq(12));
        verify(sync).syncSupplier(any(), org.mockito.ArgumentMatchers.same(daRepo), any(), org.mockito.ArgumentMatchers.eq(1));
        verify(sync, never()).syncSupplier(any(), org.mockito.ArgumentMatchers.same(spamRepo), any(), org.mockito.ArgumentMatchers.eq(1));
        verify(linkServiceUpdater, never()).pushLatestDaToLinkservice(any());
    }

    @Test
    void receiveMessage_byteArrayOverload_delegatesToStringPath() {
        SupplierEventReceiver spyReceiver = org.mockito.Mockito.spy(new SupplierEventReceiver(restTemplate));
        doNothing().when(spyReceiver).receiveMessage(org.mockito.ArgumentMatchers.anyString());

        spyReceiver.receiveMessage(createdEventJson(SupplierEvent.EventType.CREATED, "bytes.example", 101L).getBytes(java.nio.charset.StandardCharsets.UTF_8));

        verify(spyReceiver).receiveMessage(createdEventJson(SupplierEvent.EventType.CREATED, "bytes.example", 101L));
    }

    private static String createdEventJson(SupplierEvent.EventType type, String domain, long supplierId) {
        return "{\"type\":\"" + type.name() + "\",\"domain\":\"" + domain + "\",\"supplierId\":" + supplierId + "}";
    }
}
