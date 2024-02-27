package com.domloge.slinkylinky.woocommerce.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AddressDto {
    private String first_name;
    private String last_name;
    private String company;
    private String address_1;
    private String address_2;
    private String city;
    private String postcode;
    private String country;
    private String state;
    private String email;
    private String phone;

    // Getters and setters
}