package com.domloge.slinkylinky.stats.dto;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class DataPoint {
    
    private long traffic;

    private long srrank;

    private int da;

    private int spamScore;

    private String yearMonth;
}
