package com.domloge.slinkylinky.audit;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@EnableAutoConfiguration(exclude={org.springframework.boot.autoconfigure.amqp.RabbitAutoConfiguration.class})
public class AuditApplication {

	public static void main(String[] args) {
		SpringApplication.run(AuditApplication.class, args);
	}

}
