package com.domloge.slinkylinky.linkservice.config;

import java.util.Map;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class KeycloakTokenProvider {

    @Value("${keycloak.clientcredentials.client.id}")
    private String clientId;

    @Value("${keycloak.clientcredentials.client.secret}")
    private String clientSecret;

    @Value("${keycloak.clientcredentials.base.url}")
    private String keycloakBase;

    @Value("${keycloak.clientcredentials.token.uri}")
    private String tokenUri;

    private final RestTemplate tokenRestTemplate = new RestTemplate();

    @SuppressWarnings("unchecked")
    public String fetchAccessToken() {
        String url = keycloakBase + tokenUri;
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        MultiValueMap<String, String> body = new LinkedMultiValueMap<>();
        body.add("grant_type", "client_credentials");
        body.add("client_id", clientId);
        body.add("client_secret", clientSecret);
        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(body, headers);
        Map<String, Object> response = tokenRestTemplate.postForObject(url, request, Map.class);
        if (response == null || !response.containsKey("access_token")) {
            throw new RuntimeException("Failed to fetch access token from Keycloak");
        }
        log.debug("Fetched Keycloak access token for stats service call");
        return (String) response.get("access_token");
    }
}
