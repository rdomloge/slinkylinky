package com.domloge.slinkylinky.stats.config;

import java.time.Instant;
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

    private static final long REFRESH_SKEW_SECONDS = 30;

    @Value("${keycloak.clientcredentials.client.id}")
    private String clientId;

    @Value("${keycloak.clientcredentials.client.secret}")
    private String clientSecret;

    @Value("${keycloak.base.url}")
    private String keycloakBase;

    @Value("${keycloak.clientcredentials.token.uri}")
    private String tokenUri;

    // Dedicated RestTemplate without interceptors to avoid circular calls
    private final RestTemplate tokenRestTemplate = new RestTemplate();

    private volatile String cachedToken;
    private volatile Instant cachedTokenExpiresAt = Instant.EPOCH;

    public synchronized String fetchAccessToken() {
        if (cachedToken != null && Instant.now().isBefore(cachedTokenExpiresAt)) {
            return cachedToken;
        }
        refreshAccessToken();
        return cachedToken;
    }

    @SuppressWarnings("unchecked")
    private void refreshAccessToken() {
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

        cachedToken = (String) response.get("access_token");
        Number expiresIn = (Number) response.getOrDefault("expires_in", 60);
        cachedTokenExpiresAt = Instant.now().plusSeconds(expiresIn.longValue() - REFRESH_SKEW_SECONDS);
        log.debug("Fetched new Keycloak access token, expires in {}s (cached until {})",
                expiresIn, cachedTokenExpiresAt);
    }
}
