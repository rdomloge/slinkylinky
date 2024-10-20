package com.domloge.slinkylinky.supplierengagement.controller;

import java.io.IOException;
import java.time.LocalDateTime;

import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;

import com.domloge.slinkylinky.events.SupplierEngagementEvent;
import com.domloge.slinkylinky.supplierengagement.AuditRecord;
import com.domloge.slinkylinky.supplierengagement.email.ContentBuilder;
import com.domloge.slinkylinky.supplierengagement.email.Context;
import com.domloge.slinkylinky.supplierengagement.email.EmailBuilder;
import com.domloge.slinkylinky.supplierengagement.email.EmailSender;
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
    private AmqpTemplate supplierengagementRabbitTemplate;

    @Autowired
    private EmailBuilder emailBuilder;

    @Autowired
    private EmailSender emailSender;

    @Autowired
    private ContentBuilder contentBuilder;
    
    private RestTemplate restTemplate;

    @Value("${linkservice_baseurl}")
    private String linkService_base;


    public UploadController() {
        RestTemplateBuilder builder = new RestTemplateBuilder();
        restTemplate = builder.build();
    }



    @PatchMapping(path = "/decline", produces = "application/json")
    public ResponseEntity<Object> decline(@RequestParam("guid") String guid, @RequestBody Engagement engagement) throws IOException {
        Engagement dbEngagement = engagementRepo.findByGuid(guid);
        if(null == dbEngagement) {
            log.warn("Attempted decline for unknown engagement: " + guid);
            return ResponseEntity.notFound().build();
        }

        dbEngagement.setStatus(EngagementStatus.DECLINED);
        dbEngagement.setDeclinedReason(engagement.getDeclinedReason());
        dbEngagement.setDoNotContact(engagement.isDoNotContact());
        engagementRepo.save(dbEngagement);

        AuditRecord auditRecord = new AuditRecord();
        auditRecord.setEntityId(dbEngagement.getProposalId());
        auditRecord.setEntityType("Proposal");
        auditRecord.setEventTime(LocalDateTime.now());
        auditRecord.setWho("Supplier through public API");
        auditRecord.setWhat("Proposal declined by supplier");
        auditRecord.setDetail("DNC: "+engagement.isDoNotContact()+" // Reason: " + engagement.getDeclinedReason());
        auditRabbitTemplate.convertAndSend(auditRecord);

        log.info("Engagement {} declined. DNC: {} Reason: {}", dbEngagement.getId(), engagement.isDoNotContact(), engagement.getDeclinedReason());

        // Email Front Page Advantage to warn of decline - must happen before aborting proposal or email sending fails due to missing proposal
        sendDeclineWarningEmail(dbEngagement);
        log.info("Decline warning email sent");

        // publish event to cause linkservice to abort proposal
        SupplierEngagementEvent event = new SupplierEngagementEvent();
        event.buildForDecline(dbEngagement.getProposalId(), engagement.getDeclinedReason(), engagement.isDoNotContact());
        // supplierengagementRabbitTemplate.convertAndSend(event);
        String url = linkService_base+"/supplierSupport/supplierresponse?proposalId="+dbEngagement.getProposalId();
        ResponseEntity<Void> response = restTemplate.postForEntity(url, event, null);
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

            AuditRecord auditRecord = new AuditRecord();
            auditRecord.setEntityId(engagement.getProposalId());
            auditRecord.setEntityType("Proposal");
            auditRecord.setEventTime(java.time.LocalDateTime.now());
            auditRecord.setWho("system");
            auditRecord.setWhat("Supplier-declined warning email sent");
            auditRecord.setDetail(content);
            auditRabbitTemplate.convertAndSend(auditRecord);
        }
        catch(MessagingException e) {
            log.error("Failed to send email", e);
        }
    }

    @PatchMapping(path = "/accept", produces = "application/json")
    public ResponseEntity<Object> update(@RequestParam("guid") String guid, @RequestBody Engagement engagement) throws IOException {
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

        AuditRecord auditRecord = new AuditRecord();
        auditRecord.setEntityId(dbEngagement.getProposalId());
        auditRecord.setEntityType("Proposal");
        auditRecord.setEventTime(java.time.LocalDateTime.now());
        auditRecord.setWho("Supplier through public API");
        auditRecord.setWhat("Proposal accepted by supplier");
        auditRecord.setDetail("Blog title: " + dbEngagement.getBlogTitle() + ", Blog URL: " + dbEngagement.getBlogUrl());
        auditRabbitTemplate.convertAndSend(auditRecord);

        SupplierEngagementEvent event = new SupplierEngagementEvent();
        event.buildForAccept(dbEngagement.getBlogTitle(), 
            dbEngagement.getBlogUrl(), 
            dbEngagement.getProposalId());
        // supplierengagementRabbitTemplate.convertAndSend(event);
        String url = linkService_base+"/supplierSupport/supplierresponse?proposalId="+dbEngagement.getProposalId();
        ResponseEntity<Void> response = restTemplate.postForEntity(url, event, null);
        if(response.getStatusCode().isError()) {
            log.error("Failed to send event to linkservice: " + response.getStatusCode());
            throw new IOException("Failed to send event to linkservice: " + response.getStatusCode()); 
        }

        log.info("Engagement {} complete. Blog title: {}", dbEngagement.getId(), engagement.getBlogTitle());

        return ResponseEntity.ok().build();
    }
    
}

