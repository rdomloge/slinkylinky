package com.domloge.slinkylinky.common;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.util.AntPathMatcher;
import org.springframework.web.filter.OncePerRequestFilter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Blocks protected requests from users whose email has not been verified.
 * Reads the {@code email_verified} claim from the JWT in the current {@link SecurityContextHolder}.
 * Must be registered after the bearer-token authentication filter so the JWT is already parsed.
 *
 * <p>Construct with a list of exempt path patterns (Ant-style) that bypass the check —
 * always include {@code /actuator/**} and service-specific public endpoints.</p>
 */
public class EmailVerifiedFilter extends OncePerRequestFilter {

    private static final Logger log = LoggerFactory.getLogger(EmailVerifiedFilter.class);

    private final AntPathMatcher pathMatcher = new AntPathMatcher();
    private final List<String> exemptPaths;

    public EmailVerifiedFilter(List<String> exemptPaths) {
        this.exemptPaths = exemptPaths;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain chain)
            throws ServletException, IOException {

        String path = request.getRequestURI();
        for (String pattern : exemptPaths) {
            if (pathMatcher.match(pattern, path)) {
                chain.doFilter(request, response);
                return;
            }
        }

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth instanceof JwtAuthenticationToken jwtAuth) {
            String authorities = jwtAuth.getAuthorities().stream()
                .map(a -> a.getAuthority())
                .collect(Collectors.joining(", "));
            log.debug("EmailVerifiedFilter [{}] — authorities on token: [{}]", path, authorities);

            // Tokens carrying the 'internal_service' scope are machine-to-machine — no user email to verify
            boolean isServiceToken = jwtAuth.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("SCOPE_internal_service"));
            log.debug("EmailVerifiedFilter [{}] — isServiceToken: {}", path, isServiceToken);
            if (isServiceToken) {
                chain.doFilter(request, response);
                return;
            }
            Jwt jwt = jwtAuth.getToken();
            Boolean emailVerified = jwt.getClaimAsBoolean("email_verified");
            log.debug("EmailVerifiedFilter [{}] — email_verified claim: {}", path, emailVerified);
            if (emailVerified == null || !emailVerified) {
                writeForbidden(response);
                return;
            }
        } else {
            // No JWT token present — let Spring Security handle this (it will return 401 via
            // ExceptionTranslationFilter). This filter only acts when a JWT IS present but
            // email_verified is false.
            chain.doFilter(request, response);
            return;
        }

        chain.doFilter(request, response);
    }

    private void writeForbidden(HttpServletResponse response) throws IOException {
        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        response.setContentType("application/json");
        response.getWriter().write(
            "{\"code\":\"EMAIL_NOT_VERIFIED\"," +
            "\"message\":\"Please verify your email address before accessing this resource.\"}");
    }
}
