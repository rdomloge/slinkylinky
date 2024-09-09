package com.domloge.slinkylinky.woocommerce.sync;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Base64;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.TimeZone;

import org.apache.hc.client5.http.classic.methods.HttpGet;
import org.apache.hc.client5.http.classic.methods.HttpPut;
import org.apache.hc.client5.http.impl.classic.CloseableHttpClient;
import org.apache.hc.client5.http.impl.classic.HttpClients;
import org.apache.hc.core5.http.Header;
import org.apache.hc.core5.http.HttpEntity;
import org.apache.hc.core5.http.io.entity.EntityUtils;
import org.springframework.beans.factory.annotation.Autowired;
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

    @Value("${wc.base_url}")
    private String wc_base_url;

    @Value("${wc.uploads_base}")
    private String wc_uploads_base;

    @Value("${wc.user_agent:Mozilla/5.0}")
    private String userAgent;

    @Autowired
    private HttpUtils httpUtils;

    private ObjectMapper mapper = new ObjectMapper();


    public CommercePortalFacade() {
        mapper.registerModule(new JavaTimeModule());
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        mapper.setSerializationInclusion(Include.NON_NULL);
        mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
    }

    public String fetchLineItemCsv(OrderDto order) throws IOException {
        
        if(null == order.getDa_file()) {
            throw new IllegalStateException("CSV file URL missing from order.");
        }

        log.debug("Fetching CSV from {}", order.getDa_file());
        return httpUtils.get(order.getDa_file());
    }

    public OrderJsonWrapper getOrders(int page) throws IOException {
        String url = wc_base_url+"/orders?status=processing&page="+page+"&per_page=5";
        HttpGet request = new HttpGet(url);
        log.info("Fetching orders from {}", url);
        request.setHeader("Authorization",
            "Basic " + Base64.getEncoder().encodeToString((wc_key + ":" + wc_secret).getBytes())
        );

        try (CloseableHttpClient httpclient = HttpClients.custom().setUserAgent(userAgent).build()) {
            OrderJsonWrapper wrapper = httpclient.execute(request, resp -> {
                    HttpEntity entity = resp.getEntity();
                    Header totalPages = resp.getHeader("x-wp-totalpages");
                    
                    OrderDto[] orders = null;
                    String json = null;
                    if(Integer.parseInt(totalPages.getValue()) < page) {
                        orders = new OrderDto[0];
                        json = "[]";
                    }
                    else {
                        json = EntityUtils.toString(entity);
                        orders = mapper.readValue(json, OrderDto[].class);
                    }
                    return new OrderJsonWrapper(orders, json);
                });
            return wrapper;
        }
    }

    public String completeOrder(long orderid) throws IOException {
        String url = wc_base_url+"/orders/"+orderid;
        HttpPut request = new HttpPut(url);
        log.info("Completing order {} using {}", orderid, url);    
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
