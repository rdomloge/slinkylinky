package com.domloge.slinkylinky.stats.config;

import java.util.List;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.client.ClientHttpRequestInterceptor;
import org.springframework.web.client.RestTemplate;

@Configuration
public class Config {

    @Bean
    public RestTemplate restTemplate(KeycloakTokenProvider tokenProvider) {
        RestTemplate restTemplate = new RestTemplate();
        restTemplate.setInterceptors(List.of(bearerTokenInterceptor(tokenProvider)));
        return restTemplate;
    }

    private ClientHttpRequestInterceptor bearerTokenInterceptor(KeycloakTokenProvider tokenProvider) {
        return (request, body, execution) -> {
            String token = tokenProvider.fetchAccessToken();
            request.getHeaders().setBearerAuth(token);
            return execution.execute(request, body);
        };
    }
}
