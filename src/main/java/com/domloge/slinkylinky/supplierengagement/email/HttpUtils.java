package com.domloge.slinkylinky.supplierengagement.email;

import java.io.IOException;

import org.apache.hc.client5.http.classic.methods.HttpGet;
import org.apache.hc.client5.http.classic.methods.HttpPost;
import org.apache.hc.client5.http.impl.classic.CloseableHttpClient;
import org.apache.hc.client5.http.impl.classic.CloseableHttpResponse;
import org.apache.hc.client5.http.impl.classic.HttpClients;
import org.apache.hc.core5.http.ContentType;
import org.apache.hc.core5.http.HttpEntity;
import org.apache.hc.core5.http.ParseException;
import org.apache.hc.core5.http.ProtocolException;
import org.apache.hc.core5.http.io.entity.EntityUtils;
import org.apache.hc.core5.http.io.entity.StringEntity;
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

    private ObjectMapper mapper = new ObjectMapper();

    public HttpUtils() {
        mapper.registerModule(new JavaTimeModule());
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        mapper.setSerializationInclusion(Include.NON_NULL);
        mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
    }

    
    public String get(String url) throws IOException {
        String resultContent = null;
        HttpGet httpGet = new HttpGet(url);
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

    public Proposal loadProposalDemandDomains(long proposalId) throws IOException {
        String url = linkService_base + "/proposals/" + proposalId + "?projection=fullProposal";
        String response = get(url);
        if(null == response) {
            log.error("Error fetching proposal {}", proposalId);
            throw new RuntimeException("Could not find proposal " + proposalId);
        }
        return mapper.readValue(response, Proposal.class);
    }
}
