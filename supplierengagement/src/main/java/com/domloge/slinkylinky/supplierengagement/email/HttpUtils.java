package com.domloge.slinkylinky.supplierengagement.email;

import java.io.IOException;

import org.apache.hc.client5.http.classic.methods.HttpDelete;
import org.apache.hc.client5.http.classic.methods.HttpGet;
import org.apache.hc.client5.http.classic.methods.HttpPost;
import org.apache.hc.client5.http.impl.classic.CloseableHttpClient;
import org.apache.hc.client5.http.impl.classic.CloseableHttpResponse;
import org.apache.hc.client5.http.impl.classic.HttpClients;
import org.apache.hc.core5.http.HttpEntity;
import org.apache.hc.core5.http.ParseException;
import org.apache.hc.core5.http.io.entity.EntityUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class HttpUtils {

    @Value("${linkservice_baseurl}")
    private String linkService_base;

    @Value("${keycloak.clientcredentials.client.id}")
    private String clientId;
    @Value("${keycloak.clientcredentials.client.secret}")
    private String clientSecret;
    @Value("${keycloak.base.url}")
    private String keycloakBase;
    @Value("${keycloak.clientcredentials.token.uri}")
    private String tokenAccessUri;

    private ObjectMapper mapper = new ObjectMapper();

    public HttpUtils() {
        mapper.registerModule(new JavaTimeModule());
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        mapper.setSerializationInclusion(Include.NON_NULL);
        mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
    }

    public void abortProposal(long proposalId) throws IOException {
        String url = linkService_base + "/proposalsupport/abort?proposalId=" + proposalId;
        HttpDelete delete = new HttpDelete(url);
        delete.setHeader("user", "supplier-engagement-bot");
        try (CloseableHttpClient httpclient = HttpClients.createDefault()) {
            try (CloseableHttpResponse response = httpclient.execute(delete)) {
                if(response.getCode() != 200) {
                    throw new IOException("Failed to abort proposal " + proposalId + " - " + response.getCode());
                }
            }
        } 
    }

    

    static class AccessTokenResponse {
        private String access_token;
        public String getAccess_token() { return access_token; }
        public void setAccess_token(String access_token) { this.access_token = access_token; }
    }

    public String fetchAccessToken() throws IOException {
        String url = keycloakBase + tokenAccessUri;
        HttpPost post = new HttpPost(url);
        post.setHeader("Content-Type", "application/x-www-form-urlencoded");
        post.setHeader("Accept", "application/json");
        String body = "grant_type=client_credentials&client_id=" + clientId + "&client_secret=" + clientSecret;
        post.setEntity(new org.apache.hc.core5.http.io.entity.StringEntity(body, java.nio.charset.StandardCharsets.UTF_8));
        
        try (CloseableHttpClient httpclient = HttpClients.createDefault()) {    
            try (CloseableHttpResponse response = httpclient.execute(post)) {
                if(response.getCode() != 200) {
                    log.error("Failed to fetch access token - " + response.getCode());
                    throw new IOException("Failed to fetch access token - " + response.getCode());
                }
                else {
                    HttpEntity entity = response.getEntity();
                    String resultContent = EntityUtils.toString(entity);
                    AccessTokenResponse atr = mapper.readValue(resultContent, AccessTokenResponse.class);
                    log.debug("Fetched access token: {}", atr.getAccess_token());
                    return atr.getAccess_token();
                }
            }
        } 
        catch (ParseException e) {
            log.error("Failed to parse response from " + url, e);
            throw new IOException("Failed to parse response from " + url, e);
        }
    }
    
    public String get(String url) throws IOException {
        String resultContent = null;
        HttpGet httpGet = new HttpGet(url);
        String accessToken = fetchAccessToken();
        if(null != accessToken) {
            httpGet.setHeader("Authorization", "Bearer " + accessToken);
        }
        try (CloseableHttpClient httpclient = HttpClients.createDefault()) {
            try (CloseableHttpResponse response = httpclient.execute(httpGet)) {
                if(response.getCode() != 200) {
                    if(response.getCode() == 404) {
                        log.debug("URL not found: {}", url);
                    }
                    else
                        throw new IOException("Failed to fetch " + url + " - " + response.getCode());
                }
                else {
                    HttpEntity entity = response.getEntity();
                    try {
                        resultContent = EntityUtils.toString(entity);
                    } 
                    catch (ParseException e) {
                        throw new IOException("Failed to parse response from " + url, e);
                    }
                }
            }
        } 
        return resultContent;
    }

    public Proposal loadProposal(long proposalId) throws IOException {
        String url = linkService_base + "/proposals/" + proposalId + "?projection=fullProposal";
        String response = get(url);
        if(null == response) {
            log.error("Proposal {} not found (404)", proposalId);
            return null;
        }
        return mapper.readValue(response, Proposal.class);
    }
}
