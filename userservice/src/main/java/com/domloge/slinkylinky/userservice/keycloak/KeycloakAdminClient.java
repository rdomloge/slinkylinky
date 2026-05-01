package com.domloge.slinkylinky.userservice.keycloak;

import java.net.URI;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
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

    @Value("${keycloak.admin.url}")
    private String adminUrl;

    @Value("${keycloak.admin.realm}")
    private String realm;

    @Value("${keycloak.admin.client-id}")
    private String clientId;

    @Value("${keycloak.admin.client-secret}")
    private String clientSecret;

    private final RestClient restClient = RestClient.create();

    private volatile String cachedToken;
    private volatile Instant tokenExpiry = Instant.EPOCH;

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
        log.debug("Fetched Keycloak admin token — client: '{}', granted scope: '{}'",
            clientId, resp.get("scope"));
        return cachedToken;
    }

    /** Fetch a single Keycloak user by ID. */
    @SuppressWarnings("unchecked")
    public Map<String, Object> getUser(String userId) {
        String url = adminUrl + "/admin/realms/" + realm + "/users/" + userId;
        return restClient.get()
            .uri(url)
            .header(HttpHeaders.AUTHORIZATION, "Bearer " + getAdminToken())
            .retrieve()
            .body(Map.class);
    }

    /** List Keycloak users with a given org_id attribute. */
    public List<Map<String, Object>> listUsersByOrgId(String orgId) {
        String encodedOrgId = URLEncoder.encode(orgId, StandardCharsets.UTF_8);
        String url = adminUrl + "/admin/realms/" + realm + "/users?q=org_id:" + encodedOrgId + "&max=200";
        return restClient.get()
            .uri(url)
            .header(HttpHeaders.AUTHORIZATION, "Bearer " + getAdminToken())
            .retrieve()
            .body(new ParameterizedTypeReference<List<Map<String, Object>>>() {});
    }

    /** Create a Keycloak user with the given org_id attribute. Returns the new user's UUID. */
    public String createUser(Map<String, Object> userRepresentation) {
        String url = adminUrl + "/admin/realms/" + realm + "/users";
        ResponseEntity<Void> response = restClient.post()
            .uri(url)
            .header(HttpHeaders.AUTHORIZATION, "Bearer " + getAdminToken())
            .contentType(MediaType.APPLICATION_JSON)
            .body(userRepresentation)
            .retrieve()
            .toBodilessEntity();
        URI location = response.getHeaders().getLocation();
        if (location == null) {
            throw new IllegalStateException("Keycloak did not return a Location header after user creation");
        }
        String path = location.getPath();
        return path.substring(path.lastIndexOf('/') + 1);
    }

    /**
     * Permanently delete a Keycloak user.
     * Used in compensation paths — prefer over disable so the email address
     * is freed for re-registration.
     */
    public void deleteUser(String userId) {
        String url = adminUrl + "/admin/realms/" + realm + "/users/" + userId;
        restClient.delete()
            .uri(url)
            .header(HttpHeaders.AUTHORIZATION, "Bearer " + getAdminToken())
            .retrieve()
            .toBodilessEntity();
    }

    /**
     * Disable a Keycloak user.
     * Fetches the full user representation first so the PUT does not overwrite
     * other fields (Keycloak's PUT /users/{id} is a full replace, not a PATCH).
     */
    @SuppressWarnings("unchecked")
    public void disableUser(String userId) {
        Map<String, Object> rep = getUser(userId);
        rep.put("enabled", false);
        putUser(userId, rep);
    }

    /** Get a Keycloak realm role by name. */
    public Map<String, Object> getRoleByName(String roleName) {
        String url = adminUrl + "/admin/realms/" + realm + "/roles/" + roleName;
        return restClient.get()
            .uri(url)
            .header(HttpHeaders.AUTHORIZATION, "Bearer " + getAdminToken())
            .retrieve()
            .body(new ParameterizedTypeReference<Map<String, Object>>() {});
    }

    /** Assign a realm role to a user. */
    public void assignRealmRole(String userId, Map<String, Object> roleRepresentation) {
        String url = adminUrl + "/admin/realms/" + realm
                   + "/users/" + userId + "/role-mappings/realm";
        restClient.post()
            .uri(url)
            .header(HttpHeaders.AUTHORIZATION, "Bearer " + getAdminToken())
            .contentType(MediaType.APPLICATION_JSON)
            .body(List.of(roleRepresentation))
            .retrieve()
            .toBodilessEntity();
    }

    /**
     * Set the emailVerified flag on a Keycloak user.
     * Fetches the full user representation first to avoid overwriting other fields.
     */
    @SuppressWarnings("unchecked")
    public void setEmailVerified(String userId, boolean verified) {
        Map<String, Object> rep = getUser(userId);
        rep.put("emailVerified", verified);
        putUser(userId, rep);
    }

    /** Look up a Keycloak user by exact email address. Returns empty if not found. */
    public Optional<Map<String, Object>> getUserByEmail(String email) {
        String url = adminUrl + "/admin/realms/" + realm + "/users?exact=true&email="
                   + URLEncoder.encode(email, StandardCharsets.UTF_8);
        List<Map<String, Object>> users = restClient.get()
            .uri(url)
            .header(HttpHeaders.AUTHORIZATION, "Bearer " + getAdminToken())
            .retrieve()
            .body(new ParameterizedTypeReference<List<Map<String, Object>>>() {});
        if (users == null || users.isEmpty()) {
            return Optional.empty();
        }
        return Optional.of(users.get(0));
    }

    /** Get the names of realm roles assigned to a user. */
    public List<String> getUserRealmRoles(String userId) {
        String url = adminUrl + "/admin/realms/" + realm + "/users/" + userId + "/role-mappings/realm";
        List<Map<String, Object>> roles = restClient.get()
            .uri(url)
            .header(HttpHeaders.AUTHORIZATION, "Bearer " + getAdminToken())
            .retrieve()
            .body(new ParameterizedTypeReference<List<Map<String, Object>>>() {});
        if (roles == null) return List.of();
        return roles.stream()
            .map(r -> (String) r.get("name"))
            .filter(n -> n != null)
            .toList();
    }

    /** Get the time of the most recent LOGIN event for a user. Returns null if no events exist. */
    public LocalDateTime getLastLoginTime(String userId) {
        String url = adminUrl + "/admin/realms/" + realm + "/events?type=LOGIN&userId="
                   + URLEncoder.encode(userId, StandardCharsets.UTF_8) + "&max=1";
        List<Map<String, Object>> events = restClient.get()
            .uri(url)
            .header(HttpHeaders.AUTHORIZATION, "Bearer " + getAdminToken())
            .retrieve()
            .body(new ParameterizedTypeReference<List<Map<String, Object>>>() {});
        if (events == null || events.isEmpty()) return null;
        Object time = events.get(0).get("time");
        if (time == null) return null;
        return LocalDateTime.ofInstant(Instant.ofEpochMilli(((Number) time).longValue()), java.time.ZoneOffset.UTC);
    }

    private void putUser(String userId, Map<String, Object> userRepresentation) {
        String url = adminUrl + "/admin/realms/" + realm + "/users/" + userId;
        restClient.put()
            .uri(url)
            .header(HttpHeaders.AUTHORIZATION, "Bearer " + getAdminToken())
            .contentType(MediaType.APPLICATION_JSON)
            .body(userRepresentation)
            .retrieve()
            .toBodilessEntity();
    }
}
