package com.domloge.slinkylinky.woocommerce.dto;


import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class DemandSiteDto {
    private String name;
    private int id;
    private String url;
    private String createdBy;
    private List<Category> categories;
    private String email;
    private String domain;

    @Getter
    @Setter
    @ToString
    public static class Category {
        private String name;
        private boolean disabled;
        private long id;
    }
    
}