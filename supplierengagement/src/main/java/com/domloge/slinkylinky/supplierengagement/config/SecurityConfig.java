package com.domloge.slinkylinky.supplierengagement.config;

import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationConverter;
import org.springframework.security.oauth2.server.resource.authentication.JwtGrantedAuthoritiesConverter;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

@Configuration
@EnableMethodSecurity
public class SecurityConfig {

    private static final AntPathRequestMatcher[] AUTH_WHITELIST = {
        new AntPathRequestMatcher("/actuator/**"),
        new AntPathRequestMatcher("/.rest/engagements/accept"),
        new AntPathRequestMatcher("/.rest/engagements/decline"),
        new AntPathRequestMatcher("/.rest/engagements/search/findByGuid"),
        new AntPathRequestMatcher("/.rest/leads/response"),
        new AntPathRequestMatcher("/.rest/leads/accept"),
        new AntPathRequestMatcher("/.rest/leads/decline"),
        new AntPathRequestMatcher("/error")  // Spring Boot dispatches here on controller exceptions; must be public or error responses become 401
    };

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .authorizeHttpRequests(authorize -> authorize
                                .requestMatchers(AUTH_WHITELIST).permitAll()
                                .anyRequest().authenticated()
                )
                .oauth2ResourceServer(oauth2 -> oauth2
                                .jwt(jwt -> jwt.jwtAuthenticationConverter(jwtAuthenticationConverter()))
                )
                .csrf(csrf -> csrf.disable()); // stateless JWT API — CSRF attacks require cookies, not Bearer tokens
        return http.build();
    }

    /**
     * Maps Keycloak realm roles from the JWT {@code realm_access.roles} claim to
     * Spring Security {@code GrantedAuthority} objects with a {@code ROLE_} prefix.
     * This enables {@code @PreAuthorize("hasRole('global_admin')")} checks.
     */
    @Bean
    public JwtAuthenticationConverter jwtAuthenticationConverter() {
        JwtAuthenticationConverter converter = new JwtAuthenticationConverter();
        converter.setJwtGrantedAuthoritiesConverter(jwt -> {
            // Include standard scope-based authorities
            JwtGrantedAuthoritiesConverter scopeConverter = new JwtGrantedAuthoritiesConverter();
            Collection<GrantedAuthority> scopeAuthorities = scopeConverter.convert(jwt);

            // Also extract realm_access.roles from Keycloak JWT
            Collection<GrantedAuthority> realmRoles = extractRealmRoles(jwt);

            return java.util.stream.Stream.concat(
                    scopeAuthorities != null ? scopeAuthorities.stream() : java.util.stream.Stream.empty(),
                    realmRoles.stream()
            ).collect(Collectors.toList());
        });
        return converter;
    }

    @SuppressWarnings("unchecked")
    private Collection<GrantedAuthority> extractRealmRoles(Jwt jwt) {
        Map<String, Object> realmAccess = jwt.getClaimAsMap("realm_access");
        if (realmAccess == null) return Collections.emptyList();
        Object rolesObj = realmAccess.get("roles");
        if (!(rolesObj instanceof List)) return Collections.emptyList();
        return ((List<String>) rolesObj).stream()
                .map(role -> new SimpleGrantedAuthority("ROLE_" + role))
                .collect(Collectors.toList());
    }
}