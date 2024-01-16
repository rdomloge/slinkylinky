package com.domloge.slinkylinky.supplierengagement.controller;

import java.io.IOException;
import java.util.Optional;

import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.repository.query.Param;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.domloge.slinkylinky.events.SupplierEngagementEvent;
import com.domloge.slinkylinky.supplierengagement.AuditRecord;
import com.domloge.slinkylinky.supplierengagement.SupplierengagementApplication;
import com.domloge.slinkylinky.supplierengagement.entity.Engagement;
import com.domloge.slinkylinky.supplierengagement.entity.EngagementStatus;
import com.domloge.slinkylinky.supplierengagement.repo.EngagementRepo;

import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;


@Controller
@RequestMapping(".rest/engagements")
@Slf4j
public class UploadController {

    private static final long MAX_FILE_SIZE = 1024 * 1024 * 10; // 10MB

    @Autowired
    private EngagementRepo engagementRepo;

    @Autowired
    private AmqpTemplate auditRabbitTemplate;

    @Autowired
    private AmqpTemplate supplierengagementRabbitTemplate;


    @PatchMapping(path = "/updateblogdetails", produces = "application/json")
    public ResponseEntity<Object> update(@RequestParam("guid") String guid, @RequestBody Engagement engagement) {
        Engagement dbEngagement = engagementRepo.findByGuid(guid);
        if(null == dbEngagement) {
            log.warn("Attempted blog details update for unknown engagement: " + guid);
            return ResponseEntity.notFound().build();
        }

        dbEngagement.setBlogTitle(engagement.getBlogTitle());
        dbEngagement.setBlogUrl(engagement.getBlogUrl());
        dbEngagement.setStatus(EngagementStatus.ACCEPTED);
        engagementRepo.save(dbEngagement);

        AuditRecord auditRecord = new AuditRecord();
        auditRecord.setEntityId(dbEngagement.getProposalId());
        auditRecord.setEntityType("Proposal");
        auditRecord.setEventTime(java.time.LocalDateTime.now());
        auditRecord.setWho("Supplier through public API");
        auditRecord.setWhat("Proposal accepted by supplier");
        auditRecord.setDetail("Blog title: " + dbEngagement.getBlogTitle() + ", Blog URL: " + dbEngagement.getBlogUrl());
        auditRabbitTemplate.convertAndSend(auditRecord);

        SupplierEngagementEvent event = new SupplierEngagementEvent();
        event.buildForAccept(dbEngagement.getBlogTitle(), 
            dbEngagement.getBlogUrl(), 
            dbEngagement.getInvoiceFileName() !=null, 
            dbEngagement.getProposalId());
        supplierengagementRabbitTemplate.convertAndSend(event);

        log.info("Engagement {} complete. Blog title: {}", dbEngagement.getId(), engagement.getBlogTitle());

        return ResponseEntity.ok().build();
    }



    @PostMapping(path = "/uploadInvoice", produces = "text/HTML")
    @Transactional
    public ResponseEntity<Object> uploadInvoice(@RequestParam String guid, @RequestParam("file") MultipartFile file,
			RedirectAttributes redirectAttributes) throws IOException {

        Engagement engagement = engagementRepo.findByGuid(guid);
        if(null == engagement) {
            log.warn("Attempted invoice upload for unknown engagement: " + guid);
            return ResponseEntity.notFound().build();
        }

        if(file.getSize() > MAX_FILE_SIZE) {
            log.warn("Attempted invoice upload filesize too large: " + file.getSize());
            return ResponseEntity.badRequest().body("Invoice filesize too large");
        }
        
        engagement.setInvoiceFileName(file.getOriginalFilename());
        engagement.setInvoiceFileContentType(file.getContentType());
        engagement.setInvoiceFileContent(file.getBytes());
        engagementRepo.save(engagement);

        AuditRecord auditRecord = new AuditRecord();
        auditRecord.setEntityId(engagement.getProposalId());
        auditRecord.setEntityType("Proposal");
        auditRecord.setEventTime(java.time.LocalDateTime.now());
        auditRecord.setWho("Supplier through public API");
        auditRecord.setWhat("Invoice uploaded");
        auditRecord.setDetail("Name: "+file.getOriginalFilename()+", Size: "+file.getSize()+", Content type: "+file.getContentType());
        auditRabbitTemplate.convertAndSend(auditRecord);

        log.info("Invoice {} uploaded for engagement {}", file.getOriginalFilename(), guid);

        // proposalAuditor.handleBeforeSave(dbProposal);
        // log.info(user + " uploaded invoice for proposal " + proposalId);
        return ResponseEntity.ok().build();
    }
}
