package com.domloge.slinkylinky.supplierengagement.controller;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.UUID;

import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;

import com.domloge.slinkylinky.events.AuditEvent;
import com.domloge.slinkylinky.events.SupplierEngagementEvent;
import com.domloge.slinkylinky.supplierengagement.email.ContentBuilder;
import com.domloge.slinkylinky.supplierengagement.email.Context;
import com.domloge.slinkylinky.supplierengagement.email.EmailBuilder;
import com.domloge.slinkylinky.supplierengagement.email.EmailSender;
import com.domloge.slinkylinky.supplierengagement.email.HttpUtils;
import com.domloge.slinkylinky.supplierengagement.entity.Engagement;
import com.domloge.slinkylinky.supplierengagement.entity.EngagementStatus;
import com.domloge.slinkylinky.supplierengagement.repo.EngagementRepo;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.extern.slf4j.Slf4j;


@Controller
@RequestMapping(".rest/engagements")
@Slf4j
public class UploadController {

    @Autowired
    private EngagementRepo engagementRepo;

    @Autowired
    private AmqpTemplate auditRabbitTemplate;

    @Autowired
    private EmailBuilder emailBuilder;

    @Autowired
    private EmailSender emailSender;

    @Autowired
    private ContentBuilder contentBuilder;
    
    private RestTemplate restTemplate;

    @Value("${linkservice_baseurl}")
    private String linkService_base;

    @Autowired
    private HttpUtils httpUtils;


    public UploadController() {
        RestTemplateBuilder builder = new RestTemplateBuilder();
        restTemplate = builder.build();
    }



    @PatchMapping(path = "/decline", produces = "application/json")
    public ResponseEntity<Object> decline(@RequestParam("guid") String guid, @RequestBody Engagement engagement) throws IOException {
        log.info("Received engagement decline for guid: " + guid);
        Engagement dbEngagement = engagementRepo.findByGuid(guid);
        if(null == dbEngagement) {
            log.warn("Attempted decline for unknown engagement: " + guid);
            return ResponseEntity.notFound().build();
        }

        dbEngagement.setStatus(EngagementStatus.DECLINED);
        dbEngagement.setDeclinedReason(engagement.getDeclinedReason());
        dbEngagement.setDoNotContact(engagement.isDoNotContact());
        engagementRepo.save(dbEngagement);

        AuditEvent auditEvent = new AuditEvent();
        auditEvent.setEntityId(String.valueOf(dbEngagement.getProposalId()));
        auditEvent.setEntityType("Proposal");
        auditEvent.setEventTime(LocalDateTime.now());
        auditEvent.setWho("Supplier through public API");
        auditEvent.setWhat("Proposal declined by supplier");
        auditEvent.setDetail("DNC: "+engagement.isDoNotContact()+" // Reason: " + engagement.getDeclinedReason());
        auditEvent.setOrganisationId(dbEngagement.getOrganisationId());
        auditRabbitTemplate.convertAndSend(auditEvent);

        log.info("Engagement {} declined. DNC: {} Reason: {}", dbEngagement.getId(), engagement.isDoNotContact(), engagement.getDeclinedReason());

        // Email Front Page Advantage to warn of decline - must happen before aborting proposal or email sending fails due to missing proposal
        sendDeclineWarningEmail(dbEngagement);
        log.info("Decline warning email sent");

        // publish event to cause linkservice to abort proposal
        SupplierEngagementEvent event = new SupplierEngagementEvent();
        event.buildForDecline(dbEngagement.getProposalId(), engagement.getDeclinedReason(), engagement.isDoNotContact());
        // supplierengagementRabbitTemplate.convertAndSend(event);
        String url = linkService_base+"/supplierSupport/supplierresponse?proposalId="+dbEngagement.getProposalId();
        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(httpUtils.fetchAccessToken());
        HttpEntity<SupplierEngagementEvent> request = new HttpEntity<>(event, headers);
        ResponseEntity<Void> response = restTemplate.postForEntity(url, request, null);
        if(response.getStatusCode().isError()) {
            log.error("Failed to send event to linkservice: " + response.getStatusCode());
            throw new IOException("Failed to send event to linkservice: " + response.getStatusCode()); 
        }

        return ResponseEntity.ok().build();
    }

    private void sendDeclineWarningEmail(Engagement engagement) throws IOException {
        try {

            Context ctx = new Context();
            ctx.setDbEngagement(engagement);
            String content = contentBuilder.buildForDecline(ctx);
            MimeMessage mimeMessage = emailBuilder.buildSupplierDeclinedMessage(engagement, content);
            emailSender.send(mimeMessage, engagement.getProposalId());

            AuditEvent auditEvent = new AuditEvent();
            auditEvent.setEntityId(String.valueOf(engagement.getProposalId()));
            auditEvent.setEntityType("Proposal");
            auditEvent.setEventTime(java.time.LocalDateTime.now());
            auditEvent.setWho("system");
            auditEvent.setWhat("Supplier-declined warning email sent");
            auditEvent.setDetail(content);
            auditEvent.setOrganisationId(engagement.getOrganisationId());
            auditRabbitTemplate.convertAndSend(auditEvent);
        }
        catch(MessagingException e) {
            log.error("Failed to send email", e);
        }
    }

    @PatchMapping(path = "/accept", produces = "application/json")
    public ResponseEntity<Object> update(@RequestParam("guid") String guid, @RequestBody Engagement engagement) throws IOException {
        log.info("Received engagement acceptance for guid: " + guid);
        Engagement dbEngagement = engagementRepo.findByGuid(guid);
        if(null == dbEngagement) {
            log.warn("Attempted blog details update for unknown engagement: " + guid);
            return ResponseEntity.notFound().build();
        }

        dbEngagement.setBlogTitle(engagement.getBlogTitle());
        dbEngagement.setBlogUrl(engagement.getBlogUrl());
        dbEngagement.setStatus(EngagementStatus.ACCEPTED);
        dbEngagement.setInvoiceUrl(engagement.getInvoiceUrl());
        engagementRepo.save(dbEngagement);

        AuditEvent auditEvent = new AuditEvent();
        auditEvent.setEntityId(String.valueOf(dbEngagement.getProposalId()));
        auditEvent.setEntityType("Proposal");
        auditEvent.setEventTime(java.time.LocalDateTime.now());
        auditEvent.setWho("Supplier through public API");
        auditEvent.setWhat("Proposal accepted by supplier");
        auditEvent.setDetail("Blog title: " + dbEngagement.getBlogTitle() + ", Blog URL: " + dbEngagement.getBlogUrl());
        auditEvent.setOrganisationId(dbEngagement.getOrganisationId());
        auditRabbitTemplate.convertAndSend(auditEvent);

        /**
         *  THIS REALLY SHOULD BE DONE BY RABBIT MESSAGE RATHER THAN DIRECT CALL
         */

        SupplierEngagementEvent event = new SupplierEngagementEvent();
        event.buildForAccept(dbEngagement.getBlogTitle(), 
            dbEngagement.getBlogUrl(), 
            dbEngagement.getProposalId());
        // supplierengagementRabbitTemplate.convertAndSend(event);
        String url = linkService_base+"/supplierSupport/supplierresponse?proposalId="+dbEngagement.getProposalId();
        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(httpUtils.fetchAccessToken());
        HttpEntity<SupplierEngagementEvent> request = new HttpEntity<>(event, headers);
        ResponseEntity<Void> response = restTemplate.postForEntity(url, request, null);
        if(response.getStatusCode().isError()) {
            log.error("Failed to send event to linkservice: " + response.getStatusCode());
            throw new IOException("Failed to send event to linkservice: " + response.getStatusCode()); 
        }

        log.info("Engagement {} complete. Blog title: {}", dbEngagement.getId(), engagement.getBlogTitle());

        return ResponseEntity.ok().build();
    }
    
}

