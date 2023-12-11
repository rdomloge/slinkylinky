package com.domloge.slinkylinky.linkservice.setup;
import java.util.List;

import com.domloge.slinkylinky.linkservice.Util;
import com.domloge.slinkylinky.linkservice.entity.Category;

import lombok.Getter;
import lombok.Setter;

@Getter 
@Setter
public class SetupSupplier {
    

    private String name;
    private String email;
    private int da;
    private String website;
    private String domain;
    private String weWriteFee;
    private String semRushAuthorityScore;
    private String semRushUkMonthlyTraffic;
    private String semRushUkJan23Traffic;
    private boolean thirdParty;

    private boolean disabled;

    private List<Category> categories;

    public void setWebsite(String website) {
        this.website = website;
        this.domain = Util.stripDomain(website);
    }
}
