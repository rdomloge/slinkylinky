package com.domloge.slinkylinky.woocommerce;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class WoocommerceApplication {

	public static void main(String[] args) {
		SpringApplication.run(WoocommerceApplication.class, args);
	}

}
