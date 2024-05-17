package com.domloge.slinkylinky.stats.moz;

import java.time.LocalDate;
import java.time.Month;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.stats.entity.SpamMonthlyData;

@Component
public class SpamChecker {

    @Autowired
    private MozFacade mozFacade;
    

    public SpamMonthlyData forThisMonth(String domain, Month ignoreMe) {
        MozDomain mozDomain = mozFacade.checkDomain(domain);
        SpamMonthlyData data = new SpamMonthlyData();
        data.setDomain(domain);
        data.setSpamScore(mozDomain.getSpam_score());
        // data.setDate(LocalDate.now());
        data.setDate(LocalDate.now().withMonth(ignoreMe.getValue()));
        return data;
    }
}
