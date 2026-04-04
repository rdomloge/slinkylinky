package com.domloge.slinkylinky.linkservice.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

@Configuration
public class SecurityConfig {
    private static final AntPathRequestMatcher[] AUTH_WHITELIST = {
        new AntPathRequestMatcher("/actuator/**"),
        new AntPathRequestMatcher("/.rest/proposalsupport/getArticleFormatted"),
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
                .jwt(Customizer.withDefaults())
            )
            .csrf(csrf -> csrf.disable()); // stateless JWT API — CSRF attacks require cookies, not Bearer tokens

        http.headers(headers -> headers.frameOptions(Customizer.withDefaults()).disable()); //disable x-frame-options for all endpoints so they can be iframed in browser iframes
        return http.build();
    }
}
