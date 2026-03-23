package com.domloge.slinkylinky.stats.sync;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import com.domloge.slinkylinky.stats.dto.ResponsivenessDataPoint;
import com.domloge.slinkylinky.stats.entity.SupplierResponsiveness;
import com.domloge.slinkylinky.stats.repo.ResponsivenessRepo;

import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class ResponsivenessSync {

    @Value("${linkservice.url}")
    private String linkserviceUrl;

    @Autowired
    private ResponsivenessRepo responsivenessRepo;

    private RestTemplate rest;

    public ResponsivenessSync(RestTemplate rest) {
        this.rest = rest;
    }

    @PostConstruct
    public void calculateOnStartup() {
        try {
            recalculateAll();
        } catch (Exception e) {
            log.warn("Failed to calculate responsiveness on startup — will retry on weekly schedule", e);
        }
    }

    @Scheduled(cron = "0 0 4 * * MON")
    public void weeklyRecalculate() {
        try {
            recalculateAll();
        } catch (Exception e) {
            log.error("Failed to recalculate responsiveness", e);
        }
    }

    public void recalculateAll() {
        log.info("Recalculating supplier responsiveness");

        ResponsivenessDataPoint[] dataPoints = rest.getForObject(
            linkserviceUrl + "/.rest/proposalsupport/responsivenessData",
            ResponsivenessDataPoint[].class
        );

        if (dataPoints == null || dataPoints.length == 0) {
            log.info("No responsiveness data points returned from linkservice");
            return;
        }

        // Group by supplier — data is already limited to 10 per supplier by the linkservice endpoint
        Map<Long, List<ResponsivenessDataPoint>> bySupplier = new LinkedHashMap<>();
        for (ResponsivenessDataPoint dp : dataPoints) {
            bySupplier.computeIfAbsent(dp.getSupplierId(), k -> new ArrayList<>()).add(dp);
        }

        int updated = 0;
        for (Map.Entry<Long, List<ResponsivenessDataPoint>> entry : bySupplier.entrySet()) {
            long supplierId = entry.getKey();
            List<ResponsivenessDataPoint> points = entry.getValue();

            double totalDays = 0;
            int validCount = 0;

            for (ResponsivenessDataPoint dp : points) {
                long days = ChronoUnit.DAYS.between(dp.getDateSentToSupplier(), dp.getDateBlogLive());
                if (days < 0) {
                    log.debug("Skipping proposal for supplier {} — dateBlogLive before dateSentToSupplier", supplierId);
                    continue;
                }
                totalDays += days;
                validCount++;
            }

            if (validCount == 0) continue;

            double avgDays = totalDays / validCount;
            String domain = points.get(0).getSupplierDomain();

            SupplierResponsiveness record = responsivenessRepo.findBySupplierId(supplierId);
            if (record == null) {
                record = new SupplierResponsiveness();
                record.setSupplierId(supplierId);
            }
            record.setDomain(domain);
            record.setAvgResponseDays(avgDays);
            record.setSampleSize(validCount);
            record.setLastCalculated(LocalDateTime.now());
            responsivenessRepo.save(record);
            updated++;
        }

        log.info("Responsiveness recalculation complete — updated {} suppliers", updated);
    }
}
