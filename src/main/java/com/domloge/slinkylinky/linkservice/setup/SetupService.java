package com.domloge.slinkylinky.linkservice.setup;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.domloge.slinkylinky.linkservice.entity.Blogger;
import com.domloge.slinkylinky.linkservice.entity.Client;
import com.domloge.slinkylinky.linkservice.repo.BloggerRepo;
import com.domloge.slinkylinky.linkservice.repo.ClientRepo;

import jakarta.transaction.Transactional;

@Service
public class SetupService {

    @Autowired
    private BloggerRepo bloggerRepo;

    @Autowired
    private ClientRepo clientRepo;
    
    @Transactional
    public void persist(Blogger b) {
        bloggerRepo.save(b);
    }

    @Transactional
    public void persist(Client c) {
        clientRepo.save(c);
    }
}
