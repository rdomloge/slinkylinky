package com.domloge.slinkylinky.supplierengagement.config;

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
        new AntPathRequestMatcher("/.rest/engagements/accept"),
        new AntPathRequestMatcher("/.rest/engagements/decline"),
        new AntPathRequestMatcher("/.rest/engagements/search/findByGuid")
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
                .csrf(csrf -> csrf.ignoringRequestMatchers(AUTH_WHITELIST));
        return http.build();
    }
}