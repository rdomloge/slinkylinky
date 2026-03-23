package com.domloge.slinkylinky.stats.dto;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ResponsivenessDataPoint {
    private long supplierId;
    private String supplierDomain;
    private LocalDateTime dateSentToSupplier;
    private LocalDateTime dateBlogLive;
}
