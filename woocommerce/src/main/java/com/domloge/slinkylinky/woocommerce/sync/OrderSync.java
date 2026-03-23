package com.domloge.slinkylinky.woocommerce.sync;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.woocommerce.dto.OrderDto;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class OrderSync {

    @Autowired
    private CommercePortalFacade commercePortalFacade;

    @Autowired
    private OrderProcessor orderProcessor;
    
    
    public void syncOrders() throws IOException {
        log.info("Syncing orders");
        int page = 1;
        OrderJsonWrapper wrapper = commercePortalFacade.getOrders(page);
        while(wrapper.getOrders().length > 0) {
            log.info("Processing {} orders from page {}", wrapper.getOrders().length, page);
            for(OrderDto order : wrapper.getOrders()) {
                try {
                    orderProcessor.process(order, wrapper.getJson());
                } 
                catch (IOException e) {
                    log.error("Could not process order "+order.getId(), e);
                }
            }
            page++;
            wrapper = commercePortalFacade.getOrders(page);
        }
        
        log.info("Sync complete - page {} had no orders", page);
    }
}
