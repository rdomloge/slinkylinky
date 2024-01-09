package com.domloge.slinkylinky.supplierengagement;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Component;

import jakarta.mail.internet.MimeMessage;


@Component
public class EmailSender {

    @Autowired
    private JavaMailSender emailSender;

    
    public void sendSimpleMessage(String to, String subject, String text) {

        SimpleMailMessage message = new SimpleMailMessage(); 
        message.setFrom("rdomloge@gmail.com");
        message.setTo(to); 
        message.setSubject(subject); 
        message.setText(text);
        emailSender.send(message);
    }


    public void send(MimeMessage mimeMessage) {
        emailSender.send(mimeMessage);
    }
}
