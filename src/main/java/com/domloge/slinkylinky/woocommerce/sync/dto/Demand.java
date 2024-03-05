package com.domloge.slinkylinky.woocommerce.sync.dto;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;


@Getter 
@Setter
public class Demand {

    private long id;

    private String name;
    private String url;
    private int daNeeded;
    private String anchorText;
    private String domain;
    private LocalDateTime requested;
    private String createdBy;
    private String updatedBy;
    private String source;


}
