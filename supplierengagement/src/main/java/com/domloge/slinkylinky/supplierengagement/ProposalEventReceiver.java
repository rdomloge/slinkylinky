package com.domloge.slinkylinky.supplierengagement;

import java.io.UnsupportedEncodingException;
import java.util.Arrays;
import java.util.UUID;

import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.events.AuditEvent;
import com.domloge.slinkylinky.events.ProposalUpdateEvent;
import com.domloge.slinkylinky.events.ProposalUpdateEvent.ProposalEventType;
import com.domloge.slinkylinky.supplierengagement.email.ContentBuilder;
import com.domloge.slinkylinky.supplierengagement.email.Context;
import com.domloge.slinkylinky.supplierengagement.email.EmailBuilder;
import com.domloge.slinkylinky.supplierengagement.email.EmailSender;
import com.domloge.slinkylinky.supplierengagement.entity.Engagement;
import com.domloge.slinkylinky.supplierengagement.entity.EngagementStatus;
import com.domloge.slinkylinky.supplierengagement.repo.EngagementRepo;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.annotation.PostConstruct;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.AddressException;
import jakarta.mail.internet.MimeMessage;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class ProposalEventReceiver {

    @Autowired
    private EmailBuilder emailBuilder;

    @Autowired
    private EmailSender emailSender;

    @Autowired
    private ContentBuilder contentBuilder;

    @Autowired
    private AmqpTemplate auditRabbitTemplate;

    @Autowired
    private ObjectMapper mapper;

    @Autowired
    private EngagementRepo engagementRepo;

    
    public void receiveMessage(String message) throws AddressException, MessagingException, JsonMappingException, JsonProcessingException {
        log.info("Received <" + message + ">");
        
        ProposalUpdateEvent event = mapper.readValue(message, ProposalUpdateEvent.class);
        if(event.isSupplierIs3rdParty()) {
            log.info("Supplier is 3rd party, not sending email");
            return;
        }

        switch (event.getType()) {
            case CREATED:
                log.info("Proposal created, not sending email");
                break;
            case UPDATED:
                String article = event.getArticle();
                if(article != null) {
                    log.debug("Proposal updated, article present");
                    // if there's an existing engagement, we do nothing, if there isn't, we create one
                    Engagement engagement = engagementRepo.findByProposalIdAndStatusNewOrAcceptedOrDeclined(event.getProposalId());
                    if(engagement == null) {
                        log.info("No existing engagement found for proposal {}, creating new one ", event.getProposalId());
                        engagement = createNewEngagement(event);
                        sendEmail(engagement, event);
                        log.info("Engagement email sent to supplier");
                    }
                    else {
                        log.info("Found existing, '{}' engagement, no need to do anything", engagement.getStatus());
                    }
                }
                else {
                    log.debug("Proposal updated, article not present");
                    // if there's an existing engagement, we need to cancel it, since the article has been removed
                    Arrays.stream(engagementRepo.findByProposalId(event.getProposalId())).forEach(e -> {
                        log.info("Cancelling engagement {}", e.getGuid());
                        e.setStatus(EngagementStatus.CANCELLED);
                        engagementRepo.save(e);
                    });
                }
                break;
            case DELETED:
                log.info("Proposal deleted, clearing up existing engagements");
                // find matching engagements and (soft) delete
                Engagement[] engagements = engagementRepo.findByProposalId(event.getProposalId());
                for(Engagement engagement : engagements) {
                    if(engagement.getStatus() == EngagementStatus.NEW) {
                        log.info("Deleting engagement {}", engagement.getGuid());
                        engagement.setStatus(EngagementStatus.CANCELLED);
                        engagementRepo.save(engagement);
                        continue;
                    }
                    else {
                        log.info("Found engagement {} with status {}, not deleting", engagement.getGuid(), engagement.getStatus());
                    }
                    
                }
                break;
            default:
                break;
        }
    }

    // @PostConstruct
    // public void sendTestEmail() {
    //     log.info("Sending test email");
    //     ProposalUpdateEvent event = new ProposalUpdateEvent();
    //     event.setProposalDetails("This is the articel", 123);
    //     event.setSupplierDetails("Test supplier name", "rdomloge@gmail.com", "http://test.com", 100, "$", false);

    //     Engagement engagement = new Engagement();
    //     engagement.setSupplierName("Test supplier");
    //     engagement.setSupplierEmail("rdomloge@gmail.com");
    //     engagement.setSupplierWebsite("http://test.com");
    //     engagement.setSupplierWeWriteFee(100);
    //     engagement.setSupplierWeWriteFeeCurrency("$");
    //     engagement.setGuid("abc-123");
    //     engagement.setProposalId(123);
    //     engagement.setSupplierEmailSent(java.time.LocalDateTime.now());
    //     engagement.setArticle("Test article");
    //     engagement.setStatus(EngagementStatus.NEW);

    //     sendEmail(engagement, event);
    // }

    private void sendEmail(Engagement engagement, ProposalUpdateEvent event) {
        try {
            Context ctx = new Context();
            ctx.setEvent(event);
            ctx.setDbEngagement(engagement);
            String content = contentBuilder.buildForSupplierEngagement(ctx);
            MimeMessage mimeMessage = emailBuilder.buildSupplierEngagementMessage(event, content);
            emailSender.send(mimeMessage, event.getProposalId());

            AuditEvent auditEvent = new AuditEvent();
            auditEvent.setEntityId(String.valueOf(event.getProposalId()));
            auditEvent.setEntityType("Proposal");
            auditEvent.setEventTime(java.time.LocalDateTime.now());
            auditEvent.setWho("supplier-engagement-bot");
            auditEvent.setWhat("Email sent to supplier");
            auditEvent.setDetail(content);
            if (engagement.getOrganisationId() != null) {
                auditEvent.setOrganisationId(engagement.getOrganisationId());
            } else if (event.getOrganisationId() != null) {
                try {
                    auditEvent.setOrganisationId(java.util.UUID.fromString(event.getOrganisationId()));
                } catch (IllegalArgumentException ignored) {
                    log.warn("Unparseable organisationId on ProposalUpdateEvent: {}", event.getOrganisationId());
                }
            }
            auditRabbitTemplate.convertAndSend(auditEvent);
        }
        catch(MessagingException e) {
            log.error("Failed to send email", e);
        }
    }

    private Engagement createNewEngagement(ProposalUpdateEvent event) {
        Engagement engagement = new Engagement();
        engagement.setSupplierName(event.getSupplierName());
        engagement.setSupplierEmail(event.getSupplierEmail());
        engagement.setSupplierWebsite(event.getSupplierWebsite());
        engagement.setSupplierWeWriteFee(event.getSupplierWeWriteFee());
        engagement.setSupplierWeWriteFeeCurrency(event.getSupplierWeWriteFeeCurrency());
        engagement.setProposalId(event.getProposalId());
        engagement.setGuid(UUID.randomUUID().toString());
        engagement.setSupplierEmailSent(java.time.LocalDateTime.now());
        engagement.setArticle(event.getArticle());
        engagement.setStatus(EngagementStatus.NEW);
        if (event.getOrganisationId() != null) {
            engagement.setOrganisationId(UUID.fromString(event.getOrganisationId()));
        }
        log.info("Saving engagement {}", engagement);
        return engagementRepo.save(engagement);
    }

    public void receiveMessage(byte[] message) throws AddressException, MessagingException, JsonMappingException, JsonProcessingException {
        try {
            receiveMessage(new String(message, "utf-8"));
        } 
        catch (UnsupportedEncodingException e) {
            receiveMessage(new String(message));
        }
    }   
}
