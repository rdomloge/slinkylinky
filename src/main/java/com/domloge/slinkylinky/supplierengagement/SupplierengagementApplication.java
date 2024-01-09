package com.domloge.slinkylinky.supplierengagement;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication(scanBasePackages = {"com.domloge.slinkylinky"})
@EnableAutoConfiguration(exclude={org.springframework.boot.autoconfigure.amqp.RabbitAutoConfiguration.class})
public class SupplierengagementApplication {

	public static void main(String[] args) {
		SpringApplication.run(SupplierengagementApplication.class, args);
	}

}
