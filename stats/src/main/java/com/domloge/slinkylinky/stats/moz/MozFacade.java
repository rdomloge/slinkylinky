package com.domloge.slinkylinky.stats.moz;

import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import com.domloge.slinkylinky.stats.amqp.AuditRecord;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.Getter;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class MozFacade {

    @Autowired
    private AmqpTemplate auditRabbitTemplate;

    @Value("${moz.baseUrl}")
    private String base;

    private RestTemplate restTemplate = new RestTemplate();

    @Value("${moz.secret}")
    private String mozSecret;

    private int usages = 0;

    public MozFacade() {
        restTemplate.getMessageConverters().add(0, new StringHttpMessageConverter(StandardCharsets.UTF_8));
    }


    @Getter @Setter
    private class TemporalCache {
        private MozDomain mozData;
        private long timeOfLastRequest;
        private String domain;

        public Optional<MozDomain> getMozData(String domain) {
            if(System.currentTimeMillis() - timeOfLastRequest < 1000 && domain.equals(this.domain)) {
                return Optional.of(mozData);
            }
            domain = null;
            timeOfLastRequest = 0;
            return Optional.empty();
        }

        public void setMozData(MozDomain mozData, String domain) {
            this.mozData = mozData;
            this.domain = domain;
            this.timeOfLastRequest = System.currentTimeMillis();
        }
    }
    
    private TemporalCache cache = new TemporalCache();

    public MozDomain checkDomain(String user, String domain) {
        
        if(cache.getMozData(domain).isPresent()) {
            log.debug("Returning cached data for " + domain);
            return cache.getMozData(domain).get();
        }
        else log.debug("No cached data for " + domain);


        String apiUrl = base + "url_metrics";
        HttpHeaders headers = createHeaders(mozSecret);

        Map<String, Object> payload = new HashMap<>();
        payload.put("targets", new String[]{domain});
        // payload.put("monthly_history_values", new String[]{"domain_authority", "SpamScore"}); this breaks it and causes a 500 error
        
        
        String body;
        try {
            body = new ObjectMapper().writeValueAsString(payload);
        } 
        catch (JsonProcessingException e) {
            throw new RuntimeException(e);
        }

        try {
            ResponseEntity<MozDomainResponse> response = restTemplate.exchange(apiUrl, HttpMethod.POST, 
                new HttpEntity<String>(body, headers), 
                MozDomainResponse.class, apiUrl);

            if(response.getStatusCode().isError()) {
                throw new RuntimeException("Moz API returned " + response.getStatusCode().value());
            }
            else {
                audit(user, domain, null);
            }

            usages++;
            log.debug("Moz API usage count: " + usages);

            if(response.getBody().getResults().length == 0) {
                throw new RuntimeException("No results for " + domain);
            }

            MozDomain mozDomain = response.getBody().getResults()[0];
            cache.setMozData(mozDomain, domain);
            return mozDomain;
        }
        catch (Exception e) {
            audit(user, domain, e);
            throw new RuntimeException(e);
        }
    }

    private void audit(String user, String domain, Exception e) {
        // audit the usage of the Moz API
        AuditRecord auditRecord = new AuditRecord();
        auditRecord.setEventTime(java.time.LocalDateTime.now());
        auditRecord.setWho(user);
        if(null != e) {
            auditRecord.setWhat("*Failed* Use Moz API");
            auditRecord.setDetail("New Supplier DA check for " + domain + " by " + user + " failed: " + e.getMessage());
        }
        else {
            auditRecord.setWhat("Use Moz API");
            auditRecord.setDetail("New Supplier DA check for " + domain + " by " + user);
        }
        auditRecord.setEntityType("Supplier");
        auditRabbitTemplate.convertAndSend(auditRecord);
    }

    public HttpHeaders createHeaders(String mozSecret) {
        return new HttpHeaders() {
            {
                set("x-moz-token", mozSecret);
                set("Content-Type", "application/json");
                set("Accept", "application/json");
                set("Charset", "utf-8");
            }
        };
    }
}
