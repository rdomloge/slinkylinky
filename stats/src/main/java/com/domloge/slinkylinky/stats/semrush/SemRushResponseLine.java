package com.domloge.slinkylinky.stats.semrush;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SemRushResponseLine {
    
    private String organicTraffic;
    private String rank;
    private String date;

    public LocalDate getDate() {
        return LocalDate.parse(date, DateTimeFormatter.BASIC_ISO_DATE);
    }

    public long getOrganicTraffic() {
        return Long.parseLong(organicTraffic);
    }

    public long getRank() {
        return Long.parseLong(rank);
    }
}
