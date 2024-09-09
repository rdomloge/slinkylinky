package com.domloge.slinkylinky.stats.sync;

import java.time.Month;

import com.domloge.slinkylinky.stats.entity.AbstractMonthlyData;

public interface TemporalDataLoader<T extends AbstractMonthlyData> {
    
    T forMonth(String user, String domain, Month month);
}
