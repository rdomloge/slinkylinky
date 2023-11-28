package com.domloge.slinkylinky.linkservice.setup;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.Collection;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.domloge.slinkylinky.linkservice.Util;
import com.domloge.slinkylinky.linkservice.entity.Blogger;
import com.domloge.slinkylinky.linkservice.entity.Category;
import com.domloge.slinkylinky.linkservice.entity.LinkDemand;
import com.domloge.slinkylinky.linkservice.entity.PaidLink;
import com.domloge.slinkylinky.linkservice.entity.Proposal;
import com.domloge.slinkylinky.linkservice.repo.BloggerRepo;
import com.domloge.slinkylinky.linkservice.repo.CategoryRepo;
import com.domloge.slinkylinky.linkservice.repo.LinkDemandRepo;
import com.domloge.slinkylinky.linkservice.repo.PaidLinkRepo;
import com.domloge.slinkylinky.linkservice.repo.ProposalRepo;

import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class SetupService {

    @Autowired
    private BloggerRepo bloggerRepo;

    @Autowired
    private LinkDemandRepo linkDemandRepo;

    @Autowired
    private CategoryRepo categoryRepo;

    @Autowired
    private PaidLinkRepo paidLinkRepo;

    @Autowired
    private ProposalRepo proposalRepo;

    
    
    @Transactional
    public void persist(Blogger b) {
        List<Category> bloggerCategories = b.getCategories();
        List<Category> dbCategories = new LinkedList<>();

        bloggerCategories.stream()
            .map(c -> c.getName().split(","))
            .forEach(names -> Arrays.stream(names)
                .forEach(name -> dbCategories.add(categoryRepo.findByName(name))));
        b.setCategories(dbCategories);
        bloggerRepo.save(b);
    }

    @Transactional
    public void persist(LinkDemand c) {
        List<Category> clientCategories = c.getCategories();
        List<Category> dbCategories = new LinkedList<>();

        clientCategories.stream()
            .map(cc -> cc.getName().split(","))
            .forEach(names -> Arrays.stream(names)
                .forEach(name -> dbCategories.add(categoryRepo.findByName(name))));
        c.setCategories(dbCategories);
        linkDemandRepo.save(c);
    }

    public void persist(Category c) {
        categoryRepo.save(c);
    }

    @Transactional
    public void persist(List<History> histories) {
        History head = histories.get(0);
        if(head.getName().toLowerCase().equals("fatjoe")) {
            log.error("Ignoring FJ link from {} for {}", head.getBloggerWebsite(), head.getClientWebsite());
            return;
        }
        if(head.getName().toLowerCase().equals("micaela")) {
            log.error("Ignoring Micaela link from {} for {}", head.getBloggerWebsite(), head.getClientWebsite());
            return;
        }
        if(histories.size() > 3) throw new RuntimeException("There are "+histories.size()+" histories for "+histories.get(0).getPostPlacement());
        List<PaidLink> paidLinks = new LinkedList<>();
        histories.forEach(h -> {
            PaidLink pl = new PaidLink();
            String bloggerWebsite = h.getBloggerWebsite();
            Blogger blogger = bloggerRepo.findByDomainIgnoreCase(Util.stripDomain(bloggerWebsite));
            
            if(null == blogger) {
                log.error("Could not resolve blogger from {}", bloggerWebsite);
                return;
            }

            LinkDemand demand = new LinkDemand();
            demand.setAnchorText(h.getAnchorText());
            demand.setDaNeeded(h.getDaNeededInt());
            demand.setDomain(h.getClientWebsite());
            demand.setName(h.getCompanyName());
            demand.setRequested(h.getRequested());
            demand.setUrl(h.getClientWebsite());
            demand.setCategories(Arrays.asList(categoryRepo.findByName(h.getCategory())));
            linkDemandRepo.save(demand);

            pl.setBlogger(blogger);
            pl.setLinkDemand(demand);
            paidLinkRepo.save(pl);
            paidLinks.add(pl);
        });
          
        Proposal p = new Proposal();
        p.setPaidLinks(paidLinks);
        p.setDateCreated(findLatestDateCreated(histories));
        p.setBlogLive(true);
        p.setContentReady(true);
        p.setInvoiceReceived(true);
        p.setInvoicePaid(true);
        p.setProposalAccepted(true);
        p.setProposalSent(true);
        p.setLiveLinkUrl(findLiveLink(histories));
        proposalRepo.save(p);
    }

    // public static void main(String[] args) {
    //     History h1 = new History();
    //     History h2 = new History();
    //     History h3 = new History();
    //     h1.setRequested("27/10/2023");
    //     h2.setRequested("26/10/2023");
    //     h3.setRequested("25/10/2023");
    //     LocalDateTime latest = findLatestDateCreated(Arrays.asList(h1, h2, h3));
    //     System.out.println("Latest: "+latest);
    // }

    private static String findLiveLink(List<History> histories) {
        Set<String> links = histories.stream()
            .map(h -> h.getPostPlacement())
            .collect(Collectors.toSet());
        if(links.size() != 1) throw new RuntimeException("Wrong number of live links");
        return links.toArray(new String[]{})[0];
    }

    private static LocalDateTime findLatestDateCreated(List<History> histories) {
        return histories.stream()
            .map( h -> Util.parse(h.getRequested()))
            .sorted((ldt1,ldt2) -> ldt1.isAfter(ldt2) ? -1 : 1)
            .findFirst().get();
    }
}
