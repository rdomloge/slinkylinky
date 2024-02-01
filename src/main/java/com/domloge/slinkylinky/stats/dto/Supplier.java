package com.domloge.slinkylinky.stats.dto;

import java.util.List;
import java.util.Locale.Category;

import com.domloge.slinkylinky.stats.Util;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter 
@Setter
@ToString
public class Supplier {
    private long id;

    private String name;
    private String email;
    private int da;
    private String website;
    private String domain;
    private int weWriteFee;
    private String weWriteFeeCurrency;
    private int semRushAuthorityScore;
    private int semRushUkMonthlyTraffic;
    private int semRushUkJan23Traffic;
    private boolean thirdParty;
    private String source;

    private boolean disabled;

    private String createdBy;
    private String updatedBy;   

    private List<Category> categories;

    public void setWebsite(String website) {
        this.website = website;
        if(null != website && !website.isEmpty()) {
            this.domain = Util.stripDomain(website);
        }
        else {
            this.domain = null;
        }
    }
}
