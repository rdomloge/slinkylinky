package com.domloge.slinkylinky.stats.controller;

import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

import com.domloge.slinkylinky.common.TenantContext;
import com.domloge.slinkylinky.events.AuditEvent;
import com.domloge.slinkylinky.stats.moz.DaChecker;
import com.domloge.slinkylinky.stats.moz.LinkChecker;
import com.domloge.slinkylinky.stats.moz.MozDomain;
import com.domloge.slinkylinky.stats.moz.MozPageLink;
import com.fasterxml.jackson.core.JsonProcessingException;
import java.util.UUID;

import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping(".rest/mozsupport")
@Slf4j
public class MozController {

    @Autowired
    private LinkChecker linkChecker;

    @Autowired
    private DaChecker domainChecker;

    @Autowired
    private AmqpTemplate auditRabbitTemplate;


    @ResponseStatus(value = HttpStatus.NOT_FOUND)
    public class ResourceNotFoundException extends RuntimeException {
    }

    @GetMapping(path = "/checkdomain", produces = "application/json")
    public @ResponseBody MozDomain check(@RequestParam String domain) throws JsonProcessingException {
        String user = TenantContext.getUsername();
        log.info("Checking DA for " + domain);

        MozDomain domainResults = domainChecker.getCurrent(user, domain);
        return domainResults;
    }

    @GetMapping(path = "/checklink", produces = "application/json")
    public @ResponseBody MozPageLink check(@RequestParam String demandurl, @RequestParam String supplierDomain,
            @RequestHeader long demandId) throws JsonProcessingException {

        String user = TenantContext.getUsername();
        UUID organisationId = TenantContext.getOrganisationId().map(UUID::fromString).orElse(null);

        log.info("Checking " + demandurl);

        // audit the usage of the Moz API
        AuditEvent auditEvent = new AuditEvent();
        auditEvent.setEventTime(java.time.LocalDateTime.now());
        auditEvent.setWho(user);
        auditEvent.setWhat("Use Moz API");
        auditEvent.setDetail(supplierDomain +" => "+ demandurl);
        auditEvent.setEntityId(String.valueOf(demandId));
        auditEvent.setEntityType("Demand");
        auditEvent.setOrganisationId(organisationId);
        auditRabbitTemplate.convertAndSend(auditEvent);

        // constantcontact.com -> gerryoleary.com
        if(demandurl.equals("gerryoleary.com") && supplierDomain.equals("constantcontact.com")) {
            log.warn("[][][][] Returning fake result [][][][]");
            var mpl =  new MozPageLink();
            var target = new MozPageLink.Page();
            target.setRoot_domain("gerryoleary.com");
            var source = new MozPageLink.Page();
            source.setRoot_domain("constantcontact.com");
            mpl.setSource(source);
            mpl.setTarget(target);
            return mpl;
        }

        MozPageLink result = linkChecker.check(demandurl, supplierDomain, null);
        if(result == null) {
            log.debug("Moz found no previous link from {} to {}, so proposal is valid", supplierDomain, demandurl);
            throw new ResourceNotFoundException(); // this is OK - it just means there's no previous link
        }
        log.warn("Moz found a previous link from {} to {}, so proposal is invalid", supplierDomain, demandurl);
        return result;
    }
}
