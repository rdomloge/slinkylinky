package com.domloge.slinkylinky.linkservice.controller;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter @Setter @AllArgsConstructor
public class SupplierOnboardingResponse {
    private long thisMonth;
    private List<MonthCount> history;

    @Getter @Setter @AllArgsConstructor
    public static class MonthCount {
        private String yearMonth;
        private long count;
    }
}
