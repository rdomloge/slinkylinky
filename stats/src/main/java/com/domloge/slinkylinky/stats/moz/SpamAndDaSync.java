package com.domloge.slinkylinky.stats.moz;

import java.time.LocalDate;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.stats.dto.Supplier;
import com.domloge.slinkylinky.stats.repo.DaRepo;

@Component
public class SpamAndDaSync {
    
    @Autowired
    private DaRepo daRepo;

    public void sync(Supplier s) {

        LocalDate startDate = LocalDate.now().minusDays(365);
        // make it the start of the month
        startDate = startDate.minusDays(startDate.getDayOfMonth() - 1);
        LocalDate endDate = LocalDate.now();

        daRepo.findByDomainInTimeRange(s.getDomain(), startDate, endDate);
    }
}
