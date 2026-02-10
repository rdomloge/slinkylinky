package com.domloge.slinkylinky.stats;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication(scanBasePackages = {"com.domloge.slinkylinky"})
@EnableScheduling
public class StatsApplication {

	public static void main(String[] args) {
		SpringApplication.run(StatsApplication.class, args);
	}

}
