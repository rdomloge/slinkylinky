package com.domloge.slinkylinky.woocommerce.sync;

import java.io.IOException;
import java.util.Arrays;

import org.apache.hc.client5.http.classic.methods.HttpGet;
import org.apache.hc.client5.http.impl.classic.CloseableHttpClient;
import org.apache.hc.client5.http.impl.classic.HttpClients;
import org.apache.hc.core5.http.HttpEntity;
import org.apache.hc.core5.http.io.entity.EntityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.woocommerce.dto.OrderDto;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class CronJob {

    @Autowired
    private CommercePortalFacade commercePortalFacade;

    @Autowired
    private OrderProcessor orderProcessor;
    
    private ObjectMapper mapper = new ObjectMapper();

    
    public CronJob() {
        mapper.registerModule(new JavaTimeModule());
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        mapper.setSerializationInclusion(Include.NON_NULL);
        mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
    }
    
    @PostConstruct
    @Scheduled(cron = "0 */10 * * * *")
    public void syncOrders() throws IOException {
        log.info("Syncing orders");
        String json = commercePortalFacade.getOrders(0);
        OrderDto[] orders = mapper.readValue(json, OrderDto[].class);
        log.info("Processing {} orders", orders.length);
        Arrays.stream(orders).forEach(o -> {
            try {
                orderProcessor.process(o, json);
            } 
            catch (IOException e) {
                log.error("Could not process order "+o.getId(), e);
            }
        });
        log.info("Sync complete");
    }
}
