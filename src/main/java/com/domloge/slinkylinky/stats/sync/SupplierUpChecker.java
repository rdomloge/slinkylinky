package com.domloge.slinkylinky.stats.sync;

import java.io.IOException;
import java.net.UnknownHostException;

import org.apache.hc.client5.http.classic.methods.HttpGet;
import org.apache.hc.client5.http.config.RequestConfig;
import org.apache.hc.client5.http.impl.classic.CloseableHttpClient;
import org.apache.hc.client5.http.impl.classic.HttpClients;
import org.apache.hc.core5.http.ClassicHttpResponse;
import org.apache.hc.core5.http.HttpEntity;
import org.apache.hc.core5.http.ProtocolException;
import org.apache.hc.core5.util.Timeout;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.stats.dto.Supplier;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class SupplierUpChecker {

    public static final String userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3";

    public boolean isSupplierUp(Supplier s) {
        String website = fixProtocolIfNeeded(addWwwIfNeeded(s.getDomain()));
        log.trace("Supplier {} '{}' website maps to {}", s.getDomain(), s.getId(), website);
        
        try {
            return get(website, 0);
        }
        catch(UnknownHostException e) {
            log.error("Unknown host: {}", website);
            return false;
        } 
        catch (IOException e) {
            log.error("An unexpected error occurred while checking supplier {} '{}': {}", s.getDomain(), s.getId(), e.getMessage());
            return false;
        }
    }

    private boolean get(String website, int redirectCount) throws IOException {
        if(redirectCount > 5) {
            throw new IOException("Too many redirects");
        }
        
        HttpGet httpGet = new HttpGet(website);
        RequestConfig.Builder requestConfig = RequestConfig.custom();
        requestConfig.setConnectionRequestTimeout(Timeout.ofSeconds(3));
        requestConfig.setResponseTimeout(Timeout.ofSeconds(3));
        requestConfig.setConnectTimeout(Timeout.ofSeconds(3));

        httpGet.setConfig(requestConfig.build());

        
        try (CloseableHttpClient httpclient = HttpClients.custom().setUserAgent(userAgent).build()) {
            ClassicHttpResponse response = httpclient.execute(httpGet, resp -> {
                return resp;
            });
            // Get status code
            log.trace("Response version: {}", response.getVersion());
            log.trace("Response code: {}", response.getCode());
            log.trace("Response reason phrase: {}", response.getReasonPhrase());
            if(response.getCode() == 301) {
                try {
                    String redirectLocation = response.getHeader("Location").getValue();
                    log.debug("Following redirect {} from {} to {}", redirectCount, website, redirectLocation);
                    return get(redirectLocation, ++redirectCount);
                } catch (ProtocolException | IOException e) {
                    throw new IOException("Error while following redirect", e);
                }
            }
            HttpEntity entity = response.getEntity();
            // Get response information
            if(response.getCode() == 200) return true;
            
            log.error("Return code {} from {}", response.getCode(), website);
            return false; // need to dig into response to find out why it's not 200 (forbidden, not found, etc. or maybe need user agent?)
            
        }
    }

    private String fixProtocolIfNeeded(String domain) {
        if (!domain.startsWith("http://") && !domain.startsWith("https://")) {
            return "https://" + domain;
        }

        return domain;
    }

    private static String addWwwIfNeeded(String domain) {
        if (!domain.startsWith("www.")) {
            return "www." + domain;
        }

        return domain;
    }


}
