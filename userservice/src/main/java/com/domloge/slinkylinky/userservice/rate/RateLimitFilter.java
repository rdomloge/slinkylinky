package com.domloge.slinkylinky.userservice.rate;

import java.time.Duration;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

import org.springframework.stereotype.Component;

import io.github.bucket4j.Bandwidth;
import io.github.bucket4j.Bucket;
import jakarta.servlet.http.HttpServletRequest;

/**
 * Bucket4j-backed rate limiter for the public registration endpoint.
 * Three independent axes: per client IP, per email address, and a global cap.
 */
@Component
public class RateLimitFilter {

    private static final long IP_CAPACITY      = 5;
    private static final long EMAIL_CAPACITY   = 5;
    private static final long GLOBAL_CAPACITY  = 200;
    private static final Duration WINDOW       = Duration.ofHours(1);

    private final ConcurrentMap<String, Bucket> ipBuckets    = new ConcurrentHashMap<>();
    private final ConcurrentMap<String, Bucket> emailBuckets = new ConcurrentHashMap<>();
    private final Bucket globalBucket = buildBucket(GLOBAL_CAPACITY);

    /**
     * Attempts to consume one token from each rate-limit axis.
     * Per-axis limits (IP, email) are checked before the global bucket so that
     * requests blocked by a per-axis limit do not consume a global token.
     * Returns false (and the caller must reply 429) if any axis is exhausted.
     */
    public boolean tryAcquire(HttpServletRequest request, String normalisedEmail) {
        String ip = resolveClientIp(request);
        Bucket ipBucket    = ipBuckets.computeIfAbsent(ip, k -> buildBucket(IP_CAPACITY));
        Bucket emailBucket = emailBuckets.computeIfAbsent(normalisedEmail, k -> buildBucket(EMAIL_CAPACITY));
        if (!ipBucket.tryConsume(1))    return false;
        if (!emailBucket.tryConsume(1)) return false;
        return globalBucket.tryConsume(1);
    }

    /**
     * Extracts the real client IP from X-Forwarded-For (last entry, as set by Cloudflare)
     * with a fallback to the servlet remote address.
     */
    public String resolveClientIp(HttpServletRequest request) {
        String xff = request.getHeader("X-Forwarded-For");
        if (xff != null && !xff.isBlank()) {
            String[] parts = xff.split(",");
            return parts[parts.length - 1].trim();
        }
        return request.getRemoteAddr();
    }

    private Bucket buildBucket(long capacity) {
        Bandwidth limit = Bandwidth.builder()
            .capacity(capacity)
            .refillIntervally(capacity, WINDOW)
            .build();
        return Bucket.builder().addLimit(limit).build();
    }
}
