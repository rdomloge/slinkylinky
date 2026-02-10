package com.domloge.slinkylinky.stats.repo;

import java.time.LocalDate;

import com.domloge.slinkylinky.stats.entity.AbstractMonthlyData;

public interface TemporalRepo<T extends AbstractMonthlyData> {
    
    T [] findByDomainInTimeRange(String domain, LocalDate startDate, LocalDate endDate);

    void saveMonth(T missingMonth);
}
