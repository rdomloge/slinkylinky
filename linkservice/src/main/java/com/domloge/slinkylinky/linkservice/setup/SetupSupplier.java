package com.domloge.slinkylinky.linkservice.setup;
import com.domloge.slinkylinky.linkservice.Util;

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

    private String category1, category2, category3, category4;

    public void setWebsite(String website) {
        this.website = website;
        this.domain = Util.stripDomain(website);
    }

    public String getCategory1() {
        if(category1.isEmpty()) {
            return null;
        }
        return category1;
    }

    public String getCategory2() {
        if(category2.isEmpty()) {
            return null;
        }
        return category2;
    }

    public String getCategory3() {
        if(category3.isEmpty()) {
            return null;
        }
        return category3;
    }

    public String getCategory4() {
        if(category4.isEmpty()) {
            return null;
        }
        return category4;
    }
}
