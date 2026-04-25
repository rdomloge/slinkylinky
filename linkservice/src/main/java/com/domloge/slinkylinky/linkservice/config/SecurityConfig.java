package com.domloge.slinkylinky.linkservice.config;

import java.util.List;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.oauth2.server.resource.web.BearerTokenAuthenticationFilter;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

import com.domloge.slinkylinky.common.EmailVerifiedFilter;

@Configuration
public class SecurityConfig {
    private static final AntPathRequestMatcher[] AUTH_WHITELIST = {
        new AntPathRequestMatcher("/actuator/**"),
        new AntPathRequestMatcher("/.rest/proposalsupport/getArticleFormatted"),
        new AntPathRequestMatcher("/error")
    };

    private static final List<String> EMAIL_VERIFIED_EXEMPT = List.of(
        "/actuator/**",
        "/error",
        "/.rest/proposalsupport/getArticleFormatted"
    );

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
            .csrf(csrf -> csrf.disable()) // stateless JWT API — CSRF attacks require cookies, not Bearer tokens
            .addFilterAfter(new EmailVerifiedFilter(EMAIL_VERIFIED_EXEMPT),
                            BearerTokenAuthenticationFilter.class);

        http.headers(headers -> headers.frameOptions(Customizer.withDefaults()).disable()); //disable x-frame-options for all endpoints so they can be iframed in browser iframes
        return http.build();
    }
}
