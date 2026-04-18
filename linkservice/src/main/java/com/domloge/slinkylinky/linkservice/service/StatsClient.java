package com.domloge.slinkylinky.linkservice.service;

import java.util.Collections;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import com.domloge.slinkylinky.linkservice.config.KeycloakTokenProvider;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class StatsClient {

    @Value("${stats.url}")
    private String statsUrl;

    @Autowired
    private KeycloakTokenProvider keycloakTokenProvider;

    private final RestTemplate restTemplate = new RestTemplate();

    public List<String> getHighSpamDomains(int threshold) {
        try {
            String url = statsUrl + "/.rest/stats/spam/abovethreshold?threshold=" + threshold;
            String token = keycloakTokenProvider.fetchAccessToken();
            HttpHeaders headers = new HttpHeaders();
            headers.setBearerAuth(token);
            List<String> domains = restTemplate.exchange(
                url, HttpMethod.GET, new HttpEntity<>(headers),
                new ParameterizedTypeReference<List<String>>() {}
            ).getBody();
            return domains != null ? domains : Collections.emptyList();
        } catch (Exception e) {
            log.warn("Failed to fetch high-spam domains from stats service — spam filtering skipped: {}", e.getMessage());
            return Collections.emptyList();
        }
    }
}
