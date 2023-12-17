package com.domloge.slinkylinky.linkservice.setup;

import java.time.LocalDateTime;
import java.util.List;

import com.domloge.slinkylinky.linkservice.entity.Category;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SetupDemand {
    
    private String name;
    private String url;
    private String daNeeded;
    private String anchorText;
    private String domain;
    private String requested;
    private String createdBy;
    private String postTitle;
    private String postPlacement;

    public int getDaNeededInt() {
        if("DA10+BRONZE".equalsIgnoreCase(getDaNeeded())) return 10;
        if("DA20+SILVER".equalsIgnoreCase(getDaNeeded())) return 20;
        if("DA30+GOLD".equalsIgnoreCase(getDaNeeded())) return 30;
        throw new RuntimeException("Cannot understand "+getDaNeeded());    
    }

    private List<Category> categories;
}
