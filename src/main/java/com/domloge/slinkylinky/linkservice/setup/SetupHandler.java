package com.domloge.slinkylinky.linkservice.setup;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.linkservice.entity.Supplier;
import com.domloge.slinkylinky.linkservice.entity.Category;
import com.domloge.slinkylinky.linkservice.entity.LinkDemand;

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
    }
    

    private void setupDemand() {
        List<LinkDemand> demands = loader.loadObjectList(LinkDemand.class, "linkdemand.csv");
        log.info("Found {} demand in CSV", demands.size());
        demands.forEach(d -> setupService.persist(d));
    }


    private void setupHistory() {
        List<History> histories = loader.loadObjectList(History.class, "history.csv");
        log.info("Found {} histories in CSV", histories.size());
        Map<String, List<History>> map = new HashMap<>();
        histories.forEach( h -> {
            if( ! map.containsKey(h.getPostPlacement())) {
                map.put(h.getPostPlacement(), new LinkedList<>());
            }
            map.get(h.getPostPlacement()).add(h);
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
        List<Supplier> suppliers = loader.loadObjectList(Supplier.class, "bloggers.csv");
        log.info("Found {} suppliers in CSV", suppliers.size());
        suppliers.stream().forEach(b -> setupService.persist(b));
        
    }
}
