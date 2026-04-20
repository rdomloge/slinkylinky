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
        AuditRecord ar = createValidAuditRecord(UUID.randomUUID());
        String json = createConfiguredMapper().writeValueAsString(ar);

        receiver.receiveMessage(json);

        verify(repo, times(1)).save(ArgumentMatchers.any(AuditRecord.class));
    }

    @Test
    void receiveMessage_validationErrors_doesNotSave() throws Exception {
        AuditRecord ar = createValidAuditRecord(null);
        ar.setEntityType("Proposal");
        String json = createConfiguredMapper().writeValueAsString(ar);

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
        AuditRecord ar = createValidAuditRecord(UUID.randomUUID());
        String json = createConfiguredMapper().writeValueAsString(ar);
        byte[] bytes = json.getBytes("utf-8");

        receiver.receiveMessage(bytes);

        verify(repo, times(1)).save(ArgumentMatchers.any(AuditRecord.class));
    }

    @Test
    void receiveMessage_globalEntityType_nullOrg_savesToRepo() throws Exception {
        AuditRecord ar = createValidAuditRecord(null);
        ar.setEntityType("BlackListedSupplier");
        String json = createConfiguredMapper().writeValueAsString(ar);

        receiver.receiveMessage(json);

        verify(repo, times(1)).save(ArgumentMatchers.any(AuditRecord.class));
    }

    @Test
    void receiveMessage_nonGlobalEntityType_nullOrg_doesNotSave() throws Exception {
        AuditRecord ar = createValidAuditRecord(null);
        ar.setEntityType("Proposal");
        String json = createConfiguredMapper().writeValueAsString(ar);

        receiver.receiveMessage(json);

        verify(repo, never()).save(ArgumentMatchers.any(AuditRecord.class));
    }

    private AuditRecord createValidAuditRecord(UUID orgId) {
        AuditRecord ar = new AuditRecord();
        ar.setWho("testuser");
        ar.setWhat("test action");
        ar.setEventTime(LocalDateTime.now());
        ar.setEntityType("Proposal");
        ar.setDetail("test detail");
        ar.setOrganisationId(orgId);
        return ar;
    }
}
