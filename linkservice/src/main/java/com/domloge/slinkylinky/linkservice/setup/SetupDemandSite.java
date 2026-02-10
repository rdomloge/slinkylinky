package com.domloge.slinkylinky.linkservice.setup;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SetupDemandSite {

    private String name;
    private String website;

    private String category1, category2, category3, category4;

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
