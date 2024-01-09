package com.domloge.slinkylinky.supplierengagement;

import java.io.UnsupportedEncodingException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

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
            MimeMessage mimeMessage = emailBuilder.build(article, proposal);
            emailSender.send(mimeMessage);
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
