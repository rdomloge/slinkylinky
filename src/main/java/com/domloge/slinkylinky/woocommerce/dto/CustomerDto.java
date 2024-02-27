package com.domloge.slinkylinky.woocommerce.dto;

import java.util.List;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CustomerDto {

    private int id;
    private String date_created;
    private String date_created_gmt;
    private String date_modified;
    private String date_modified_gmt;
    private String email;
    private String first_name;
    private String last_name;
    private String role;
    private String username;
    private AddressDto billing;
    private AddressDto shipping;
    private boolean is_paying_customer;
    private String avatar_url;
    private List<MetaDataDto> meta_data;
    private LinksDto _links;

    // Getters and setters
}
