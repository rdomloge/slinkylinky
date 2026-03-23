package com.domloge.slinkylinky.woocommerce.dto;

import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class LineItemDto {
    private int id;
    private String name;
    private int product_id;
    private int variation_id;
    private int quantity;
    private String tax_class;
    private String subtotal;
    private String subtotal_tax;
    private String total;
    private String total_tax;
    private List<TaxDto> taxes;
    private List<MetaDataDto> meta_data;
    private String sku;
    private double price;
    private ImageDto image;
    private String parent_name;

    // Getters and setters
}