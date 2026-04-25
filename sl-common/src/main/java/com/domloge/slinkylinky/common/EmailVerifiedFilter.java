package com.domloge.slinkylinky.common;

import java.io.IOException;
import java.util.List;

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

/**
 * Blocks protected requests from users whose email has not been verified.
 * Reads the {@code email_verified} claim from the JWT in the current {@link SecurityContextHolder}.
 * Must be registered after the bearer-token authentication filter so the JWT is already parsed.
 *
 * <p>Construct with a list of exempt path patterns (Ant-style) that bypass the check —
 * always include {@code /actuator/**} and service-specific public endpoints.</p>
 */
public class EmailVerifiedFilter extends OncePerRequestFilter {

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
            Jwt jwt = jwtAuth.getToken();
            Boolean emailVerified = jwt.getClaimAsBoolean("email_verified");
            if (emailVerified == null || !emailVerified) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.setContentType("application/json");
                response.getWriter().write(
                    "{\"code\":\"EMAIL_NOT_VERIFIED\"," +
                    "\"message\":\"Please verify your email address before accessing this resource.\"}");
                return;
            }
        }

        chain.doFilter(request, response);
    }
}
