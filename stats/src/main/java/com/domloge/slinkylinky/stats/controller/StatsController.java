package com.domloge.slinkylinky.stats.controller;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.domloge.slinkylinky.stats.dto.DataPoint;
import com.domloge.slinkylinky.stats.entity.DaMonthlyData;
import com.domloge.slinkylinky.stats.entity.SemRushMonthlyData;
import com.domloge.slinkylinky.stats.entity.SpamMonthlyData;
import com.domloge.slinkylinky.stats.repo.DaRepo;
import com.domloge.slinkylinky.stats.repo.SpamRepo;
import com.domloge.slinkylinky.stats.repo.TrafficRepo;

@Controller
@RequestMapping(".rest/stats")
public class StatsController {
    @Autowired
    private TrafficRepo trafficRepo;

    @Autowired
    private SpamRepo spamRepo;

    @Autowired
    private DaRepo daRepo;


    @GetMapping(path = "/fordomain", produces = "application/json")
    public ResponseEntity<DataPoint[]> findByDomainInTimeRange(String domain, LocalDate startDate, LocalDate endDate) {
        SemRushMonthlyData[] trafficDataPoints = trafficRepo.findByDomainInTimeRange(domain, startDate, endDate);
        SpamMonthlyData[] spamDataPoints = spamRepo.findByDomainInTimeRange(domain, startDate, endDate);
        DaMonthlyData[] daDataPoints = daRepo.findByDomainInTimeRange(domain, startDate, endDate);
        
        Map<String, DataPoint> dataPoints = new HashMap<>();

        for (SemRushMonthlyData data : trafficDataPoints) {
            DataPoint point = dataPoints.get(data.getUniqueYearMonth());
            if (point == null) {
                point = new DataPoint();
                dataPoints.put(data.getUniqueYearMonth(), point);
                point.setYearMonth(data.getUniqueYearMonth());
            }
            point.setTraffic(data.getTraffic());
            point.setSrrank(data.getSrrank());
        }

        for (SpamMonthlyData data : spamDataPoints) {
            DataPoint point = dataPoints.get(data.getUniqueYearMonth());
            if (point == null) {
                point = new DataPoint();
                dataPoints.put(data.getUniqueYearMonth(), point);
                point.setYearMonth(data.getUniqueYearMonth());
            }
            point.setSpamScore(data.getSpamScore());
        }

        for (DaMonthlyData data : daDataPoints) {
            DataPoint point = dataPoints.get(data.getUniqueYearMonth());
            if (point == null) {
                point = new DataPoint();
                dataPoints.put(data.getUniqueYearMonth(), point);
                point.setYearMonth(data.getUniqueYearMonth());
            }
            point.setDa(data.getDa());
        }

        DataPoint[] datapoints = dataPoints.values()
            .stream()
            .sorted((d1, d2) -> { return d1.getYearMonth().compareTo(d2.getYearMonth()); })
            .toArray(DataPoint[]::new);
            
        return ResponseEntity.ok(datapoints);
    }
}
