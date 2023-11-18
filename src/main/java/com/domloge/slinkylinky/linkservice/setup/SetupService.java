package com.domloge.slinkylinky.linkservice.setup;

import java.util.LinkedList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.domloge.slinkylinky.linkservice.entity.Blogger;
import com.domloge.slinkylinky.linkservice.entity.Category;
import com.domloge.slinkylinky.linkservice.entity.LinkDemand;
import com.domloge.slinkylinky.linkservice.repo.BloggerRepo;
import com.domloge.slinkylinky.linkservice.repo.CategoryRepo;
import com.domloge.slinkylinky.linkservice.repo.LinkDemandRepo;

import jakarta.transaction.Transactional;

@Service
public class SetupService {

    @Autowired
    private BloggerRepo bloggerRepo;

    @Autowired
    private LinkDemandRepo clientRepo;

    @Autowired
    private CategoryRepo categoryRepo;
    
    @Transactional
    public void persist(Blogger b) {
        List<Category> bloggerCategories = b.getCategories();
        List<Category> dbCategories = new LinkedList<>();

        bloggerCategories.forEach(bc -> dbCategories.add(categoryRepo.findByName(bc.getName())));
        b.setCategories(dbCategories);
        bloggerRepo.save(b);
    }

    @Transactional
    public void persist(LinkDemand c) {
        List<Category> clientCategories = c.getCategories();
        List<Category> dbCategories = new LinkedList<>();

        clientCategories.forEach(cc -> dbCategories.add(categoryRepo.findByName(cc.getName())));
        c.setCategories(dbCategories);
        clientRepo.save(c);
    }

    public void persist(Category c) {
        categoryRepo.save(c);
    }
}
