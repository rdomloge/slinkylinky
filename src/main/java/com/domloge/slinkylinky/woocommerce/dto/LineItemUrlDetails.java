package com.domloge.slinkylinky.woocommerce.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@ToString
@Getter
@Setter
public class LineItemUrlDetails {
    String daOrdered;
    
    String chooseWordCount;

    String anchorTextOptional;

    String targetURL;
}
