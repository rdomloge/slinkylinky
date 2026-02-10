package com.domloge.slinkylinky.stats.repo;

import java.time.LocalDate;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.PagingAndSortingRepository;

import com.domloge.slinkylinky.stats.entity.DaMonthlyData;

public interface DaRepo extends CrudRepository<DaMonthlyData, Long>, PagingAndSortingRepository<DaMonthlyData, Long>, TemporalRepo<DaMonthlyData> {
    
    @Query("select s from DaMonthlyData s where s.domain = ?1 and s.date >= ?2 and s.date <= ?3 order by s.date asc")
    DaMonthlyData[] findByDomainInTimeRange(String domain,
        LocalDate startDate, LocalDate endDate);

    DaMonthlyData findByDomainAndUniqueYearMonth(String domain, String uniqueYearMonth);
        
    default void saveMonth(DaMonthlyData missingMonth) {
        save(missingMonth);
    }
}
