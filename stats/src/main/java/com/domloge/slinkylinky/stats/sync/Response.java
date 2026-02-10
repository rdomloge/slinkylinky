package com.domloge.slinkylinky.stats.sync;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class Response {
    private Embedded _embedded;
    private Page page;
}
