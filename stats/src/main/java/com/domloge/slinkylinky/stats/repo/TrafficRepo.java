package com.domloge.slinkylinky.stats.repo;

import java.time.LocalDate;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.web.bind.annotation.CrossOrigin;

import com.domloge.slinkylinky.stats.entity.SemRushMonthlyData;

// @RepositoryRestResource(collectionResourceRel = "semrush", path = "stats")
@CrossOrigin(exposedHeaders = "*")
public interface TrafficRepo extends CrudRepository<SemRushMonthlyData, Long>, PagingAndSortingRepository<SemRushMonthlyData, Long>, TemporalRepo<SemRushMonthlyData> {


    @Query("select s from SemRushMonthlyData s where s.domain = ?1 and s.date >= ?2 and s.date <= ?3 order by s.date asc")
    SemRushMonthlyData[] findByDomainInTimeRange(String domain,
        LocalDate startDate, LocalDate endDate);

    default void saveMonth(SemRushMonthlyData missingMonth) {
        save(missingMonth);
    }
    
}
