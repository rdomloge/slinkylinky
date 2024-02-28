package com.domloge.slinkylinky.woocommerce.sync;

import java.io.IOException;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

import org.apache.hc.client5.http.classic.methods.HttpGet;
import org.apache.hc.client5.http.classic.methods.HttpPut;
import org.apache.hc.client5.http.impl.classic.CloseableHttpClient;
import org.apache.hc.client5.http.impl.classic.HttpClients;
import org.apache.hc.core5.http.HttpEntity;
import org.apache.hc.core5.http.io.entity.EntityUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.woocommerce.dto.OrderDto;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import lombok.extern.slf4j.Slf4j;


@Slf4j
@Component
public class CommercePortalFacade { // we might change the name from LinkSync

    @Value("${wc.key}")
    private String wc_key;

    @Value("${wc.secret}")
    private String wc_secret;

    @Value("${wc.base_url:https://link-sync.co.uk/wp-json/wc/v3}")
    private String wc_base_url;

    @Value("${wc.user_agent:Mozilla/5.0}")
    private String userAgent;

    private ObjectMapper mapper = new ObjectMapper();


    public CommercePortalFacade() {
        mapper.registerModule(new JavaTimeModule());
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        mapper.setSerializationInclusion(Include.NON_NULL);
        mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
    }



    public OrderJsonWrapper getOrders(int page) throws IOException {
        HttpGet request = new HttpGet(wc_base_url+"/orders?status=processing");
        request.setHeader("Authorization",
            "Basic " + Base64.getEncoder().encodeToString((wc_key + ":" + wc_secret).getBytes())
        );

        try (CloseableHttpClient httpclient = HttpClients.custom().setUserAgent(userAgent).build()) {
            String json = httpclient.execute(request, resp -> {
                    HttpEntity entity = resp.getEntity();
                    return EntityUtils.toString(entity);
                });
            OrderDto[] orders = mapper.readValue(json, OrderDto[].class);
            return new OrderJsonWrapper(orders, json);
        }
    }

    public String completeOrder(long orderid) throws IOException {
        HttpPut request = new HttpPut(wc_base_url+"/orders/"+orderid);
        request.setHeader("Authorization",
            "Basic " + Base64.getEncoder().encodeToString((wc_key + ":" + wc_secret).getBytes())
        );
        request.setHeader("Content-Type", "application/json");

        Map<String,String> payload = new HashMap<>();
        payload.put("status", "completed");
        String payloadJson = new ObjectMapper().writeValueAsString(payload);
        log.debug("Sending payload {}", payloadJson);
        request.setEntity(new org.apache.hc.core5.http.io.entity.StringEntity(payloadJson));

        try (CloseableHttpClient httpclient = HttpClients.custom().setUserAgent(userAgent).build()) {
            String responseJson = httpclient.execute(request, resp -> {
                    HttpEntity entity = resp.getEntity();
                    if(resp.getCode() != 200) throw new IOException("Error completing order: "+EntityUtils.toString(entity));
                    return EntityUtils.toString(entity);
                });
            return responseJson;
        }
    }
}
