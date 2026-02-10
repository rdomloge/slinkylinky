package com.domloge.slinkylinky.linkservice.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class SecurityConfig {
    private static final String[] AUTH_WHITELIST = {"/actuator/**", "/.rest/proposalsupport/getArticleFormatted"};

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(authorize -> authorize
                .requestMatchers(AUTH_WHITELIST).permitAll()
                .anyRequest().authenticated()
            )
            .oauth2ResourceServer(oauth2 -> oauth2
                .jwt(Customizer.withDefaults())
            );

        http.headers(headers -> headers.frameOptions(Customizer.withDefaults()).disable()); //disable x-frame-options for all endpoints so they can be iframed in browser iframes
        return http.build();
    }
}
