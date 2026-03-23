package com.domloge.slinkylinky.woocommerce.sync.dto;

import lombok.Getter;
import lombok.Setter;

@Getter 
@Setter
public class  PaidLink {

    private long id;
    
    private Supplier supplier;

    private Demand demand;

    
}
