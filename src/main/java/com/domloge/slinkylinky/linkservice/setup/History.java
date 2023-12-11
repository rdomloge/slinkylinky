package com.domloge.slinkylinky.linkservice.setup;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class History {

    private int month;
    private String companyName;
    private String daNeeded;
    private String anchorText;
    private String url;
    private String requested;
    private String da;
    private String postTitle;
    private String postPlacement;
    private String name;
    private String Link_Insert_or_blog;
    private String cost;
    private String delivered;
    private String bloggerWebsite;
    private String category;
    private String clientWebsite;
    private String Copy_of_blogger_website;
    private String Client_and_blog_combined;

    public int getDaNeededInt() {
        if("DA10+BRONZE".equalsIgnoreCase(getDaNeeded())) return 10;
        if("DA20+SILVER".equalsIgnoreCase(getDaNeeded())) return 20;
        if("DA30+GOLD".equalsIgnoreCase(getDaNeeded())) return 30;
        throw new RuntimeException("Cannot understand "+getDa());    
    }
    
    public int getCostInt() {
        return Integer.parseInt(cost.replace("£", ""));
    }
}
