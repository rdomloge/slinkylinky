package com.domloge.slinkylinky.stats;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication(scanBasePackages = {"com.domloge.slinkylinky"})
public class StatsApplication {

	public static void main(String[] args) {
		SpringApplication.run(StatsApplication.class, args);
	}

}
