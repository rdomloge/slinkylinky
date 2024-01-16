package com.domloge.slinkylinky.supplierengagement;

import java.io.UnsupportedEncodingException;

import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.MailException;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.events.ProposalUpdateEvent;
import com.domloge.slinkylinky.supplierengagement.email.Context;
import com.domloge.slinkylinky.supplierengagement.email.EmailBuilder;
import com.domloge.slinkylinky.supplierengagement.email.EmailSender;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

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
    private AmqpTemplate auditRabbitTemplate;

    @Autowired
    private ObjectMapper mapper;

    
    public void receiveMessage(String message) throws AddressException, MessagingException, JsonMappingException, JsonProcessingException {
        log.info("Received <" + message + ">");
        
        ProposalUpdateEvent event = mapper.readValue(message, ProposalUpdateEvent.class);
        if(event.isSupplierIs3rdParty()) {
            log.info("Supplier is 3rd party, not sending email");
            return;
        }
        
        if(event.getArticle() != null) {
            String article = event.getArticle();
            log.info("Article: " + article);
            // let's assume that this is the first time we see this article
            // and that we want to send an email to the supplier
            Context ctx = emailBuilder.build(article, event);
            MimeMessage mimeMessage = ctx.getMessage();
            try {
                emailSender.send(mimeMessage, event.getProposalId());

                AuditRecord auditRecord = new AuditRecord();
                auditRecord.setEntityId(event.getProposalId());
                auditRecord.setEntityType("Proposal");
                auditRecord.setEventTime(java.time.LocalDateTime.now());
                auditRecord.setWho("haven't worked this out yet");
                auditRecord.setWhat("Email sent to supplier");
                auditRecord.setDetail(ctx.getContentBuilder().getContent());
                auditRabbitTemplate.convertAndSend(auditRecord);
            }
            catch(MailException e) {
                log.error("Failed to send email", e);
            }
        }
        else {
            log.info("No article in event");
        }
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
