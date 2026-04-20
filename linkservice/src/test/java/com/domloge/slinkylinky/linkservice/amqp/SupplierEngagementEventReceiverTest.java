package com.domloge.slinkylinky.linkservice.amqp;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.util.Optional;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Captor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.util.ReflectionTestUtils;

import com.domloge.slinkylinky.events.SupplierEngagementEvent;
import com.domloge.slinkylinky.linkservice.entity.Proposal;
import com.domloge.slinkylinky.linkservice.repo.ProposalRepo;

@ExtendWith(MockitoExtension.class)
class SupplierEngagementEventReceiverTest {

    @Mock
    private ProposalRepo proposalRepo;

    @Captor
    private ArgumentCaptor<Proposal> proposalCaptor;

    private SupplierEngagementEventReceiver receiver;

    @BeforeEach
    void setUp() {
        receiver = new SupplierEngagementEventReceiver();
        ReflectionTestUtils.setField(receiver, "proposalRepo", proposalRepo);
    }

    @Test
    void receiveMessage_proposalSent_marksProposalAndPersistsTimestamp() {
        Proposal proposal = new Proposal();
        proposal.setId(44L);
        proposal.setProposalSent(false);
        proposal.setDateSentToSupplier(null);
        when(proposalRepo.findById(44L)).thenReturn(Optional.of(proposal));

        receiver.receiveMessage(sentEventJson(44L));

        verify(proposalRepo).save(proposalCaptor.capture());
        Proposal saved = proposalCaptor.getValue();
        assertTrue(saved.isProposalSent());
        assertNotNull(saved.getDateSentToSupplier());
    }

    @Test
    void receiveMessage_missingProposal_returnsWithoutSaving() {
        when(proposalRepo.findById(45L)).thenReturn(Optional.empty());

        receiver.receiveMessage(sentEventJson(45L));

        verify(proposalRepo, never()).save(org.mockito.ArgumentMatchers.any(Proposal.class));
    }

    @Test
    void receiveMessage_unsupportedEventType_leavesProposalUnchanged() {
        Proposal proposal = new Proposal();
        proposal.setId(46L);
        proposal.setProposalSent(false);
        proposal.setDateSentToSupplier(LocalDateTime.now().minusDays(1));
        when(proposalRepo.findById(46L)).thenReturn(Optional.of(proposal));

        receiver.receiveMessage(acceptedResponseEventJson(46L));

        assertFalse(proposal.isProposalSent());
        verify(proposalRepo, never()).save(org.mockito.ArgumentMatchers.any(Proposal.class));
    }

    @Test
    void receiveMessage_invalidJson_doesNotHitRepository() {
        receiver.receiveMessage("not-json");

        verifyNoInteractions(proposalRepo);
    }

    @Test
    void receiveMessage_byteArrayOverload_delegatesToStringPath() {
        SupplierEngagementEventReceiver spyReceiver = org.mockito.Mockito.spy(new SupplierEngagementEventReceiver());
        doNothing().when(spyReceiver).receiveMessage(org.mockito.ArgumentMatchers.anyString());

        spyReceiver.receiveMessage(sentEventJson(47L).getBytes(StandardCharsets.UTF_8));

        verify(spyReceiver).receiveMessage(sentEventJson(47L));
    }

    private static String sentEventJson(long proposalId) {
        return "{\"proposalId\":" + proposalId + ",\"type\":\"PROPOSAL_SENT\"}";
    }

    private static String acceptedResponseEventJson(long proposalId) {
        return "{\"proposalId\":" + proposalId
            + ",\"response\":\"ACCEPTED\",\"blogTitle\":\"Blog\",\"blogUrl\":\"https://blog.test/post\",\"type\":\"RECEIVED_RESPONSE\"}";
    }
}
