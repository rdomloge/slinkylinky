package com.domloge.slinkylinky.woocommerce.dto;

import java.util.Date;
import java.util.List;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class OrderDto {
    private long id;
    private int parent_id;
    private String status;
    private String currency;
    private String version;
    private boolean prices_include_tax;
    private Date date_created;
    private Date date_modified;
    private String discount_total;
    private String discount_tax;
    private String shipping_total;
    private String shipping_tax;
    private String cart_tax;
    private String total;
    private String total_tax;
    private int customer_id;
    private String order_key;
    private BillingDto billing;
    private ShippingDto shipping;
    private String payment_method;
    private String payment_method_title;
    private String transaction_id;
    private String customer_ip_address;
    private String customer_user_agent;
    private String created_via;
    private String customer_note;
    private Date date_completed;
    private Date date_paid;
    private String cart_hash;
    private String number;
    private List<MetaDataDto> meta_data;
    private List<LineItemDto> line_items;
    private List<TaxLineDto> tax_lines;
    private List<Object> shipping_lines; // These lists could be more specific if their structure is known
    private List<Object> fee_lines;
    private List<Object> coupon_lines;
    private List<Object> refunds;
    private String payment_url;
    private boolean is_editable;
    private boolean needs_payment;
    private boolean needs_processing;
    private Date date_created_gmt;
    private Date date_modified_gmt;
    private Date date_completed_gmt;
    private Date date_paid_gmt;
    private String currency_symbol;
    private LinksDto _links;

    // Getters and setters
}

// Note: Some fields are simplified or omitted for brevity. You may need to adjust types and add missing fields and classes based on the complete JSON structure.

