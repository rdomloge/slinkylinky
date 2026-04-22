package com.domloge.slinkylinky.audit;

import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.time.LocalDateTime;
import java.util.UUID;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentMatchers;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Spy;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.validation.BeanPropertyBindingResult;

import com.domloge.slinkylinky.events.AuditEvent;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

@ExtendWith(MockitoExtension.class)
class AuditEventReceiverTest {

    @Mock
    private AuditRecordRepo repo;

    @Spy
    private AuditValidator validator;

    @InjectMocks
    private AuditEventReceiver receiver;

    @BeforeEach
    void init() {
        receiver.init();
    }

    private ObjectMapper createConfiguredMapper() {
        ObjectMapper mapper = new ObjectMapper();
        mapper.registerModule(new JavaTimeModule());
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        mapper.setSerializationInclusion(Include.NON_NULL);
        return mapper;
    }

    @Test
    void receiveMessage_validJson_savesToRepo() throws Exception {
        AuditEvent ae = createValidAuditEvent(UUID.randomUUID());
        String json = createConfiguredMapper().writeValueAsString(ae);

        receiver.receiveMessage(json);

        verify(repo, times(1)).save(ArgumentMatchers.any(AuditRecord.class));
    }

    @Test
    void receiveMessage_validationErrors_doesNotSave() throws Exception {
        AuditEvent ae = createValidAuditEvent(null);
        ae.setEntityType("Proposal");
        String json = createConfiguredMapper().writeValueAsString(ae);

        receiver.receiveMessage(json);

        verify(repo, never()).save(ArgumentMatchers.any(AuditRecord.class));
    }

    @Test
    void receiveMessage_invalidJson_doesNotSave() {
        String json = "{ invalid json }";

        receiver.receiveMessage(json);

        verify(repo, never()).save(ArgumentMatchers.any(AuditRecord.class));
    }

    @Test
    void receiveMessage_byteArray_utf8_delegatesAndSaves() throws Exception {
        AuditEvent ae = createValidAuditEvent(UUID.randomUUID());
        String json = createConfiguredMapper().writeValueAsString(ae);
        byte[] bytes = json.getBytes("utf-8");

        receiver.receiveMessage(bytes);

        verify(repo, times(1)).save(ArgumentMatchers.any(AuditRecord.class));
    }

    @Test
    void receiveMessage_globalEntityType_nullOrg_savesToRepo() throws Exception {
        AuditEvent ae = createValidAuditEvent(null);
        ae.setEntityType("BlackListedSupplier");
        String json = createConfiguredMapper().writeValueAsString(ae);

        receiver.receiveMessage(json);

        verify(repo, times(1)).save(ArgumentMatchers.any(AuditRecord.class));
    }

    @Test
    void receiveMessage_nonGlobalEntityType_nullOrg_doesNotSave() throws Exception {
        AuditEvent ae = createValidAuditEvent(null);
        ae.setEntityType("Proposal");
        String json = createConfiguredMapper().writeValueAsString(ae);

        receiver.receiveMessage(json);

        verify(repo, never()).save(ArgumentMatchers.any(AuditRecord.class));
    }

    private AuditEvent createValidAuditEvent(UUID orgId) {
        AuditEvent ae = new AuditEvent();
        ae.setWho("testuser");
        ae.setWhat("test action");
        ae.setEventTime(LocalDateTime.now());
        ae.setEntityType("Proposal");
        ae.setDetail("test detail");
        ae.setOrganisationId(orgId);
        return ae;
    }
}
