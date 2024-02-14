package com.domloge.slinkylinky.stats.amqp;

import java.io.UnsupportedEncodingException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import com.domloge.slinkylinky.events.SupplierEvent;
import com.domloge.slinkylinky.stats.dto.Supplier;
import com.domloge.slinkylinky.stats.moz.DaChecker;
import com.domloge.slinkylinky.stats.moz.SpamChecker;
import com.domloge.slinkylinky.stats.repo.DaRepo;
import com.domloge.slinkylinky.stats.repo.SpamRepo;
import com.domloge.slinkylinky.stats.repo.TrafficRepo;
import com.domloge.slinkylinky.stats.semrush.Semrush;
import com.domloge.slinkylinky.stats.sync.LinkServiceUpdater;
import com.domloge.slinkylinky.stats.sync.Sync;
import com.domloge.slinkylinky.stats.sync.TransientSyncException;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
public class SupplierEventReceiver {

    @Autowired
    private Sync sync;

    @Autowired
    private TrafficRepo trafficRepo;

    @Autowired
    private Semrush semrush;

    @Autowired
    private DaRepo daRepo;

    @Autowired
    private SpamRepo spamRepo;

    @Autowired
    private DaChecker daChecker;

    @Autowired
    private SpamChecker spamChecker;

    @Autowired
    private LinkServiceUpdater linkServiceUpdater;

    
    
    private ObjectMapper mapper = new ObjectMapper();


    public SupplierEventReceiver(RestTemplate rest) {
        mapper.registerModule(new JavaTimeModule());
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        mapper.setSerializationInclusion(Include.NON_NULL);
    }

    public void receiveMessage(String message)  {
        log.trace("Received <" + message + ">");
        try {
            SupplierEvent event = mapper.readValue(message, SupplierEvent.class);
            if(event.getType() != SupplierEvent.EventType.CREATED) {
                log.warn("Received event of type {} which is not supported", event.getType());
                return;
            }
            String domain = event.getDomain();
            Supplier supplier = new Supplier();
            supplier.setDomain(domain);
            supplier.setId(event.getSupplierId());

            sync.syncSupplier(supplier, trafficRepo, semrush::forMonth, 12);

            int changeCount = sync.syncSupplier(supplier, daRepo, daChecker::forThisMonth, 1);
            if(changeCount > 0) {
                linkServiceUpdater.pushLatestDaToLinkservice(supplier);
            } else {
                log.debug("DA unchanged for {}", domain);
            }

            sync.syncSupplier(supplier, spamRepo, spamChecker::forThisMonth, 1);
        } 
        catch (JsonProcessingException e) {
            log.error("Failed to parse message {}: {} with {}", message, e.getClass().getSimpleName(), e.getMessage());
        } 
        catch (TransientSyncException e) {
            log.error("Could not call Moz API: {}", e.getMessage());
        }
    }

    

    public void receiveMessage(byte[] message)  {
        try {
            receiveMessage(new String(message, "utf-8"));
        } 
        catch (UnsupportedEncodingException e) {
            receiveMessage(new String(message));
        }
    }
}
