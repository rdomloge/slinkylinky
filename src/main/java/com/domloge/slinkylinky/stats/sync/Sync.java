package com.domloge.slinkylinky.stats.sync;

import java.time.LocalDate;
import java.time.Month;
import java.util.LinkedList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpMethod;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import com.domloge.slinkylinky.stats.dto.Supplier;
import com.domloge.slinkylinky.stats.entity.SemRushMonthlyData;
import com.domloge.slinkylinky.stats.repo.TrafficRepo;
import com.domloge.slinkylinky.stats.semrush.Loader;
import com.domloge.slinkylinky.stats.semrush.SemRushResponseLine;
import com.domloge.slinkylinky.stats.semrush.Semrush;

import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class Sync {

    @Value("${linkservice.url}")
    private String linkserviceUrl;

    @Autowired
    private TrafficRepo repo;

    private RestTemplate rest;

    @Autowired
    private Semrush semrush;

    
    public Sync(RestTemplate rest) {
        this.rest = rest;
    }

    
    @PostConstruct
    public void syncAllSuppliers() {
        log.info("Syncing");

        int page = 0;

        while(syncPage(page)) {
            page++;
        }

        log.info("Syncing complete");
    }

    private boolean syncPage(int page) {
        Response response = rest.exchange(linkserviceUrl + "/.rest/suppliers?page="+page, 
                HttpMethod.GET, 
                null, 
                Response.class)
            .getBody();
        
        List<Supplier> suppliers = response.get_embedded().getSuppliers();

        log.info("Got {} suppliers from page {} of a total of {} pages ({} suppliers)", 
            suppliers.size(), 
            response.getPage().getNumber()+1, 
            response.getPage().getTotalPages(),
            response.getPage().getTotalElements());

        suppliers.stream()
            .filter(s -> ! s.isThirdParty() && ! s.isDisabled())
            .forEach(supplier -> syncSupplier(supplier));

        return response.getPage().getTotalPages() > (page+1);
    }

    

    private void syncSupplier(Supplier supplier) {
        String domain = supplier.getDomain();
        LocalDate startDate = LocalDate.now().minusDays(365);
        // make it the start of the month
        startDate = startDate.minusDays(startDate.getDayOfMonth() - 1);
        LocalDate endDate = LocalDate.now();
        log.info("Synching Supplier({}) {} between {} and {}", supplier.getId(), domain, startDate, endDate);
        SemRushMonthlyData[] monthlyData;
        int semRushLookups = 0;
        while((monthlyData = repo.findByDomainInTimeRange(domain, startDate, endDate)).length < 12) {
            log.debug("Found {} data points in DB for domain {}", monthlyData.length, domain);
            if(monthlyData.length < 12) {
                Month oldestGap = findOldestGapInData(monthlyData, 12);
                if(null == oldestGap) {
                    throw new RuntimeException("No gaps found for domain "+domain+" despite not having 12 months of data");
                }
                else {
                    log.info("{} has a gap in data for {}", domain, oldestGap);
                    fillGap(domain, oldestGap);
                    semRushLookups++;
                    if(semRushLookups > 12) {
                        log.error("##########################################################");
                        log.error("Too many lookups for domain {}, stopping");
                        log.error("##########################################################");
                        break;
                    }
                }            
            }
        }
        log.info("Domain {} synched", domain);
    }

    private void fillGap(String domain, Month oldestGap) {
        String data = semrush.getTrafficData(domain, oldestGap);
        List<SemRushResponseLine> lines = Loader.loadObjectList(SemRushResponseLine.class, data);
        List<SemRushMonthlyData> newData = new LinkedList<>();
        for(SemRushResponseLine line : lines) {
            SemRushMonthlyData dbData = new SemRushMonthlyData();
            dbData.setDomain(domain);
            dbData.setDate(line.getDate());
            dbData.setTraffic(line.getOrganicTraffic());
            dbData.setSrrank(line.getRank());
            newData.add(dbData);
            log.info("Adding data point for domain {} with traffic {} for {}", domain, dbData.getTraffic(), dbData.getDate());
        }
        repo.saveAll(newData);
    }

    private Month findOldestGapInData(SemRushMonthlyData[] monthlyDbData, int monthsBack) {

        if(null == monthlyDbData || monthlyDbData.length == 0) {
            return LocalDate.now().minusMonths(monthsBack).getMonth();
        }

        for(int i = 0; i < monthlyDbData.length; i++) {
            SemRushMonthlyData data = monthlyDbData[i];
            Month expectedMonth = LocalDate.now().minusMonths(monthsBack - i).getMonth();
            if(data.getDate().getMonthValue() != expectedMonth.getValue()) {
                log.info("Found gap in data for domain {} with month {}", data.getDomain(), expectedMonth);
                return expectedMonth;
            }
        }

        if(monthlyDbData.length < monthsBack) {
            Month nextMonthNeeded = LocalDate.now().minusMonths(monthsBack - monthlyDbData.length).getMonth();
            log.info("The data we have for domain {} only goes up to {}, registering gap for {}", 
                monthlyDbData[0].getDomain(), 
                monthlyDbData[monthlyDbData.length-1].getDate().getMonth(),
                nextMonthNeeded);
            return nextMonthNeeded;
        }

        return null;
    }
}
