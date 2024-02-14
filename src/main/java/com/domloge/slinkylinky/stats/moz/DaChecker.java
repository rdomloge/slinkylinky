package com.domloge.slinkylinky.stats.moz;

import java.time.LocalDate;
import java.time.Month;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.stats.entity.DaMonthlyData;

@Component
public class DaChecker {
    
    @Autowired
    private MozFacade mozFacade;
    
    
    public DaMonthlyData forThisMonth(String domain, Month ignoreMe) {
        MozDomain mozDomain = mozFacade.checkDomain(domain);
        DaMonthlyData data = new DaMonthlyData();
        data.setDomain(domain);
        data.setDa(mozDomain.getDomain_authority());
        data.setDate(LocalDate.now());
        return data;
    }
    
    public MozDomain getCurrent(String domain) {
        return mozFacade.checkDomain(domain);
    }
}
