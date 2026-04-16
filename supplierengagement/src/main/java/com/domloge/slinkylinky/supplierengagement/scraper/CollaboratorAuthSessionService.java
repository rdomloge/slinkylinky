package com.domloge.slinkylinky.supplierengagement.scraper;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.time.Duration;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.slf4j.Slf4j;

/**
 * Short-lived broker for collaborator.pro authenticated sessions used by lead scraping.
 *
 * <p>Sessions are created from manually imported Cookie headers that are validated
 * against collaborator.pro before being accepted for scraping.</p>
 */
@Service
@Slf4j
public class CollaboratorAuthSessionService {

    private static final String CATALOG_URL = "https://collaborator.pro/catalog/creator/article";
    private static final String API_URL = "https://collaborator.pro/catalog/api/data/load";
    private static final String USER_AGENT =
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 " +
            "(KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36";
    private static final Duration SESSION_TTL = Duration.ofMinutes(15);
    private static final List<String> AUTH_COOKIE_HINTS = List.of("_identity-user", "PHPSESSID", "cf_clearance");
    private static final int MAX_COOKIE_HEADER_LENGTH = 16_000;

    private final ConcurrentMap<String, SessionState> sessions = new ConcurrentHashMap<>();
    private final ObjectMapper mapper = new ObjectMapper();

    @Value("${collaborator.project.id:128180}")
    private String projectId;

    public SessionSnapshot importCookies(String rawCookieHeader, String importedBy) {
        String sanitized = sanitizeCookieHeader(rawCookieHeader);
        if (!StringUtils.hasText(sanitized)) {
            return new SessionSnapshot(null, "FAILED", "Cookie header is required", null);
        }
        if (sanitized.length() > MAX_COOKIE_HEADER_LENGTH) {
            return new SessionSnapshot(null, "FAILED", "Cookie header is too large", null);
        }

        List<String> names = cookieNames(sanitized);
        if (names.isEmpty()) {
            return new SessionSnapshot(null, "FAILED", "Cookie header format is invalid", null);
        }
        if (!containsAuthCookieHints(names)) {
            return new SessionSnapshot(null, "FAILED", "Cookie header does not include expected auth cookies", null);
        }

        ValidationResult validation = validateCookies(sanitized);
        if (!validation.accepted) {
            return new SessionSnapshot(
                null,
                "FAILED",
                "Imported cookies were rejected"
                    + " (http=" + validation.httpStatus
                    + ", apiStatus=" + validation.apiStatus
                    + ", statusCode=" + validation.apiStatusCode + ")",
                null
            );
        }

        String id = UUID.randomUUID().toString();
        Instant now = Instant.now();
        SessionState state = new SessionState(id, now, now.plus(SESSION_TTL));
        state.cookies = sanitized;
        state.status = "AUTHENTICATED";
        state.importedBy = StringUtils.hasText(importedBy) ? importedBy : "unknown";
        sessions.put(id, state);

        log.info("Collaborator cookies imported for session {} by {} (fingerprint={}, names={})",
            shortId(id), state.importedBy, cookieFingerprint(sanitized), names);
        return snapshot(state);
    }

    public SessionSnapshot getStatus(String authSessionId) {
        SessionState state = sessions.get(authSessionId);
        if (state == null) {
            return new SessionSnapshot(authSessionId, "EXPIRED", "Session not found or expired", null);
        }
        if (Instant.now().isAfter(state.expiresAt)) {
            state.status = "EXPIRED";
            state.errorMessage = "Session expired";
        }
        return snapshot(state);
    }

    public String consumeCookies(String authSessionId) {
        SessionState state = sessions.get(authSessionId);
        if (state == null) return null;
        if (Instant.now().isAfter(state.expiresAt)) {
            state.status = "EXPIRED";
            state.errorMessage = "Session expired";
            return null;
        }
        if (!"AUTHENTICATED".equals(state.status) || !StringUtils.hasText(state.cookies)) {
            return null;
        }
        return state.cookies;
    }

    @Scheduled(fixedDelay = 60_000)
    public void cleanupExpiredSessions() {
        Instant now = Instant.now();
        sessions.entrySet().removeIf(e -> now.isAfter(e.getValue().expiresAt.plus(Duration.ofMinutes(5))));
    }

    private ValidationResult validateCookies(String cookieHeader) {
        if (!StringUtils.hasText(cookieHeader)) {
            return ValidationResult.failure(-1, false, -1, "no-cookie-header");
        }
        try {
            String url = API_URL + "?project_id=" + projectId + "&page=1&per-page=1";
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(url))
                    .header("Cookie", cookieHeader)
                    .header("User-Agent", USER_AGENT)
                    .header("Accept", "application/json")
                    .header("Origin", "https://collaborator.pro")
                    .header("X-Requested-With", "XMLHttpRequest")
                    .header("Referer", CATALOG_URL + "?project_id=" + projectId)
                    .GET()
                    .build();

            HttpResponse<String> response = HttpClient.newBuilder()
                    .followRedirects(HttpClient.Redirect.NORMAL)
                    .build()
                    .send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() != 200) {
                return ValidationResult.failure(response.statusCode(), false, -1, trim(response.body()));
            }
            JsonNode root = mapper.readTree(response.body());
            boolean apiStatus = root.path("status").asBoolean(false);
            int statusCode = root.path("statusCode").asInt(-1);
            if (!apiStatus) {
                return ValidationResult.failure(response.statusCode(), false, statusCode, trim(response.body()));
            }
            return ValidationResult.success(response.statusCode(), true, statusCode, "ok");
        } catch (Exception e) {
            return ValidationResult.failure(-1, false, -1, "validation-exception:" + e.getClass().getSimpleName());
        }
    }

    private boolean containsAuthCookieHints(List<String> cookieNames) {
        return cookieNames.stream().anyMatch(name -> AUTH_COOKIE_HINTS.stream().anyMatch(name::contains));
    }

    private List<String> cookieNames(String cookieHeader) {
        List<String> result = new ArrayList<>();
        String[] parts = cookieHeader.split(";");
        for (String part : parts) {
            String trimmed = part.trim();
            int idx = trimmed.indexOf('=');
            if (idx > 0) {
                result.add(trimmed.substring(0, idx));
            }
        }
        return result;
    }

    private String trim(String value) {
        if (value == null) return "";
        String compact = value.replace('\n', ' ').replace('\r', ' ').trim();
        return compact.length() > 180 ? compact.substring(0, 180) + "..." : compact;
    }

    private String sanitizeCookieHeader(String value) {
        if (value == null) return null;
        String compact = value.replace('\n', ' ').replace('\r', ' ').trim();
        if (!StringUtils.hasText(compact)) return null;
        String[] pairs = compact.split(";");
        List<String> normalized = new ArrayList<>();
        for (String pair : pairs) {
            String p = pair.trim();
            if (!StringUtils.hasText(p)) continue;
            int idx = p.indexOf('=');
            if (idx <= 0) {
                return null;
            }
            String name = p.substring(0, idx).trim();
            String cookieValue = p.substring(idx + 1).trim();
            if (!StringUtils.hasText(name) || cookieValue == null) {
                return null;
            }
            normalized.add(name + "=" + cookieValue);
        }
        if (normalized.isEmpty()) return null;
        return String.join("; ", normalized);
    }

    private String cookieFingerprint(String cookieHeader) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(cookieHeader.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < 8 && i < hash.length; i++) {
                sb.append(String.format("%02x", hash[i]));
            }
            return sb.toString();
        } catch (Exception e) {
            return "unavailable";
        }
    }

    private String shortId(String id) {
        if (id == null || id.length() < 8) return id;
        return id.substring(0, 8);
    }

    private SessionSnapshot snapshot(SessionState state) {
        return new SessionSnapshot(state.id, state.status, state.errorMessage, state.expiresAt.toString());
    }

    private static class ValidationResult {
        final boolean accepted;
        final int httpStatus;
        final boolean apiStatus;
        final int apiStatusCode;
        final String bodySnippet;

        private ValidationResult(boolean accepted, int httpStatus, boolean apiStatus, int apiStatusCode, String bodySnippet) {
            this.accepted = accepted;
            this.httpStatus = httpStatus;
            this.apiStatus = apiStatus;
            this.apiStatusCode = apiStatusCode;
            this.bodySnippet = bodySnippet;
        }

        static ValidationResult success(int httpStatus, boolean apiStatus, int apiStatusCode, String bodySnippet) {
            return new ValidationResult(true, httpStatus, apiStatus, apiStatusCode, bodySnippet);
        }

        static ValidationResult failure(int httpStatus, boolean apiStatus, int apiStatusCode, String bodySnippet) {
            return new ValidationResult(false, httpStatus, apiStatus, apiStatusCode, bodySnippet);
        }
    }

    private static class SessionState {
        final String id;
        final Instant createdAt;
        final Instant expiresAt;
        volatile String status;
        volatile String errorMessage;
        volatile String cookies;
        volatile String importedBy;

        SessionState(String id, Instant createdAt, Instant expiresAt) {
            this.id = id;
            this.createdAt = createdAt;
            this.expiresAt = expiresAt;
            this.status = "PENDING";
        }
    }

    public static class SessionSnapshot {
        private final String authSessionId;
        private final String status;
        private final String errorMessage;
        private final String expiresAt;

        public SessionSnapshot(String authSessionId, String status, String errorMessage, String expiresAt) {
            this.authSessionId = authSessionId;
            this.status = status;
            this.errorMessage = errorMessage;
            this.expiresAt = expiresAt;
        }

        public String getAuthSessionId() {
            return authSessionId;
        }

        public String getStatus() {
            return status;
        }

        public String getErrorMessage() {
            return errorMessage;
        }

        public String getExpiresAt() {
            return expiresAt;
        }
    }
}