package com.domloge.slinkylinky.supplierengagement;

import java.io.UnsupportedEncodingException;

import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.MailException;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.supplierengagement.email.Context;
import com.domloge.slinkylinky.supplierengagement.email.EmailBuilder;
import com.domloge.slinkylinky.supplierengagement.email.EmailSender;
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

    
    public void receiveMessage(String message) throws AddressException, MessagingException {
        JsonObject json = JsonParser.parseString(message).getAsJsonObject();
        if(!json.has("type")) {
            log.warn("No type in message");
            return;
        }
        String type = json.get("type").getAsString();
        log.info("Received <" + message + ">");

        if(json.has("proposal") && json.getAsJsonObject("proposal").has("article")) {
            JsonObject proposal = json.getAsJsonObject("proposal");
            String article = proposal.get("article").getAsString();
            log.info("Article: " + article);
            // let's assume that this is the first time we see this article
            // and that we want to send an email to the supplier
            Context ctx = emailBuilder.build(article, proposal);
            MimeMessage mimeMessage = ctx.getMessage();
            try {
                emailSender.send(mimeMessage);

                AuditRecord auditRecord = new AuditRecord();
                auditRecord.setEntityId(proposal.get("id").getAsLong());
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
            log.warn("No article in proposal");
        }
    }

    public void receiveMessage(byte[] message) throws AddressException, MessagingException {
        try {
            receiveMessage(new String(message, "utf-8"));
        } 
        catch (UnsupportedEncodingException e) {
            receiveMessage(new String(message));
        }
    }   
}
