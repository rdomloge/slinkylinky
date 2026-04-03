package com.domloge.slinkylinky.linkservice.controller;

import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.domloge.slinkylinky.linkservice.entity.AtRiskDemandSiteProjection;
import com.domloge.slinkylinky.linkservice.entity.DemandSite;
import com.domloge.slinkylinky.linkservice.entity.SupplierOnboardingMonthProjection;
import com.domloge.slinkylinky.linkservice.repo.DemandSiteRepo;
import com.domloge.slinkylinky.linkservice.repo.SupplierRepo;

import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping(".rest/supplierHealthSupport")
@Slf4j
public class SupplierHealthSupportController {

    @Autowired
    private SupplierRepo supplierRepo;

    @Autowired
    private DemandSiteRepo demandSiteRepo;

    @GetMapping(path = "/onboarding", produces = "application/json")
    public ResponseEntity<SupplierOnboardingResponse> onboarding(
            @RequestParam(defaultValue = "12") int months) {

        List<SupplierOnboardingMonthProjection> rows = supplierRepo.countNewSuppliersByMonth(months);

        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM");
        YearMonth now = YearMonth.now();
        String currentMonth = now.format(fmt);

        Map<String, Long> countsByMonth = rows.stream()
                .collect(Collectors.toMap(
                        SupplierOnboardingMonthProjection::getYearMonth,
                        SupplierOnboardingMonthProjection::getCount));

        long thisMonth = countsByMonth.getOrDefault(currentMonth, 0L);

        List<SupplierOnboardingResponse.MonthCount> history = new ArrayList<>();
        YearMonth start = now.minusMonths(months - 1);
        for (int i = 0; i < months; i++) {
            String label = start.plusMonths(i).format(fmt);
            history.add(new SupplierOnboardingResponse.MonthCount(label, countsByMonth.getOrDefault(label, 0L)));
        }

        return ResponseEntity.ok(new SupplierOnboardingResponse(thisMonth, history));
    }

    @GetMapping(path = "/atrisk", produces = "application/json")
    public ResponseEntity<AtRiskDemandSiteResponse> atRisk(
            @RequestParam(defaultValue = "5") int threshold) {

        List<AtRiskDemandSiteProjection> projections = supplierRepo.findAtRiskDemandSites(threshold);

        if (projections.isEmpty()) {
            return ResponseEntity.ok(
                new AtRiskDemandSiteResponse(threshold, Collections.emptyList(), Collections.emptyList()));
        }

        List<Long> atRiskIds = projections.stream()
                .map(AtRiskDemandSiteProjection::getId)
                .collect(Collectors.toList());

        Map<Long, DemandSite> sitesById = new HashMap<>();
        demandSiteRepo.findAllById(atRiskIds)
                .forEach(ds -> sitesById.put(ds.getId(), ds));

        Map<Long, String> catNames = new HashMap<>();
        Map<Long, Integer> catSiteCount = new HashMap<>();

        List<AtRiskDemandSiteResponse.AtRiskSite> sites = new ArrayList<>();

        for (AtRiskDemandSiteProjection p : projections) {
            DemandSite ds = sitesById.get(p.getId());
            List<String> catNamesForSite = Collections.emptyList();
            if (ds != null && ds.getCategories() != null) {
                catNamesForSite = ds.getCategories().stream()
                        .filter(c -> !c.isDisabled())
                        .map(c -> {
                            catNames.put(c.getId(), c.getName());
                            catSiteCount.merge(c.getId(), 1, Integer::sum);
                            return c.getName();
                        })
                        .collect(Collectors.toList());
            }
            sites.add(new AtRiskDemandSiteResponse.AtRiskSite(
                    p.getId(), p.getName(), p.getDomain(), p.getAvailableCount(), catNamesForSite));
        }

        List<AtRiskDemandSiteResponse.CategoryNeed> topNeeded = catSiteCount.entrySet().stream()
                .sorted(Map.Entry.<Long, Integer>comparingByValue().reversed())
                .map(e -> new AtRiskDemandSiteResponse.CategoryNeed(e.getKey(), catNames.get(e.getKey()), e.getValue()))
                .collect(Collectors.toList());

        return ResponseEntity.ok(new AtRiskDemandSiteResponse(threshold, sites, topNeeded));
    }
}
