package com.domloge.slinkylinky.linkservice.controller;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.domloge.slinkylinky.linkservice.Util;
import com.domloge.slinkylinky.linkservice.entity.BlackListedSupplier;
import com.domloge.slinkylinky.linkservice.entity.audit.BlackListedSupplierAuditor;
import com.domloge.slinkylinky.linkservice.repo.BlackListedSupplierRepo;

import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping(".rest/blackListedSupplierSupport")
@Slf4j
public class BlackListedSupplierSupportController {

    @Autowired
    private BlackListedSupplierRepo blackListedSupplierRepo;

    @Autowired
    private BlackListedSupplierAuditor blackListedSupplierAuditor;
    
    @GetMapping(path = "/isBlackListed", produces = "application/json")
    @Transactional
    public ResponseEntity<Boolean> isBlackListed(@RequestParam String website) {
        log.info("Checking if website is blacklisted: " + website);

        String domain = Util.stripDomain(website);
        BlackListedSupplier blackListedSupplier = blackListedSupplierRepo.findByDomainIgnoreCase(domain);
        if (blackListedSupplier == null) {
            log.debug("Website is not blacklisted: " + website);
            return ResponseEntity.ok(false);
        }
        log.info("Website is blacklisted: " + website);
        return ResponseEntity.ok(true);
    }

    @PostMapping(path = "/addBlackListed", produces = "application/json")
    @Transactional
    public ResponseEntity<Boolean> addBlackListed(@RequestParam String website, @RequestHeader String user, 
            @RequestBody String dataPointsJson, @RequestParam int da, @RequestParam int spamRating) {

        log.info("Adding website to blacklist: " + website);

        String domain = Util.stripDomain(website);
        BlackListedSupplier blackListedSupplier = blackListedSupplierRepo.findByDomainIgnoreCase(domain);
        if (blackListedSupplier != null) {
            log.debug("Website is already blacklisted: " + website);
            return ResponseEntity.badRequest().body(false);
        }
        blackListedSupplier = new BlackListedSupplier();
        blackListedSupplier.setDomain(domain);
        blackListedSupplier.setCreatedBy(user);
        blackListedSupplier.setDateCreated(LocalDateTime.now());
        blackListedSupplier.setDataPointsJson(dataPointsJson);
        blackListedSupplier.setDa(da);
        blackListedSupplier.setSpamRating(spamRating);

        BlackListedSupplier dbBlackListedSupplier = blackListedSupplierRepo.save(blackListedSupplier);
        log.info("Website added to blacklist: " + website);
        blackListedSupplierAuditor.handleAfterCreate(dbBlackListedSupplier);
        return ResponseEntity.ok(true);
    }
}
