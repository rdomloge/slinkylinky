package com.domloge.slinkylinky.stats.config;

import java.util.List;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.oauth2.server.resource.web.BearerTokenAuthenticationFilter;
import org.springframework.security.web.SecurityFilterChain;

import com.domloge.slinkylinky.common.EmailVerifiedFilter;

@Configuration
public class SecurityConfig {
    private static final String[] AUTH_WHITELIST = {"/actuator/**"};

    private static final List<String> EMAIL_VERIFIED_EXEMPT = List.of("/actuator/**");

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
            .addFilterAfter(new EmailVerifiedFilter(EMAIL_VERIFIED_EXEMPT),
                            BearerTokenAuthenticationFilter.class);
        return http.build();
    }
}
