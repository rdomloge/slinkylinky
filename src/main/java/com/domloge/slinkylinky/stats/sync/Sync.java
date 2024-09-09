package com.domloge.slinkylinky.stats.sync;

import java.time.LocalDate;
import java.time.Month;
import java.util.LinkedList;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpMethod;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

import com.domloge.slinkylinky.stats.dto.Supplier;
import com.domloge.slinkylinky.stats.entity.AbstractMonthlyData;
import com.domloge.slinkylinky.stats.moz.DaChecker;
import com.domloge.slinkylinky.stats.moz.SpamChecker;
import com.domloge.slinkylinky.stats.repo.DaRepo;
import com.domloge.slinkylinky.stats.repo.SpamRepo;
import com.domloge.slinkylinky.stats.repo.TemporalRepo;
import com.domloge.slinkylinky.stats.repo.TrafficRepo;
import com.domloge.slinkylinky.stats.semrush.Semrush;

import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class Sync {

    @Value("${linkservice.url}")
    private String linkserviceUrl;

    @Autowired
    private TrafficRepo trafficRepo;

    @Autowired
    private DaRepo daRepo;

    @Autowired
    private SpamRepo spamRepo;

    private RestTemplate rest;

    @Autowired
    private Semrush semrush;

    @Autowired
    private DaChecker daChecker;

    @Autowired
    private SpamChecker spamChecker;

    @Autowired
    private LinkServiceUpdater linkServiceUpdater;

    @Autowired
    private SupplierUpChecker supplierUpChecker;

    private LinkedList<String> downDomains = new LinkedList<>();

    
    public Sync(RestTemplate rest) {
        this.rest = rest;
    }

    // @PostConstruct
    @Scheduled(cron = "0 0 3 * * *")
    public void syncAllSuppliers() {
        log.info("Syncing");
        downDomains.clear();

        int page = 0;

        try {
            while(syncPage(page)) {
                page++;
            }
        }
        catch(TransientSyncException e) {
            log.error("Too many requests to Moz - backing off");
        }

        log.info("List of down domains");
        for(String domain : downDomains) {
            log.info("{}", domain);
        }

        log.info("Syncing complete");
    }

    private boolean syncPage(int page) throws TransientSyncException {
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

        List<Supplier> activeSuppliers = suppliers.stream()
            .filter(s -> ! s.isThirdParty() && ! s.isDisabled())
            .collect(Collectors.toList());

        for (Supplier supplier : activeSuppliers) {
            log.info("=================================================================");
            int domainLength = supplier.getDomain().length();
            int padding = (62 - domainLength) / 2;
            log.info("||{}{}{}||", " ".repeat(padding), supplier.getDomain(), " ".repeat(padding));
            // log.info("||   Syncing supplier {}  ||", supplier.getDomain());
            log.info("=================================================================");

            boolean supplierUp = supplierUpChecker.isSupplierUp(supplier);
            if(!supplierUp) {
                log.error("Supplier {} is down", supplier.getDomain());
                downDomains.add(supplier.getDomain());
            }
            else {
                log.debug("Supplier {} is up", supplier.getDomain());
            }

            log.debug("[[[ Synching traffic for {} ]]]", supplier.getDomain());
            syncSupplier(supplier, trafficRepo, semrush::forMonth, 12);

            log.debug("[[[ Synching DA for {} ]]]", supplier.getDomain());
            syncSupplier(supplier, daRepo, daChecker::forThisMonth, 1);
            linkServiceUpdater.pushLatestDaToLinkservice(supplier);

            log.debug("[[[ Synching spam for {} ]]]", supplier.getDomain());
            syncSupplier(supplier, spamRepo, spamChecker::forThisMonth, 1);
        }

        return response.getPage().getTotalPages() > (page+1);
    }

    public int syncSupplier(Supplier supplier, TemporalRepo repo, TemporalDataLoader<?> loader, int monthsBack) throws TransientSyncException {
        
        String domain = supplier.getDomain();
        LocalDate startDate = LocalDate.now().minusMonths(monthsBack);
        // make it the start of the month
        startDate = startDate.minusDays(startDate.getDayOfMonth() - 1);
        LocalDate endDate = LocalDate.now().minusDays(LocalDate.now().getDayOfMonth());
        log.info("Synching Supplier({}) {} between {} and {}", supplier.getId(), domain, startDate, endDate);
        int changeCount = 0;

        AbstractMonthlyData[] data;
        while((data = repo.findByDomainInTimeRange(domain, startDate, endDate)).length < monthsBack) {
            log.debug("Found {} data points in DB for domain {}", data.length, domain);
            Month oldestGap = findOldestGapInData(data, monthsBack);
            if(null == oldestGap) {
                throw new RuntimeException("No gaps found for domain "+domain+" despite not having 12 months of data");
            }
            else {
                log.info("{} has a gap in data for {}", domain, oldestGap);
                try {
                    AbstractMonthlyData missingMonth = loader.forMonth("system", domain, oldestGap);
                    log.info("Adding data point for domain {} with {} {} for {}", 
                        domain, 
                        missingMonth.getDataPointName(), 
                        missingMonth.getDataPointValue(), 
                        missingMonth.getUniqueYearMonth());
                    repo.saveMonth(missingMonth);
                    changeCount++;
                } 
                catch(HttpClientErrorException e) {
                    throw new TransientSyncException();
                }
            }            
        }

        return changeCount;
    }

    private Month findOldestGapInData(AbstractMonthlyData[] monthlyDbData, int monthsBack) {
        if(null == monthlyDbData || monthlyDbData.length == 0) {
            return LocalDate.now().minusMonths(monthsBack).getMonth();
        }

        for(int i = 0; i < monthlyDbData.length; i++) {
            AbstractMonthlyData data = monthlyDbData[i];
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

    // public void syncSupplier(Supplier supplier) {
    //     String domain = supplier.getDomain();
    //     LocalDate startDate = LocalDate.now().minusDays(365);
    //     // make it the start of the month
    //     startDate = startDate.minusDays(startDate.getDayOfMonth() - 1);
    //     LocalDate endDate = LocalDate.now();
    //     log.info("Synching Supplier({}) {} between {} and {}", supplier.getId(), domain, startDate, endDate);
    //     SemRushMonthlyData[] monthlyData;
    //     int semRushLookups = 0;
    //     while((monthlyData = repo.findByDomainInTimeRange(domain, startDate, endDate)).length < 12) {
    //         log.debug("Found {} data points in DB for domain {}", monthlyData.length, domain);
    //         if(monthlyData.length < 12) {
    //             Month oldestGap = findOldestGapInData2(monthlyData, 12);
    //             if(null == oldestGap) {
    //                 throw new RuntimeException("No gaps found for domain "+domain+" despite not having 12 months of data");
    //             }
    //             else {
    //                 log.info("{} has a gap in data for {}", domain, oldestGap);
    //                 fillGap2(domain, oldestGap);
    //                 semRushLookups++;
    //                 if(semRushLookups > 12) {
    //                     log.error("##########################################################");
    //                     log.error("Too many lookups for domain {}, stopping");
    //                     log.error("##########################################################");
    //                     break;
    //                 }
    //             }            
    //         }
    //     }
    //     log.info("Domain {} synched", domain);
    // }

    // private void fillGap2(String domain, Month oldestGap) {
    //     String data = semrush.getTrafficData(domain, oldestGap);
    //     List<SemRushResponseLine> lines = Loader.loadObjectList(SemRushResponseLine.class, data);
    //     List<SemRushMonthlyData> newData = new LinkedList<>();
    //     for(SemRushResponseLine line : lines) {
    //         SemRushMonthlyData dbData = new SemRushMonthlyData();
    //         dbData.setDomain(domain);
    //         dbData.setDate(line.getDate());
    //         dbData.setTraffic(line.getOrganicTraffic());
    //         dbData.setSrrank(line.getRank());
    //         newData.add(dbData);
    //         log.info("Adding data point for domain {} with traffic {} for {}", domain, dbData.getTraffic(), dbData.getDate());
    //     }
    //     repo.saveAll(newData);
    // }

    // private Month findOldestGapInData2(SemRushMonthlyData[] monthlyDbData, int monthsBack) {

    //     if(null == monthlyDbData || monthlyDbData.length == 0) {
    //         return LocalDate.now().minusMonths(monthsBack).getMonth();
    //     }

    //     for(int i = 0; i < monthlyDbData.length; i++) {
    //         SemRushMonthlyData data = monthlyDbData[i];
    //         Month expectedMonth = LocalDate.now().minusMonths(monthsBack - i).getMonth();
    //         if(data.getDate().getMonthValue() != expectedMonth.getValue()) {
    //             log.info("Found gap in data for domain {} with month {}", data.getDomain(), expectedMonth);
    //             return expectedMonth;
    //         }
    //     }

    //     if(monthlyDbData.length < monthsBack) {
    //         Month nextMonthNeeded = LocalDate.now().minusMonths(monthsBack - monthlyDbData.length).getMonth();
    //         log.info("The data we have for domain {} only goes up to {}, registering gap for {}", 
    //             monthlyDbData[0].getDomain(), 
    //             monthlyDbData[monthlyDbData.length-1].getDate().getMonth(),
    //             nextMonthNeeded);
    //         return nextMonthNeeded;
    //     }

    //     return null;
    // }
}
