package com.domloge.slinkylinky.stats.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.domloge.slinkylinky.stats.sync.Sync;

import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping(".rest/syncwebhook")
@Slf4j
public class SyncWebhook {

    @Autowired
    private Sync sync;
    
    @RequestMapping("/sync")
    public void sync() {
        log.info("Webhook received, syncing");
        sync.syncAllSuppliers();
        log.info("Sync complete - webhook out!");
    }
}
