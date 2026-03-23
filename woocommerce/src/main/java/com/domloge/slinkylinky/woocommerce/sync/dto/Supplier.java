package com.domloge.slinkylinky.woocommerce.sync.dto;

import lombok.Getter;
import lombok.Setter;

@Getter 
@Setter
public class Supplier {
    private long id;

    private long createdDate;

    private long modifiedDate = 0;

    private String name;
    private String email;
    private int da;
    private String website;
    private String domain;
    private int weWriteFee;
    private String weWriteFeeCurrency;
    private boolean thirdParty;
    private String source;

    private boolean disabled;

    private String createdBy;
    private String updatedBy;   


    private Long version;
}
