package com.domloge.slinkylinky.woocommerce.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@ToString
@Getter
@Setter
public class LineItemUrlDetails {

    long itemId;

    String daOrdered;
    
    String chooseWordCount;

    String anchorTextOptional;

    String targetURL;
}
