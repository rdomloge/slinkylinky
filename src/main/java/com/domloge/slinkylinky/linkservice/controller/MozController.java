package com.domloge.slinkylinky.linkservice.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

import com.domloge.slinkylinky.linkservice.moz.LinkChecker;
import com.domloge.slinkylinky.linkservice.moz.MozPageLink;
import com.fasterxml.jackson.core.JsonProcessingException;

import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping(".rest/mozsupport")
@Slf4j
public class MozController {

    @Autowired
    private LinkChecker linkChecker;

    @ResponseStatus(value = HttpStatus.NOT_FOUND)
    public class ResourceNotFoundException extends RuntimeException {
    }
    
    @GetMapping(path = "/checklink", produces = "application/json")
    public @ResponseBody MozPageLink check(@RequestParam String demandurl, String supplierDomain) throws JsonProcessingException {
        log.info("Checking " + demandurl);

        // if(System.currentTimeMillis() % 2 == 0) {
        //     log.warn("[][][][] Returning fake result [][][][]");
        //     return linkChecker.check("frontpageadvantage.com", "businessmention.co.uk", null);
        // }

        MozPageLink result = linkChecker.check(demandurl, supplierDomain, null);
        if(result == null) {
            throw new ResourceNotFoundException();
        }
        return result;
    }
}
