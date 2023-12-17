package com.domloge.slinkylinky.linkservice.setup;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.linkservice.entity.Supplier;
import com.domloge.slinkylinky.linkservice.entity.Category;
import com.domloge.slinkylinky.linkservice.entity.Demand;

import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
public class SetupHandler {

    @Autowired
    private Loader loader;

    @Autowired
    private SetupService setupService;

    @PostConstruct
    private void setupData() {
        setupCategories();
        setupSuppliers();
        setupHistory();
        setupDemand();
        setupService.linkDemandsToTheirDemandSites();
    }
    

    private void setupDemand() {
        List<SetupDemand> demands = loader.loadObjectList(SetupDemand.class, "demand.csv");
        log.info("Found {} demand in CSV", demands.size());
        demands.forEach(d -> setupService.persist(d));
    }


    private void setupHistory() {
        List<History> histories = loader.loadObjectList(History.class, "history.csv");
        log.info("Found {} histories in CSV", histories.size());
        Map<String, List<History>> map = new HashMap<>();
        histories.forEach( h -> {
            if( ! map.containsKey(h.getPostPlacement()+h.getDelivered())) {
                map.put(h.getPostPlacement()+h.getDelivered(), new LinkedList<>());
            }
            map.get(h.getPostPlacement()+h.getDelivered()).add(h);
        });

        map.values().stream().forEach( 
            historiesWithMatchingPostPlacements -> setupService.persist(historiesWithMatchingPostPlacements));
    }

    private void setupCategories() {
        List<Category> categories = loader.loadObjectList(Category.class, "categories.csv");
        log.info("Found {} categories in CSV", categories.size());
        categories.stream().forEach(c -> setupService.persist(c));
    }

    private void setupSuppliers() {
        List<SetupSupplier> suppliers = loader.loadObjectList(SetupSupplier.class, "bloggers.csv");
        log.info("Found {} suppliers in CSV", suppliers.size());
        suppliers.stream().forEach(b -> setupService.persist(b));
        
    }
}
