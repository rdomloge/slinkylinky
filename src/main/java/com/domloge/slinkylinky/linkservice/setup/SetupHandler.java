package com.domloge.slinkylinky.linkservice.setup;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.linkservice.entity.Blogger;
import com.domloge.slinkylinky.linkservice.entity.Category;

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
        setupBloggers();
        setupHistory();
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

    private void setupBloggers() {
        List<Blogger> bloggers = loader.loadObjectList(Blogger.class, "bloggers.csv");
        log.info("Found {} bloggers in CSV", bloggers.size());
        bloggers.stream().forEach(b -> setupService.persist(b));
        
    }
}
