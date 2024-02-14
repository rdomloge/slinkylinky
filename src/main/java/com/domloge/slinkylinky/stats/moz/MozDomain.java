package com.domloge.slinkylinky.stats.moz;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MozDomain {

    private int domain_authority;

    private int page_authority;

    private int spam_score;
}
