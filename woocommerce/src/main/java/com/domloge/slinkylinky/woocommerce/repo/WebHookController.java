package com.domloge.slinkylinky.woocommerce.repo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.domloge.slinkylinky.woocommerce.sync.OrderSync;

import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping(".rest/orders")
@Slf4j
public class WebHookController {

    @Autowired
    private OrderSync orderSync;
    

    @RequestMapping(path = "/webhooks/ordercreated", produces = "application/json")
    public ResponseEntity<Object> whOrderCreated() {
        log.info("Webhook:: Order created");
        Thread t = new Thread(() -> {
            try {
                orderSync.syncOrders();
            } 
            catch (Exception e) {
                log.error("Could not sync orders", e);
            }
        });
        t.start();
        return ResponseEntity.ok().build();
    }
}
