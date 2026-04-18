package com.domloge.slinkylinky.stats.repo;

import java.time.LocalDate;
import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;

import com.domloge.slinkylinky.stats.entity.SpamMonthlyData;

public interface SpamRepo extends CrudRepository<SpamMonthlyData, Long>, PagingAndSortingRepository<SpamMonthlyData, Long>, TemporalRepo<SpamMonthlyData> {

    @Query("select s from SpamMonthlyData s where s.domain = ?1 and s.date >= ?2 and s.date <= ?3 order by s.date asc")
    SpamMonthlyData[] findByDomainInTimeRange(String domain,
        LocalDate startDate, LocalDate endDate);

    @Query("SELECT DISTINCT s.domain FROM SpamMonthlyData s " +
           "WHERE s.spamScore > :threshold " +
           "AND s.date = (SELECT MAX(s2.date) FROM SpamMonthlyData s2 WHERE s2.domain = s.domain)")
    List<String> findDomainsAboveSpamThreshold(@Param("threshold") int threshold);

    default void saveMonth(SpamMonthlyData missingMonth) {
        save(missingMonth);
    }
}
