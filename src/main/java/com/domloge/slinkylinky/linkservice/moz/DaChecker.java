package com.domloge.slinkylinky.linkservice.moz;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import java.util.Map;
import java.util.HashMap;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

@Component
public class DaChecker extends AbstractMoz {
    
    private RestTemplate restTemplate = new RestTemplate();

    @Value("${moz.baseUrl}")
    private String base;

    @Value("${moz.accesskey}")
    private String accessId;

    @Value("${moz.secret}")
    private String secretKey;

    public MozDomain checkDomain(String domain) throws JsonProcessingException {
        String apiUrl = base + "url_metrics";
        HttpHeaders headers = createHeaders(accessId, secretKey);

        Map<String, Object> payload = new HashMap<>();
        payload.put("targets", new String[]{domain});
        
        
        String body = new ObjectMapper().writeValueAsString(payload);

        ResponseEntity<MozDomainResponse> response = restTemplate.exchange(apiUrl, HttpMethod.POST, 
            new HttpEntity<String>(body, headers), 
            MozDomainResponse.class, apiUrl);

        if(response.getBody().getResults().length == 0) {
            throw new RuntimeException("No results for " + domain);
        }

        return response.getBody().getResults()[0];
    }
}
