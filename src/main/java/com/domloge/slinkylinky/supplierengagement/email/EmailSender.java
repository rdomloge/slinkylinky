package com.domloge.slinkylinky.supplierengagement.email;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Component;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;


@Component
public class EmailSender {

    @Autowired
    private JavaMailSender emailSender;

    @Value("${spring.mail.from}")
    private String from;

    public void send(MimeMessage mimeMessage) throws MessagingException {
        mimeMessage.setFrom(from);
        emailSender.send(mimeMessage);
    }
}
