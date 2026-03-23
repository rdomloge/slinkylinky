package com.domloge.slinkylinky.woocommerce.sync;

import com.domloge.slinkylinky.woocommerce.dto.OrderDto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class OrderJsonWrapper {
    private OrderDto[] orders;
    private String json;
}
