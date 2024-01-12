package com.domloge.slinkylinky.linkservice.ai;

import java.io.IOException;
import java.util.Optional;
import java.util.concurrent.TimeUnit;

import org.apache.hc.client5.http.config.RequestConfig;
import org.apache.hc.client5.http.impl.classic.CloseableHttpClient;
import org.apache.hc.client5.http.impl.classic.HttpClientBuilder;
import org.apache.hc.client5.http.impl.io.PoolingHttpClientConnectionManager;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.ClientHttpResponse;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.client.ResourceAccessException;
import org.springframework.web.client.ResponseErrorHandler;
import org.springframework.web.client.RestTemplate;

import com.google.gson.Gson;

import lombok.extern.slf4j.Slf4j;


@Slf4j
@Component
public class ChatGpt {

    @Value("${chatgpt.api.key}")
    private String chatGptApiKey;

    @Value("${chatgpt.url}")
    private String chatGptUrl;
    
    @Value("${chatgpt.temp}")
    private float chatGptTemp;

    @Value("${chatgpt.model}")
    private String chatGptModel;

    private RestTemplate restTemplate;


    public ChatGpt() {
        RestTemplateBuilder builder = new RestTemplateBuilder();
        builder.requestFactory(this::requestFactory);
        restTemplate = builder.build();
        restTemplate.setErrorHandler(new ResponseErrorHandler() {
            @Override
            public boolean hasError(ClientHttpResponse response) throws IOException {
                return false;
            }
            @Override
            public void handleError(ClientHttpResponse response) throws IOException {   
            } });
    }

    private HttpComponentsClientHttpRequestFactory requestFactory() {

        RequestConfig requestConfig = RequestConfig
            .custom()
            .setConnectionRequestTimeout(2, TimeUnit.SECONDS)
            .setResponseTimeout(2, TimeUnit.SECONDS)
            .build();

        PoolingHttpClientConnectionManager connectionManager = new PoolingHttpClientConnectionManager();
        connectionManager.setMaxTotal(5);
        connectionManager.setDefaultMaxPerRoute(5);

        CloseableHttpClient httpClient = HttpClientBuilder.create()
            .setConnectionManager(connectionManager)
            .setDefaultRequestConfig(requestConfig)
            .build();
        return new HttpComponentsClientHttpRequestFactory(httpClient);
    }

    public Optional<String> queryChatGpt(ChatGptMessage[] messages) {
        ChatGptPayload payload = new ChatGptPayload(chatGptModel, chatGptTemp, messages);
        String payloadStr = new Gson().toJson(payload);
        HttpEntity<String> request = new HttpEntity<>(payloadStr, generateHeaders());

        long start = System.currentTimeMillis();
        try {
            ResponseEntity<ChatCompletion> response = restTemplate.exchange(chatGptUrl, HttpMethod.POST, request, ChatCompletion.class);
            log.info("chatGPT took {}/ms", System.currentTimeMillis() - start);
            if(response.getStatusCode().is2xxSuccessful()) {
                log.debug("Fetched chat gpt response {}", response.getBody());
                return safelyPullOutChatGptResponse(response.getBody());
            } 
        }
        catch(ResourceAccessException ioex) {
            log.error("Could not access chatGPT. Lot {} will not have a response", ioex);
        }

        return Optional.empty();
    }

    private Optional<String> safelyPullOutChatGptResponse(ChatCompletion body) {
        return Optional.ofNullable(body)
            .map(x -> x.getChoices())
            .filter(x -> x.size() > 0)
            .map(x -> x.get(0))
            .map(x -> x.getMessage())
            .map(x -> x.getContent());
    }

    public HttpHeaders generateHeaders() {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBearerAuth(chatGptApiKey);
        return headers;
    }
}
