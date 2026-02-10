package com.domloge.slinkylinky.stats.moz;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MozLinkResponse {

    private MozPageLink[] results;
    private String next_token;
    
}
