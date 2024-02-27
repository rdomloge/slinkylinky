package com.domloge.slinkylinky.woocommerce.sync;

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
import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class HttpUtils {
    
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

    public String postForLocation(String url, String json) throws IOException {
        HttpPost httpPost = new HttpPost(url);
        httpPost.setEntity(new StringEntity(json, ContentType.APPLICATION_JSON));
        try (CloseableHttpClient httpclient = HttpClients.createDefault()) {
            try (CloseableHttpResponse response = httpclient.execute(httpPost)) {
                try {
                    String body = EntityUtils.toString(response.getEntity());
                    if(response.getCode() != 201) {
                        throw new IOException("Failed to post to " + url + " - " + response.getCode() + " - " + response.getReasonPhrase() + " - " + body);
                    }
                    return response.getHeader("Location").getValue();
                }
                catch (ProtocolException e) {
                    throw new IOException("Failed to post to " + url + " - " + response.getCode() + " - " + response.getReasonPhrase() + " - <error parsing body>");
                }
            }
        }
    }
}
