package com.domloge.slinkylinky.supplierengagement;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;

import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.supplierengagement.email.ContentBuilder;
import com.domloge.slinkylinky.supplierengagement.email.EmailBuilder;
import com.domloge.slinkylinky.supplierengagement.email.EmailSender;
import com.domloge.slinkylinky.supplierengagement.email.HttpUtils;
import com.domloge.slinkylinky.supplierengagement.email.Proposal;
import com.domloge.slinkylinky.supplierengagement.entity.Engagement;
import com.domloge.slinkylinky.supplierengagement.entity.EngagementStatus;
import com.domloge.slinkylinky.supplierengagement.repo.EngagementRepo;

import jakarta.annotation.PostConstruct;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class ProposalAutoCanceller  {

    @Autowired
    private EngagementRepo engagementRepo;

    @Autowired
    private EmailSender emailSender;

    @Autowired
    private EmailBuilder emailBuilder;

    @Autowired
    private ContentBuilder contentBuilder;

    @Autowired
    private HttpUtils httpUtils;

    @Autowired
    private AmqpTemplate auditRabbitTemplate;


    @PostConstruct
    @Scheduled(fixedRate = 1000 * 60 * 60)
    public void findExpiredProposals() {
        log.info("Finding expired proposals");
        // Find proposals where the supplier email was sent more than 48 hours ago
        Engagement[] expired = engagementRepo.findByStatusAndSupplierEmailSentBefore(EngagementStatus.NEW, LocalDateTime.now().minus(2, ChronoUnit.DAYS));
        log.info("Found {} expired proposals", expired.length);

        for (Engagement engagement : expired) {
            log.info("S: {} D: {} T: {}", engagement.getStatus(), engagement.getSupplierEmailSent().toLocalDate(), engagement.getSupplierEmailSent().toLocalTime());
            engagement.setStatus(EngagementStatus.EXPIRED);
            engagementRepo.save(engagement);
            log.info("Engagement for proposal {} with GUID {} expired ", engagement.getProposalId(), engagement.getGuid());

            AuditRecord audit = new AuditRecord();
            audit.setEntityId(engagement.getProposalId());
            audit.setEntityType("Engagement");
            audit.setWhat("Engagement expired");
            audit.setEventTime(LocalDateTime.now());
            audit.setWho("supplier-engagement-bot");
            audit.setDetail("Engagement "+engagement.getId()+" expired for proposal " + engagement.getProposalId());
            auditRabbitTemplate.convertAndSend(audit);

            try {
                Proposal p = httpUtils.loadProposal(engagement.getProposalId());
                if(null == p) {
                    log.error("Proposal {} not found - engagement {} refers to a missing proposal", engagement.getProposalId(), engagement.getId());	
                    continue;
                }
                if(p.isDoNotExpire()) {
                    log.info("Proposal {} is marked as do not expire - skipping", engagement.getProposalId());
                    continue;
                }
                if(p.isProposalAccepted() || p.isBlogLive() ||  p.isInvoiceReceived() || p.isInvoicePaid()) {
                    log.info("Proposal {} is in invalid state - cannot cancel (a:{} l:{} ir:{} ip:{})", p.getId(), p.isProposalAccepted(), p.isBlogLive(), p.isInvoiceReceived(), p.isInvoicePaid());
                    continue;
                }
                // abort the Proposal
                httpUtils.abortProposal(engagement.getProposalId());
                log.info("Proposal {} aborted", engagement.getProposalId());

                String content = contentBuilder.buildEngagementExpiredContent(engagement, p);
                
                MimeMessage engagementExpiredMessage = emailBuilder.buildEngagementExpiredMessage(engagement, content);
                emailSender.send(engagementExpiredMessage, engagement.getProposalId());
            }
            catch (IOException | MessagingException e) {
                log.error("Error sending email", e);
            }
        }
        
    }
    
}
