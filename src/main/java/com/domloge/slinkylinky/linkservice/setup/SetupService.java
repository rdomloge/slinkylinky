package com.domloge.slinkylinky.linkservice.setup;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.domloge.slinkylinky.linkservice.Util;
import com.domloge.slinkylinky.linkservice.entity.Supplier;
import com.domloge.slinkylinky.linkservice.entity.Category;
import com.domloge.slinkylinky.linkservice.entity.LinkDemand;
import com.domloge.slinkylinky.linkservice.entity.PaidLink;
import com.domloge.slinkylinky.linkservice.entity.Proposal;
import com.domloge.slinkylinky.linkservice.repo.SupplierRepo;
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
    private SupplierRepo supplierRepo;

    @Autowired
    private LinkDemandRepo linkDemandRepo;

    @Autowired
    private CategoryRepo categoryRepo;

    @Autowired
    private PaidLinkRepo paidLinkRepo;

    @Autowired
    private ProposalRepo proposalRepo;

    
    
    @Transactional
    public void persist(Supplier s) {
        if(null == supplierRepo.findByDomainIgnoreCase(s.getDomain())) {

            List<Category> supplierCategories = s.getCategories();
            List<Category> dbCategories = new LinkedList<>();

            supplierCategories.stream()
                .map(c -> c.getName().split(","))
                .forEach(names -> Arrays.stream(names)
                    .forEach(name -> dbCategories.add(categoryRepo.findByName(name))));
            s.setCategories(dbCategories);
            supplierRepo.save(s);
        }
    }

    @Transactional
    public void persist(LinkDemand ld) {

        if(null == linkDemandRepo.findByUrl(ld.getUrl())) {

            List<Category> clientCategories = ld.getCategories();
            List<Category> dbCategories = new LinkedList<>();

            clientCategories.stream()
                .map(cc -> cc.getName().split(","))
                .forEach(names -> Arrays.stream(names)
                    .forEach(name -> dbCategories.add(categoryRepo.findByName(name))));
            ld.setCategories(dbCategories);
            ld.setCreatedBy("historical");
            linkDemandRepo.save(ld);
        }
        else {
            log.info("Already have link demand {}", ld.getName());
        }
    }

    public void persist(Category c) {
        if(null == categoryRepo.findByName(c.getName())) {
            categoryRepo.save(c);
        }
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
        
        String liveLinkUrl = findLiveLink(histories);
        if(null != proposalRepo.findByLiveLinkUrl(liveLinkUrl)) {
            return;
        }
        
        
        List<PaidLink> paidLinks = new LinkedList<>();
        histories.forEach(h -> {
            PaidLink pl = new PaidLink();
            String bloggerWebsite = h.getBloggerWebsite();
            Supplier supplier = supplierRepo.findByDomainIgnoreCase(Util.stripDomain(bloggerWebsite));
            
            if(null == supplier) {
                log.error("Could not resolve supplier from {}", bloggerWebsite);
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
            demand.setCreatedBy("historical");
            linkDemandRepo.save(demand);

            pl.setSupplier(supplier);
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
        p.setLiveLinkUrl(liveLinkUrl);
        p.setLiveLinkTitle(findLiveLinkTitle(histories));
        p.setDateBlogLive(findLiveLinkDelivered(histories));
        proposalRepo.save(p);
    }

    private LocalDateTime findLiveLinkDelivered(List<History> histories) {
        Set<String> delivereds = histories.stream()
            .map(h -> h.getDelivered())
            .collect(Collectors.toSet());
        if(delivereds.size() != 1) throw new RuntimeException("Wrong number of delivereds");
        String delivered = delivereds.toArray(new String[]{})[0];
        return Util.parse(delivered); 
    }

    private static String findLiveLink(List<History> histories) {
        Set<String> links = histories.stream()
            .map(h -> h.getPostPlacement())
            .collect(Collectors.toSet());
        if(links.size() != 1) throw new RuntimeException("Wrong number of live links");
        return links.toArray(new String[]{})[0];
    }

    private static String findLiveLinkTitle(List<History> histories) {
        Set<String> titles = histories.stream()
            .map(h -> h.getPostTitle())
            .collect(Collectors.toSet());
        if(titles.size() != 1) throw new RuntimeException("Wrong number of live link titles");
        return titles.toArray(new String[]{})[0];
    }

    private static LocalDateTime findLatestDateCreated(List<History> histories) {
        return histories.stream()
            .map( h -> Util.parse(h.getRequested()))
            .sorted((ldt1,ldt2) -> ldt1.isAfter(ldt2) ? -1 : 1)
            .findFirst().get();
    }
}
