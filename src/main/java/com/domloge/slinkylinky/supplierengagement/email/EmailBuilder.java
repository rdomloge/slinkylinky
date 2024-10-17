package com.domloge.slinkylinky.supplierengagement.email;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.Charset;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import com.domloge.slinkylinky.events.ProposalUpdateEvent;
import com.domloge.slinkylinky.supplierengagement.entity.Engagement;
import com.github.rjeschke.txtmark.Processor;

import jakarta.activation.DataHandler;
import jakarta.mail.BodyPart;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.Multipart;
import jakarta.mail.internet.AddressException;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeBodyPart;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.internet.MimeMultipart;
import jakarta.mail.util.ByteArrayDataSource;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class EmailBuilder {

    @Autowired
    private JavaMailSender emailSender;

    

    @Value("${spring.mail.testing.addresses}")
    private String testingEmailAddresses;

    @Value("${spring.mail.declinedWarning.addresses}")
    private String declinedWarningEmailAddresses;

    @Value("${spring.mail.from}")
    private String from;

    @Value("${spring.mail.testing}")
    private boolean isTesting;

    @Value("${spring.mail.bccRecipients}")
    private String bccRecipients;

    

    
    public MimeMessage buildSupplierDeclinedContext(Engagement engagement, String content) throws AddressException, MessagingException {
        MimeMessage message = emailSender.createMimeMessage(); 
        message.setFrom(from);
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(declinedWarningEmailAddresses));
        log.info("Sending to declined warning addresses ({})", declinedWarningEmailAddresses);
        if(StringUtils.hasText(bccRecipients)) {
            message.setRecipients(Message.RecipientType.BCC, InternetAddress.parse(bccRecipients));
        }
        message.setSubject("Proposal declined by supplier"); 

        BodyPart messageBodyPart = new MimeBodyPart(); 
        messageBodyPart.setContent(content, "text/html; charset=utf-8");

        Multipart multipart = new MimeMultipart("related"); 
        multipart.addBodyPart(messageBodyPart);
        multipart.addBodyPart(buildLogoBodyPart());

        message.setContent(multipart); 

        return message;
    }

    public MimeMessage buildSupplierEngagementContext(ProposalUpdateEvent event, String content) throws AddressException, MessagingException {
        MimeMessage message = emailSender.createMimeMessage(); 
        message.setFrom(from);
        if(isTesting) {
            log.warn("Sending to testing addresses ({})", testingEmailAddresses);
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(testingEmailAddresses)); 
        } else {
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(event.getSupplierEmail()));
            log.info("Sending to supplier email ({})", event.getSupplierEmail());
        }
        
        if(StringUtils.hasText(bccRecipients)) {
            message.setRecipients(Message.RecipientType.BCC, InternetAddress.parse(bccRecipients));
        }
        
        message.setSubject("SlinkyLinky request for engagement"); 

        BodyPart messageBodyPart = new MimeBodyPart(); 
        messageBodyPart.setContent(content, "text/html; charset=utf-8");

        MimeBodyPart attachmentPart = new MimeBodyPart();
        attachmentPart.setFileName("article.md");
        attachmentPart.setText(event.getArticle(), Charset.defaultCharset().name());


        MimeBodyPart html = new MimeBodyPart();
        html.setFileName("article.html");
        html.setContent(Processor.process(event.getArticle()), "text/html; charset=utf-8");

        
        
        Multipart multipart = new MimeMultipart("related"); 
        multipart.addBodyPart(messageBodyPart); 
        multipart.addBodyPart(attachmentPart); 
        multipart.addBodyPart(html);
        multipart.addBodyPart(buildLogoBodyPart());

        message.setContent(multipart); 

        return message;  
    }

    private MimeBodyPart buildLogoBodyPart() throws MessagingException {
        MimeBodyPart logo = new MimeBodyPart();
        logo.setFileName("logo.png");
        logo.setContentID("logo-cid");
        logo.setDisposition(MimeBodyPart.INLINE);
        try {
            logo.attachFile(this.getClass().getClassLoader().getResource("logo.png").getFile());
            InputStream imageStream = this.getClass().getClassLoader().getResource("logo.png").openStream();
            log.debug("Stream available: {}" + imageStream);
            logo.setDataHandler(
                new DataHandler(
                    new ByteArrayDataSource(imageStream, 
                        "image/png")));
        } catch (IOException | MessagingException e) {
            log.error("Could not load logo to email", e);
        }
        return logo;
    }
}
