package com.domloge.slinkylinky.supplierengagement;

import java.nio.charset.Charset;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.supplierengagement.entity.Engagement;
import com.domloge.slinkylinky.supplierengagement.entity.EngagementStatus;
import com.domloge.slinkylinky.supplierengagement.repo.EngagementRepo;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import jakarta.mail.BodyPart;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.Multipart;
import jakarta.mail.internet.AddressException;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeBodyPart;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.internet.MimeMultipart;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class EmailBuilder {

    @Autowired
    private JavaMailSender emailSender;

    @Value("${slinkyLinky.domain}")
    private String slinkyLinkyDomain;

    @Autowired
    private EngagementRepo engagementRepo;


    @Getter
    @Setter
    @AllArgsConstructor
    @ToString
    class SupplierDetails {
        String name;
        String email;
        String website;
        String weWriteFee;
        String weWriteFeeCurrency;

        public boolean validate() {
            return name != null && !name.isEmpty() 
                && email != null && !email.isEmpty() 
                && website != null && !website.isEmpty()
                && weWriteFee != null && !weWriteFee.isEmpty();
        }
    }


    public MimeMessage build(String article, JsonObject proposal) throws AddressException, MessagingException {
        MimeMessage message = emailSender.createMimeMessage(); 
        message.setFrom(new InternetAddress("rdomloge@gmail.com")); 
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse("rdomloge@gmail.com")); 
        message.setSubject("SlinkyLinky request for engagement"); 

        SupplierDetails supplierDetails = findSupplierDetails(proposal);
        if( ! supplierDetails.validate()) {
            log.error("Invalid supplier details: {}", supplierDetails);
            throw new MessagingException("Could not build message due to invalid supplier details");
        }

        Engagement engagement = new Engagement();
        engagement.setSupplierName(supplierDetails.name);
        engagement.setSupplierEmail(supplierDetails.email);
        engagement.setSupplierWebsite(supplierDetails.website);
        engagement.setSupplierWeWriteFee(supplierDetails.weWriteFee);
        engagement.setSupplierWeWriteFeeCurrency(supplierDetails.weWriteFeeCurrency);
        engagement.setProposalId(proposal.get("id").getAsLong());
        engagement.setGuid(UUID.randomUUID().toString());
        engagement.setSupplierEmailSent(java.time.LocalDateTime.now());
        engagement.setArticle(article);
        engagement.setStatus(EngagementStatus.NEW);
        log.info("Saving engagement {}", engagement);
        Engagement dbEngagement = engagementRepo.save(engagement);

        BodyPart messageBodyPart = new MimeBodyPart(); 
        String fee = supplierDetails.weWriteFeeCurrency+supplierDetails.weWriteFee;
        String messageContent = "<p>Hi <b style='color:red'>"+supplierDetails.name+"</b>, please see attached for an aticle to engage with. We have you on file as charging "
            +fee+". If you agree, please post the article, create an invoice for "+fee+" and then click <a href='"+slinkyLinkyDomain+"/public/supplierresponse?id="
            +dbEngagement.getGuid()+"'>here</a> to upload the invoice, inform is of the URL to the article and enter the article title,</p><p>Regards, Slinkylinky</p>";
        messageBodyPart.setContent(messageContent, "text/html; charset=utf-8");

        MimeBodyPart attachmentPart = new MimeBodyPart();
        attachmentPart.setFileName("article.md");
        attachmentPart.setText(article, Charset.defaultCharset().name()); 
        
        Multipart multipart = new MimeMultipart(); 
        multipart.addBodyPart(messageBodyPart); 
        multipart.addBodyPart(attachmentPart); 

        message.setContent(multipart); 

        return message;  
    }

    private SupplierDetails findSupplierDetails(JsonObject proposal) {
        JsonArray paidLinks = proposal.get("paidLinks").getAsJsonArray();
        JsonObject supplier = paidLinks.get(0).getAsJsonObject().get("supplier").getAsJsonObject();
        String name = supplier.has("name") ? supplier.get("name").getAsString() : "";
        String email = supplier.has("email") ? supplier.get("email").getAsString() : "";
        String website = supplier.has("website") ? supplier.get("website").getAsString() : "";
        String weWriteFee = supplier.has("weWriteFee") ? supplier.get("weWriteFee").getAsString() : "Unknown";
        String weWriteFeeCurrency = supplier.has("weWriteFeeCurrency") ? supplier.get("weWriteFeeCurrency").getAsString() : "£";
        return new SupplierDetails(name, email, website, weWriteFee, weWriteFeeCurrency);
    }
}
