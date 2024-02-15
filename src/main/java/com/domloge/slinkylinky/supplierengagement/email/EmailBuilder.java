package com.domloge.slinkylinky.supplierengagement.email;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.Charset;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Component;

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

    @Value("${slinkyLinky.domain}")
    private String slinkyLinkyDomain;

    @Autowired
    private ContentBuilder contentBuilder;

    
    

    public Context build(ProposalUpdateEvent event, Engagement engagement) throws AddressException, MessagingException {
        MimeMessage message = emailSender.createMimeMessage(); 
        // message.setFrom(new InternetAddress("rdomloge@gmail.com")); 
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse("rdomloge@gmail.com")); 
        message.setSubject("SlinkyLinky request for engagement"); 

        Context ctx = new Context();
        ctx.setSlinkyLinkyDomain(slinkyLinkyDomain);
        ctx.setEvent(event);

        

        ctx.setDbEngagement(engagement);

        BodyPart messageBodyPart = new MimeBodyPart(); 
        contentBuilder.build(ctx);
        ctx.setContentBuilder(contentBuilder);
        messageBodyPart.setContent(contentBuilder.getContent(), "text/html; charset=utf-8");

        MimeBodyPart attachmentPart = new MimeBodyPart();
        attachmentPart.setFileName("article.md");
        attachmentPart.setText(event.getArticle(), Charset.defaultCharset().name());


        MimeBodyPart html = new MimeBodyPart();
        html.setFileName("article.html");
        html.setContent(Processor.process(event.getArticle()), "text/html; charset=utf-8");

        MimeBodyPart logo = new MimeBodyPart();
        logo.setFileName("logo.png");
        logo.setContentID("logo-cid");
        logo.setDisposition(MimeBodyPart.INLINE);
        try {
            logo.attachFile(this.getClass().getClassLoader().getResource("logo.png").getFile());
            InputStream imageStream = this.getClass().getClassLoader().getResource("logo.png").openStream();
            log.debug("Stream available: {}" + imageStream);;
            logo.setDataHandler(
                new DataHandler(
                    new ByteArrayDataSource(imageStream, 
                        "image/png")));
        } catch (IOException | MessagingException e) {
            log.error("Could not load logo to email", e);
        }
        
        Multipart multipart = new MimeMultipart("related"); 
        multipart.addBodyPart(messageBodyPart); 
        multipart.addBodyPart(attachmentPart); 
        multipart.addBodyPart(html);
        multipart.addBodyPart(logo);

        message.setContent(multipart); 

        ctx.setMessage(message);
        return ctx;  
    }
}
