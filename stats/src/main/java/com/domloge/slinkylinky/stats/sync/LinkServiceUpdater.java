package com.domloge.slinkylinky.stats.sync;

import java.time.LocalDate;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import com.domloge.slinkylinky.stats.Util;
import com.domloge.slinkylinky.stats.dto.Supplier;
import com.domloge.slinkylinky.stats.entity.DaMonthlyData;
import com.domloge.slinkylinky.stats.entity.SpamMonthlyData;
import com.domloge.slinkylinky.stats.repo.DaRepo;
import com.domloge.slinkylinky.stats.repo.SpamRepo;

import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
public class LinkServiceUpdater {


    @Value("${linkservice.url}")
    private String linkserviceUrl;

    private RestTemplate rest;

    @Autowired
    private DaRepo daRepo;

    @Autowired
    private SpamRepo spamRepo;


    public LinkServiceUpdater(RestTemplate rest) {
        this.rest = rest;
        rest.setRequestFactory(new HttpComponentsClientHttpRequestFactory());
    }

    
    public void pushLatestDaToLinkservice(Supplier supplier) {

        long id = supplier.getId();
        String domain = supplier.getDomain();
        DaMonthlyData latest = daRepo.findFirstByDomainOrderByDateDesc(domain);
        if(latest == null) {
            log.error("No DA data found for domain {} - cannot update supplier DA", domain);
            return;
        }
        if(supplier.getDa() == latest.getDa()) {
            log.info("DA for {} is already up to date in Link Service", domain);
            return;
        }

        
        HttpEntity<?> entity = HttpEntity.EMPTY;
        rest.exchange(linkserviceUrl+"/.rest/supplierSupport/updateSupplierDa?supplierId="+id+"&da="+latest.getDa(), 
            HttpMethod.PATCH, 
            entity, 
            String.class);
            
        log.info("Link service updated for {}, from DA {} to DA {}", domain, supplier.getDa(), latest.getDa());
    }


    public void pushLatestSpamToLinkservice(Supplier supplier) {

        long id = supplier.getId();
        String domain = supplier.getDomain();
        SpamMonthlyData latest = spamRepo.findFirstByDomainOrderByDateDesc(domain);
        if(latest == null) {
            log.error("No spam data found for domain {} - cannot update supplier spam_score", domain);
            return;
        }
        Integer current = supplier.getSpamScore();
        if(current != null && current == latest.getSpamScore()) {
            log.info("Spam score for {} is already up to date in Link Service", domain);
            return;
        }

        HttpEntity<?> entity = HttpEntity.EMPTY;
        rest.exchange(linkserviceUrl+"/.rest/supplierSupport/updateSupplierSpam?supplierId="+id+"&spamScore="+latest.getSpamScore(),
            HttpMethod.PATCH,
            entity,
            String.class);

        log.info("Link service updated for {}, from spam {} to spam {}", domain, current, latest.getSpamScore());
    }
}
