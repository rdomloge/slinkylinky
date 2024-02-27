package com.domloge.slinkylinky.woocommerce.repo;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.core.JsonProcessingException;

import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping(".rest/orders")
@Slf4j
public class WebHookController {
    

    @PostMapping(path = "/webhooks/ordercreated", produces = "application/json")
    public ResponseEntity<Object> whOrderCreated() {
        log.info("Webhook:: Order created");
        return ResponseEntity.ok().build();
    }
}
