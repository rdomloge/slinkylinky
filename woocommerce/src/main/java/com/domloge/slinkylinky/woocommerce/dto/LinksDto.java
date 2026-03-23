package com.domloge.slinkylinky.woocommerce.dto;

import java.util.List;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class LinksDto {
    private List<LinkDto> self;
    private List<LinkDto> collection;

    // Getters and setters
}