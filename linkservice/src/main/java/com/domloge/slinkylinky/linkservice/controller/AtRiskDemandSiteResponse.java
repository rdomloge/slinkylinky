package com.domloge.slinkylinky.linkservice.controller;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter @Setter @AllArgsConstructor
public class AtRiskDemandSiteResponse {
    private int threshold;
    private List<AtRiskSite> sites;
    private List<CategoryNeed> topNeededCategories;

    @Getter @Setter @AllArgsConstructor
    public static class AtRiskSite {
        private long id;
        private String name;
        private String domain;
        private long availableCount;
        private List<String> neededCategories;
    }

    @Getter @Setter @AllArgsConstructor
    public static class CategoryNeed {
        private long categoryId;
        private String categoryName;
        private int siteCount;
    }
}
