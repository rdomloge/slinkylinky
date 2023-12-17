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
import com.domloge.slinkylinky.linkservice.entity.Category;
import com.domloge.slinkylinky.linkservice.entity.DemandSite;
import com.domloge.slinkylinky.linkservice.entity.Demand;
import com.domloge.slinkylinky.linkservice.entity.PaidLink;
import com.domloge.slinkylinky.linkservice.entity.Proposal;
import com.domloge.slinkylinky.linkservice.entity.Supplier;
import com.domloge.slinkylinky.linkservice.repo.CategoryRepo;
import com.domloge.slinkylinky.linkservice.repo.DemandSiteRepo;
import com.domloge.slinkylinky.linkservice.repo.DemandRepo;
import com.domloge.slinkylinky.linkservice.repo.PaidLinkRepo;
import com.domloge.slinkylinky.linkservice.repo.ProposalRepo;
import com.domloge.slinkylinky.linkservice.repo.SupplierRepo;

import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class SetupService {

    @Autowired
    private SupplierRepo supplierRepo;

    @Autowired
    private DemandRepo demandRepo;

    @Autowired
    private CategoryRepo categoryRepo;

    @Autowired
    private PaidLinkRepo paidLinkRepo;

    @Autowired
    private ProposalRepo proposalRepo;

    @Autowired
    private DemandSiteRepo demandSiteRepo;

    int linked = 0;
    int ignored = 0;
    int demandSitesCreated = 0;

    @Transactional
    public void linkDemandsToTheirDemandSites() {
                
        LinkedList<Demand> demands = new LinkedList<>();
        demandRepo.findAll().forEach(demands::add);

        demands.forEach(d -> {
            DemandSite demandSite = demandSiteRepo.findByDomainIgnoreCase(d.getDomain());
            if(null == demandSite) {
                log.warn("No demandSite found for {}", d.getDomain());
                DemandSite ds = new DemandSite();
                ds.setDomain(d.getDomain());
                ds.setUrl(d.getUrl());
                ds.setName(d.getName());
                ds.setEmail("n/a");
                ds.setCreatedBy("historical");
                ds.setDemands(Arrays.asList(d));
                demandSiteRepo.save(ds);
                demandSitesCreated++;
                linked++;
            }
            else {
                
                // does the demandSite already have this demand?
                demandSite.getDemands().stream()
                    .filter(demand -> demand.getId() == d.getId())
                    .findFirst()
                    .ifPresentOrElse((demand) -> {
                        log.debug("DemandSite {} already has demand {}", demandSite.getName(), demand.getName());
                        ignored++;
                    }, () -> {
                        log.debug("Adding demand {} to demandSite {}", d.getName(), demandSite.getName());
                        LinkedList<Demand> newList = new LinkedList<>();
                        newList.addAll(demandSite.getDemands());
                        newList.add(d);
                        demandSite.setDemands(newList);
                        demandSiteRepo.save(demandSite);
                        linked++;
                    });
            }
        });
        log.info("Finished linking demandSites to demands. {} total demands, {} linked, {} ignored, {} demandSites created", 
            demands.size(), linked, ignored, demandSitesCreated);
    }
    
    @Transactional
    public void persist(SetupSupplier ss) {
        if(null == supplierRepo.findByDomainIgnoreCase(ss.getDomain())) {

            List<Category> supplierCategories = ss.getCategories();
            List<Category> dbCategories = new LinkedList<>();

            supplierCategories.stream()
                .map(c -> c.getName().split(","))
                .forEach(names -> Arrays.stream(names)
                    .forEach(name -> dbCategories.add(categoryRepo.findByName(name))));

            Supplier s = new Supplier();
            s.setCategories(dbCategories);
            s.setDa(ss.getDa());
            s.setDomain(ss.getDomain());
            s.setEmail(ss.getEmail());
            s.setName(ss.getName());
            setSemRush(s, ss);
            setWeWriteFee(s, ss);
            s.setWebsite(ss.getWebsite());
            supplierRepo.save(s);
        }
    }

    private void setSemRush(Supplier s, SetupSupplier ss) {
        
        try {
            s.setSemRushAuthorityScore(Integer.parseInt(ss.getSemRushAuthorityScore()));
        } 
        catch(NumberFormatException n) {
            s.setSemRushAuthorityScore(0);
        }

        try {
            s.setSemRushUkJan23Traffic(Integer.parseInt(ss.getSemRushUkJan23Traffic()));
        }
        catch(NumberFormatException n) {
            s.setSemRushUkJan23Traffic(0);
        }
        
        try {
            s.setSemRushUkMonthlyTraffic(Integer.parseInt(ss.getSemRushUkMonthlyTraffic()));
        }
        catch(NumberFormatException n) {
            s.setSemRushUkMonthlyTraffic(0);
        }
    }

    private void setWeWriteFee(Supplier s, SetupSupplier ss) {
        String fee = ss.getWeWriteFee();
        if(fee.contains("$")) {
            int amt = (int)Double.parseDouble(fee.substring(fee.indexOf("$")+1));
            s.setWeWriteFee(amt);
            s.setWeWriteFeeCurrency("$");
        }
        else if(fee.contains("£")) {
            int amt = (int)Double.parseDouble(fee.substring(fee.indexOf("£")+1));
            s.setWeWriteFee(amt);
            s.setWeWriteFeeCurrency("£");
        }
    }

    @Transactional
    public void persist(SetupDemand sd) {

        Demand[] searchResults = demandRepo.findByUrlAndAnchorText(sd.getUrl(), sd.getAnchorText());
        if(null ==  searchResults || searchResults.length == 0) {

            if(sd.getPostTitle() != null && sd.getPostTitle().trim().length() > 0) {
                log.warn("@@@ Ignoring already fulfilled demand: "+sd.getName());
                return;
            }

            List<Category> demandSiteCategories = sd.getCategories();
            List<Category> dbCategories = new LinkedList<>();

            if(demandSiteCategories == null || demandSiteCategories.size() == 0) {
                log.warn("@@@ There are no categories for {}", sd.getName());
            }
            else {
                demandSiteCategories.stream()
                    .map(cc -> cc.getName().split(","))
                    .forEach(names -> Arrays.stream(names)
                        .forEach(name -> dbCategories.add(categoryRepo.findByName(name))));
            }

            Demand ld = new Demand();
            ld.setAnchorText(sd.getAnchorText());
            ld.setDaNeeded(sd.getDaNeededInt());
            ld.setDomain(sd.getDomain());
            ld.setName(sd.getName());
            ld.setRequestedFromString(sd.getRequested());
            ld.setUrl(sd.getUrl());
            ld.setCategories(dbCategories);
            ld.setCreatedBy("historical");
            demandRepo.save(ld);
        }
        else {
            log.info("Already have link demand {}", sd.getName());
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
        
        if("done".equalsIgnoreCase(head.getPostPlacement())) {
            log.warn("### Ignoring {} histories for post placement {}", histories.size(), head.getPostPlacement());
            return;
        }

        if(histories.size() > 3) {
            log.warn("###################################################################################################");
            log.warn("There are "+histories.size()+" histories for post placement "+histories.get(0).getPostPlacement());
            log.warn("###################################################################################################");
        }
        
        String liveLinkUrl = findLiveLink(histories);
        if(null != proposalRepo.findByLiveLinkUrl(liveLinkUrl)) {
            return;
        }
        
        
        List<PaidLink> paidLinks = new LinkedList<>();
        histories.forEach(h -> {
            PaidLink pl = new PaidLink();
            String bloggerWebsite = h.getBloggerWebsite();
            Supplier supplier = supplierRepo.findByDomainIgnoreCase(Util.stripDomain(bloggerWebsite));
            
            if(null == supplier && (
                h.getName().equalsIgnoreCase("micaela")
                ||
                h.getName().equalsIgnoreCase("fatjoe")
                )) {
                supplier = createThirdPartySupplier(h);
            }

            Demand demand = new Demand();
            demand.setAnchorText(h.getAnchorText());
            demand.setDaNeeded(h.getDaNeededInt());
            demand.setDomain(h.getClientWebsite());
            demand.setName(h.getCompanyName());
            demand.setRequestedFromString(h.getRequested());
            demand.setUrl(h.getClientWebsite());
            demand.setCategories(Arrays.asList(categoryRepo.findByName(h.getCategory())));
            demand.setCreatedBy("historical");
            demandRepo.save(demand);

            pl.setSupplier(supplier);
            pl.setDemand(demand);
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

    private Supplier createThirdPartySupplier(History h) {
        Supplier supplier = new Supplier();
        supplier.setThirdParty(true);
        supplier.setName(h.getName());
        supplier.setDa(Integer.parseInt(h.getDa()));
        supplier.setEmail("n/a");
        supplier.setWeWriteFee(h.getCostInt());
        supplier.setWebsite(h.getBloggerWebsite());
        return supplierRepo.save(supplier);
    }

    private LocalDateTime findLiveLinkDelivered(List<History> histories) {
        Set<String> delivereds = histories.stream()
            .map(h -> h.getDelivered())
            .collect(Collectors.toSet());
        if(delivereds.size() != 1) 
            throw new RuntimeException("Wrong number of delivereds: "+delivereds);
        String delivered = delivereds.toArray(new String[]{})[0];
        return Util.parse(delivered); 
    }

    private static String findLiveLink(List<History> histories) {
        Set<String> links = histories.stream()
            .map(h -> h.getPostPlacement())
            .collect(Collectors.toSet());
        if(links.size() != 1) 
            throw new RuntimeException("Wrong number of live links: "+links);
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
