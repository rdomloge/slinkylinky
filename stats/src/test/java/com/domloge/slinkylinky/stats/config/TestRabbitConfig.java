package com.domloge.slinkylinky.stats.config;

import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

import static org.mockito.Mockito.mock;

@Configuration
@Profile("test")
public class TestRabbitConfig {

    @Bean
    public AmqpTemplate auditRabbitTemplate() {
        return mock(AmqpTemplate.class);
    }
}
