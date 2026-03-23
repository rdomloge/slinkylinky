package com.domloge.slinkylinky.linkservice.controller;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class ResponsivenessDataPoint {
    private long supplierId;
    private String supplierDomain;
    private LocalDateTime dateSentToSupplier;
    private LocalDateTime dateBlogLive;
}
