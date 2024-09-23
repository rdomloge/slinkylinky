package com.domloge.slinkylinky.supplierengagement.email;

import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.events.SupplierEngagementEvent;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;


@Component
public class EmailSender {

    @Autowired
    private JavaMailSender emailSender;

    @Autowired
    private AmqpTemplate supplierengagementRabbitTemplate;

    
    public void send(MimeMessage mimeMessage, long proposalId) throws MessagingException {
        emailSender.send(mimeMessage);
        SupplierEngagementEvent event = new SupplierEngagementEvent();
        event.buildForSent(proposalId);
        supplierengagementRabbitTemplate.convertAndSend(event);
    }
}
