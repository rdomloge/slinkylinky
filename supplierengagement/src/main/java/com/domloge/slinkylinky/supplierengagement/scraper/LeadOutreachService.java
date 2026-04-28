package com.domloge.slinkylinky.supplierengagement.scraper;

import java.io.IOException;
import java.io.InputStream;
import java.time.LocalDateTime;
import java.util.UUID;

import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import com.domloge.slinkylinky.events.AuditEvent;
import com.domloge.slinkylinky.supplierengagement.email.LeadEmailContentBuilder;
import com.domloge.slinkylinky.supplierengagement.entity.LeadStatus;
import com.domloge.slinkylinky.supplierengagement.entity.SupplierLead;
import com.domloge.slinkylinky.supplierengagement.repo.SupplierLeadRepo;
import com.domloge.slinkylinky.common.TenantContext;

import jakarta.activation.DataHandler;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.Multipart;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeBodyPart;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.internet.MimeMultipart;
import jakarta.mail.util.ByteArrayDataSource;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class LeadOutreachService {

    @Autowired
    private SupplierLeadRepo leadRepo;

    @Autowired
    private LeadEmailContentBuilder contentBuilder;

    @Autowired
    private JavaMailSender mailSender;

    @Autowired
    private AmqpTemplate auditRabbitTemplate;

    @Value("${spring.mail.from}")
    private String from;

    @Value("${spring.mail.testing}")
    private boolean isTesting;

    @Value("${spring.mail.testing.addresses}")
    private String testingAddresses;

    /**
     * Sends the outreach email to the lead's contact email address.
     * Generates a GUID if one has not yet been assigned.
     * Updates status to OUTREACH_SENT on success.
     */
    public void sendOutreach(long leadId) throws MessagingException {
        SupplierLead lead = leadRepo.findById(leadId)
                .orElseThrow(() -> new IllegalArgumentException("Lead not found: " + leadId));

        if (lead.getContactEmail() == null || lead.getContactEmail().isBlank()) {
            throw new IllegalStateException("Lead " + leadId + " has no contact email — run discovery first");
        }

        if (lead.getGuid() == null) {
            lead.setGuid(UUID.randomUUID().toString());
            leadRepo.save(lead);
        }

        String content = contentBuilder.buildOutreachContent(lead);
        MimeMessage msg = buildMessage(lead, content);
        mailSender.send(msg);

        lead.setOutreachSent(LocalDateTime.now());
        lead.setStatus(LeadStatus.OUTREACH_SENT);
        leadRepo.save(lead);

        AuditEvent ae = new AuditEvent();
        ae.setWho(TenantContext.getUsername());
        ae.setWhat("outreach sent");
        ae.setEventTime(LocalDateTime.now());
        ae.setEntityType("SupplierLead");
        ae.setEntityId(String.valueOf(lead.getId()));
        ae.setDetail(lead.getDomain());
        TenantContext.getOrganisationId()
            .map(UUID::fromString)
            .ifPresent(ae::setOrganisationId);
        auditRabbitTemplate.convertAndSend(ae);

        log.info("Outreach email sent to {} for lead {} ({})", lead.getContactEmail(), lead.getId(), lead.getDomain());
    }

    private MimeMessage buildMessage(SupplierLead lead, String htmlContent) throws MessagingException {
        MimeMessage msg = mailSender.createMimeMessage();
        msg.setFrom(from);

        String recipient = isTesting ? testingAddresses : lead.getContactEmail();
        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipient));
        msg.setSubject("Partnership opportunity — " + lead.getDomain());

        MimeBodyPart body = new MimeBodyPart();
        body.setContent(htmlContent, "text/html; charset=utf-8");

        Multipart multipart = new MimeMultipart("related");
        multipart.addBodyPart(body);
        multipart.addBodyPart(buildLogoBodyPart());
        msg.setContent(multipart);
        return msg;
    }

    private MimeBodyPart buildLogoBodyPart() throws MessagingException {
        MimeBodyPart logo = new MimeBodyPart();
        logo.setFileName("logo.png");
        logo.setContentID("logo-cid");
        logo.setDisposition(MimeBodyPart.INLINE);
        try {
            String logoPath = this.getClass().getClassLoader().getResource("logo.png").getFile();
            logo.attachFile(logoPath);
            InputStream imageStream = this.getClass().getClassLoader().getResource("logo.png").openStream();
            logo.setDataHandler(
                new DataHandler(
                    new ByteArrayDataSource(imageStream, "image/png")));
        } catch (IOException e) {
            log.error("Could not load logo to email", e);
        }
        return logo;
    }
}
