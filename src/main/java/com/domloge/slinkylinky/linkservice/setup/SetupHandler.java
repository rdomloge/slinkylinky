package com.domloge.slinkylinky.linkservice.setup;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.linkservice.entity.Blogger;
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
        setupBloggers();
        setupLinkDemands();
    }
    

    private void setupCategories() {
        List<Category> categories = loader.loadObjectList(Category.class, "categories.csv");
        log.info("Found {} categories in CSV", categories.size());
        categories.stream().forEach(c -> setupService.persist(c));
    }


    private void setupLinkDemands() {
        List<LinkDemand> linkDemands = loader.loadObjectList(LinkDemand.class, "linkdemand.csv");
        log.info("Found {} linkdemands in CSV", linkDemands.size());
        linkDemands.stream().forEach(c -> setupService.persist(c));
    }


    private void setupBloggers() {
        List<Blogger> bloggers = loader.loadObjectList(Blogger.class, "bloggers.csv");
        log.info("Found {} bloggers in CSV", bloggers.size());
        bloggers.stream().forEach(b -> setupService.persist(b));
        
    }
}
