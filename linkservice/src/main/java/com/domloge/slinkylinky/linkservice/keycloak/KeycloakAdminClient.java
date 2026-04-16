package com.domloge.slinkylinky.linkservice.keycloak;

import java.time.Instant;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestClient;

import lombok.extern.slf4j.Slf4j;

/**
 * Client for the Keycloak Admin REST API.
 * Obtains a service-account token via client-credentials flow and caches it until
 * 60 seconds before expiry.
 */
@Slf4j
@Component
public class KeycloakAdminClient {

    @Value("${keycloak.admin.url:}")
    private String adminUrl;

    @Value("${keycloak.admin.realm:slinkylinky}")
    private String realm;

    @Value("${keycloak.admin.client-id:}")
    private String clientId;

    @Value("${keycloak.admin.client-secret:}")
    private String clientSecret;

    private final RestClient restClient = RestClient.create();

    private String cachedToken;
    private Instant tokenExpiry = Instant.EPOCH;

    public boolean isConfigured() {
        return adminUrl != null && !adminUrl.isBlank()
            && clientId != null && !clientId.isBlank()
            && clientSecret != null && !clientSecret.isBlank();
    }

    private synchronized String getAdminToken() {
        if (cachedToken != null && Instant.now().isBefore(tokenExpiry)) {
            return cachedToken;
        }
        log.debug("Fetching new Keycloak admin token");
        String tokenUrl = adminUrl + "/realms/" + realm + "/protocol/openid-connect/token";

        MultiValueMap<String, String> form = new LinkedMultiValueMap<>();
        form.add("grant_type", "client_credentials");
        form.add("client_id", clientId);
        form.add("client_secret", clientSecret);

        @SuppressWarnings("unchecked")
        Map<String, Object> resp = restClient.post()
            .uri(tokenUrl)
            .contentType(MediaType.APPLICATION_FORM_URLENCODED)
            .body(form)
            .retrieve()
            .body(Map.class);

        if (resp == null) {
            throw new IllegalStateException("Empty response from Keycloak token endpoint");
        }
        cachedToken = (String) resp.get("access_token");
        int expiresIn = resp.containsKey("expires_in") ? (Integer) resp.get("expires_in") : 60;
        tokenExpiry = Instant.now().plusSeconds(expiresIn - 60);
        return cachedToken;
    }

    /** List Keycloak users with a given org_id attribute. */
    public List<Map<String, Object>> listUsersByOrgId(String orgId) {
        String url = adminUrl + "/admin/realms/" + realm + "/users?q=org_id:" + orgId + "&max=200";
        return restClient.get()
            .uri(url)
            .header(HttpHeaders.AUTHORIZATION, "Bearer " + getAdminToken())
            .retrieve()
            .body(new ParameterizedTypeReference<List<Map<String, Object>>>() {});
    }

    /** Create a Keycloak user with the given org_id attribute. */
    public void createUser(Map<String, Object> userRepresentation) {
        String url = adminUrl + "/admin/realms/" + realm + "/users";
        restClient.post()
            .uri(url)
            .header(HttpHeaders.AUTHORIZATION, "Bearer " + getAdminToken())
            .contentType(MediaType.APPLICATION_JSON)
            .body(userRepresentation)
            .retrieve()
            .toBodilessEntity();
    }

    /** Disable (not delete) a Keycloak user. */
    public void disableUser(String userId) {
        String url = adminUrl + "/admin/realms/" + realm + "/users/" + userId;
        restClient.put()
            .uri(url)
            .header(HttpHeaders.AUTHORIZATION, "Bearer " + getAdminToken())
            .contentType(MediaType.APPLICATION_JSON)
            .body(Map.of("enabled", false))
            .retrieve()
            .toBodilessEntity();
    }
}
