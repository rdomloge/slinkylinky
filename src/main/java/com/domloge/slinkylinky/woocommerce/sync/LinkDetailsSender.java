package com.domloge.slinkylinky.woocommerce.sync;

import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.woocommerce.entity.OrderEntity;
import com.domloge.slinkylinky.woocommerce.entity.OrderLineItemEntity;
import com.domloge.slinkylinky.woocommerce.sync.dto.AuditRecord;

import freemarker.template.TemplateException;
import jakarta.activation.DataHandler;
import jakarta.mail.BodyPart;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.Multipart;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeBodyPart;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.internet.MimeMultipart;
import jakarta.mail.util.ByteArrayDataSource;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class LinkDetailsSender {

    @Autowired
    private JavaMailSender emailSender;

    @Value("${spring.mail.from}")
    private String from;

    @Value("${spring.mail.subject:Link Sync order #%d complete}")
    private String subject;

    @Autowired
    private LinkDetailsContentBuilder linkDetailsContentBuilder;

    @Autowired
    private AmqpTemplate auditTemplate;

    @Autowired
    private LinkResolver linkResolver;

        

    public void send(OrderEntity orderEntity) {
        try {
            send(build(orderEntity));

            AuditRecord auditRecord = new AuditRecord();
            auditRecord.setEntityType("OrderEntity");
            auditRecord.setEventTime(LocalDateTime.now());
            auditRecord.setEntityId(orderEntity.getId());
            auditRecord.setWhat("Link details email");
            String sendTo = orderEntity.getShippingEmailAddress() != null ? orderEntity.getShippingEmailAddress() : orderEntity.getBillingEmailAddress();
            auditRecord.setDetail("Sent to "+sendTo);
            auditRecord.setWho("System");
            auditTemplate.convertAndSend(auditRecord);
            log.info("Audit record sent");
        } 
        catch (MessagingException | IOException | TemplateException e) {
            throw new RuntimeException(e);
        }
    }

    // @PostConstruct
    // private void init() throws MessagingException, IOException, TemplateException {
    //     Long id = 852L;
    //     orderRepo.findById(id).ifPresentOrElse(orderEntity -> {
    //         try {
    //             send(build(orderEntity));
    //         } catch (MessagingException | IOException | TemplateException e) {
    //             throw new RuntimeException(e);
    //         }
    //     } , () -> log.error("No order found for ID {}", id));
    // }

    private void send(MimeMessage mimeMessage) throws MessagingException {
        try {
            mimeMessage.setFrom(new InternetAddress(from, "Link Sync"));
        } 
        catch (UnsupportedEncodingException e) {
            throw new MessagingException("Could not set from address", e);
        }
        emailSender.send(mimeMessage);
        
    }
    

    private MimeMessage build(OrderEntity orderEntity) throws MessagingException, IOException, TemplateException {
        String sendTo = orderEntity.getShippingEmailAddress() != null ? orderEntity.getShippingEmailAddress() : orderEntity.getBillingEmailAddress();
        // String sendTo = "rdomloge@gmail.com";

        MimeMessage message = emailSender.createMimeMessage(); 
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(sendTo)); 
        message.setSubject(String.format(subject, orderEntity.getExternalId()));

        MimeBodyPart logo = new MimeBodyPart();
        logo.setFileName("logo.png");
        logo.setContentID("logo-cid");
        logo.setDisposition(MimeBodyPart.INLINE);
        try {
            logo.attachFile(this.getClass().getClassLoader().getResource("linksync-logo.png").getFile());
            InputStream imageStream = this.getClass().getClassLoader().getResource("linksync-logo.png").openStream();
            log.debug("Stream available: {}" + imageStream);
            logo.setDataHandler(
                new DataHandler(
                    new ByteArrayDataSource(imageStream, 
                        "image/png")));
        } catch (IOException | MessagingException e) {
            log.error("Could not load logo to email", e);
        }

        Map<DemandLite, LinkDetails> matches = new HashMap<>();
        for(OrderLineItemEntity lineItem: orderEntity.getLineItems()) {
            linkResolver.add(lineItem, matches);
        };
        
        Map<String, Object> templateModel = new HashMap<>();
        templateModel.put("paidLinks", matches);
        templateModel.put("orderNum", orderEntity.getExternalId());
        String content = linkDetailsContentBuilder.build("The Link Sync Team", orderEntity.getCustomerName(), templateModel);
        BodyPart messageBodyPart = new MimeBodyPart(); 
        messageBodyPart.setContent(content, "text/html; charset=utf-8");
        Multipart multipart = new MimeMultipart();
        multipart.addBodyPart(messageBodyPart);
        multipart.addBodyPart(logo);
        message.setContent(multipart);
        
        return message;  
    }
    
}
