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
    
    
    public DaMonthlyData forThisMonth(String user, String domain, Month month) {
        MozDomain mozDomain = mozFacade.checkDomain(user, domain);
        DaMonthlyData data = new DaMonthlyData();
        data.setDomain(domain);
        data.setDa(mozDomain.getDomain_authority());
        
        LocalDate now = LocalDate.now();
        data.setDate(LocalDate.of(now.getYear(), month, 1));
        
        return data;
    }
    
    public MozDomain getCurrent(String user, String domain) {
        return mozFacade.checkDomain(user, domain);
    }
}
