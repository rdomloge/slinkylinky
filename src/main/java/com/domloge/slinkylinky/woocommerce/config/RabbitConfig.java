package com.domloge.slinkylinky.woocommerce.config;

import org.springframework.amqp.core.AmqpAdmin;
import org.springframework.amqp.core.Binding;
import org.springframework.amqp.core.BindingBuilder;
import org.springframework.amqp.core.DirectExchange;
import org.springframework.amqp.core.FanoutExchange;
import org.springframework.amqp.core.Queue;
import org.springframework.amqp.rabbit.connection.CachingConnectionFactory;
import org.springframework.amqp.rabbit.connection.ConnectionFactory;
import org.springframework.amqp.rabbit.core.RabbitAdmin;
import org.springframework.amqp.rabbit.listener.SimpleMessageListenerContainer;
import org.springframework.amqp.rabbit.listener.adapter.MessageListenerAdapter;
import org.springframework.amqp.support.converter.Jackson2JsonMessageConverter;
import org.springframework.amqp.support.converter.MessageConverter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.domloge.slinkylinky.woocommerce.sync.ProposalEventReceiver;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

@Configuration
public class RabbitConfig {

    @Value("${rabbitmq.woocommerce.proposals.queue}")
    private String proposalsQueueName;


    @Value("${rabbitmq.proposals.exchange}")
    private String proposalsExchange;

    // @Value("${rabbitmq.proposals.routingkey}")
    // private String proposalsRoutingkey;


    @Value("${rabbitmq.username}")
    private String username;

    @Value("${rabbitmq.password}")
    private String password;

    @Value("${rabbitmq.host}")
    private String host;

    @Value("${rabbitmq.virtualhost}")
    private String virtualHost;

    @Value("${rabbitmq.reply.timeout}")
    private Integer replyTimeout;


    @Bean
    public Queue proposalsQueue() {
        return new Queue(proposalsQueueName, false);
    }

    @Bean
    public Binding proposalsBinding(Queue proposalsQueue, FanoutExchange proposalsExchange) {
        return BindingBuilder.bind(proposalsQueue).to(proposalsExchange);
    }


    @Bean
    public FanoutExchange proposalsExchange() {
        return new FanoutExchange(proposalsExchange);
    }

    @Bean
    public MessageConverter jsonMessageConverter() {
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());
        objectMapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        objectMapper.setSerializationInclusion(Include.NON_NULL);
        return new Jackson2JsonMessageConverter(objectMapper);
    }
    @Bean()
    public AmqpAdmin admin(ConnectionFactory connectionFactory) {
        return new RabbitAdmin(connectionFactory);
    }


    @Bean
    SimpleMessageListenerContainer container(ConnectionFactory connectionFactory,
            MessageListenerAdapter listenerAdapter) {
        SimpleMessageListenerContainer container = new SimpleMessageListenerContainer();
        container.setConnectionFactory(connectionFactory);
        container.setQueueNames(proposalsQueueName);
        container.setMessageListener(listenerAdapter);
        return container;
    }

    @Bean
    public ConnectionFactory connectionFactory() {
        CachingConnectionFactory connectionFactory = new CachingConnectionFactory();
        connectionFactory.setVirtualHost(virtualHost);
        connectionFactory.setHost(host);
        connectionFactory.setUsername(username);
        connectionFactory.setPassword(password);
        return connectionFactory;
    }

    @Bean
    public MessageListenerAdapter listenerAdapter(ProposalEventReceiver receiver) {
        return new MessageListenerAdapter(receiver, "receiveMessage");
    }

}
