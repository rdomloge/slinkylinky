package com.domloge.slinkylinky.stats.moz;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
public class LinkChecker {

    @Value("${moz.baseUrl}")
    private String base;

    @Value("${moz.accesskey}")
    private String accessId;

    @Value("${moz.secret}")
    private String secretKey;

    @Autowired
    private MozFacade mozFacade;

    private RestTemplate restTemplate = new RestTemplate();
    
    public MozPageLink check(String demandurl, String supplierDomain, String nextToken) throws JsonProcessingException {
        log.debug("Checking " + demandurl + " for links from " + supplierDomain);

        String apiUrl = base + "links";
        HttpHeaders headers = mozFacade.createHeaders(accessId, secretKey);

        Map<String, Object> payload = new HashMap<>();
        payload.put("target", demandurl);
        payload.put("target_scope", "root_domain"); // page, subdomain, root_domain
        payload.put("source_scope", "root_domain"); // page, subdomain, root_domain
        payload.put("filter", "external+nofollow");
        payload.put("limit", 10);
        payload.put("source_root_domain", supplierDomain);
        if(nextToken != null && !nextToken.isEmpty()) {
            payload.put("next_token", nextToken);
        }
        
        String body = new ObjectMapper().writeValueAsString(payload);

        ResponseEntity<MozLinkResponse> response = restTemplate.exchange(apiUrl, HttpMethod.POST, 
            new HttpEntity<String>(body, headers), 
            MozLinkResponse.class, demandurl);

        log.debug("Got {} links for {}", response.getBody().getResults().length, demandurl);
        for(MozPageLink link : response.getBody().getResults()) {
            log.debug("Link: {}", link.getSource().getPage());
            if(link.getSource().getPage().contains(supplierDomain)) {
                log.debug("Found link from {} to {}", supplierDomain, demandurl);
                return link;
            }
        }

        String responseNextToken = response.getBody().getNext_token();
        if(responseNextToken != null && !responseNextToken.isEmpty()) {
            log.debug("Getting next page of links");
            return check(demandurl, supplierDomain, responseNextToken);
        }
        else {
            log.debug("No more links");
            return null;
        }
    }

    
}
