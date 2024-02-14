package com.domloge.slinkylinky.stats.repo;

import java.time.LocalDate;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.PagingAndSortingRepository;

import com.domloge.slinkylinky.stats.entity.SpamMonthlyData;

public interface SpamRepo extends CrudRepository<SpamMonthlyData, Long>, PagingAndSortingRepository<SpamMonthlyData, Long>, TemporalRepo<SpamMonthlyData> {
    
    @Query("select s from SpamMonthlyData s where s.domain = ?1 and s.date >= ?2 and s.date <= ?3 order by s.date asc")
    SpamMonthlyData[] findByDomainInTimeRange(String domain,
        LocalDate startDate, LocalDate endDate);

    default void saveMonth(SpamMonthlyData missingMonth) {
        save(missingMonth);
    }
}
