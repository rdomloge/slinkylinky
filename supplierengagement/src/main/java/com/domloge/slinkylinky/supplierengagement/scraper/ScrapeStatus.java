package com.domloge.slinkylinky.supplierengagement.scraper;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class ScrapeStatus {
    private final boolean running;
    private final int leadsFound;
    private final String source;
    private final String errorMessage; // null = no error
}
