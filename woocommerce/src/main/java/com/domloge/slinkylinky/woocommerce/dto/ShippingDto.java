package com.domloge.slinkylinky.woocommerce.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ShippingDto {
    // Same fields as Billing
    private String first_name;
    private String last_name;
    private String company;
    private String address_1;
    private String address_2;
    private String city;
    private String state;
    private String postcode;
    private String country;
    private String email;
    private String phone;
}