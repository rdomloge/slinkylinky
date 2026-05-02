package com.domloge.slinkylinky.linkservice.controller;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.TimeUnit;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import com.domloge.slinkylinky.common.TenantContext;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/.rest/admin")
public class HealthAggregatorController {

    private static final int TIMEOUT_SECONDS = 5;

    private static final Map<String, String> SERVICES = Map.of(
        "linkservice",        "http://linkservice-service:8090/actuator/health",
        "stats",              "http://stats-service:8093/actuator/health",
        "audit",              "http://audit-service:8092/actuator/health",
        "supplierengagement", "http://supplierengagement-service:8091/actuator/health",
        "userservice",        "http://userservice-service:8095/actuator/health"
    );

    private final HttpClient httpClient = HttpClient.newBuilder()
        .connectTimeout(Duration.ofSeconds(TIMEOUT_SECONDS))
        .build();

    private final ObjectMapper objectMapper = new ObjectMapper();

    @GetMapping("/tenant-health")
    public ResponseEntity<List<Map<String, Object>>> tenantHealth() {
        if (!TenantContext.isTenantAdmin() && !TenantContext.isGlobalAdmin()) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Requires tenant_admin or global_admin role");
        }

        List<CompletableFuture<Map<String, Object>>> futures = SERVICES.entrySet().stream()
            .map(entry -> CompletableFuture.supplyAsync(() -> probe(entry.getKey(), entry.getValue())))
            .toList();

        List<Map<String, Object>> results = futures.stream()
            .map(f -> {
                try {
                    return f.get(TIMEOUT_SECONDS + 1, TimeUnit.SECONDS);
                } catch (Exception e) {
                    return Map.<String, Object>of("service", "unknown", "status", "TIMEOUT");
                }
            })
            .toList();

        return ResponseEntity.ok(results);
    }

    private Map<String, Object> probe(String name, String url) {
        try {
            HttpRequest req = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .timeout(Duration.ofSeconds(TIMEOUT_SECONDS))
                .GET()
                .build();

            HttpResponse<String> response = httpClient.send(req, HttpResponse.BodyHandlers.ofString());

            String status = "UNKNOWN";
            String version = null;

            try {
                JsonNode body = objectMapper.readTree(response.body());
                status = body.path("status").asText("UNKNOWN");
                version = body.path("components").path("diskSpace").path("details").path("free").asText(null);
            } catch (Exception parseEx) {
                log.debug("Could not parse health response from {}: {}", name, parseEx.getMessage());
            }

            if (response.statusCode() >= 200 && response.statusCode() < 300) {
                status = "UP".equals(status) ? "UP" : "DEGRADED";
            } else {
                status = "DOWN";
            }

            return Map.of("service", name, "status", status);

        } catch (Exception e) {
            log.debug("Health probe failed for {}: {}", name, e.getMessage());
            return Map.of("service", name, "status", "DOWN");
        }
    }
}
