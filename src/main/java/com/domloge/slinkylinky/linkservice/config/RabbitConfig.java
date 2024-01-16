package com.domloge.slinkylinky.linkservice.config;

import org.springframework.amqp.core.AmqpAdmin;
import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.amqp.core.Binding;
import org.springframework.amqp.core.BindingBuilder;
import org.springframework.amqp.core.DirectExchange;
import org.springframework.amqp.core.Queue;
import org.springframework.amqp.rabbit.annotation.EnableRabbit;
import org.springframework.amqp.rabbit.config.SimpleRabbitListenerContainerFactory;
import org.springframework.amqp.rabbit.connection.CachingConnectionFactory;
import org.springframework.amqp.rabbit.connection.ConnectionFactory;
import org.springframework.amqp.rabbit.core.RabbitAdmin;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.amqp.rabbit.listener.ConditionalRejectingErrorHandler;
import org.springframework.amqp.rabbit.listener.SimpleMessageListenerContainer;
import org.springframework.amqp.rabbit.listener.adapter.MessageListenerAdapter;
import org.springframework.amqp.rabbit.support.ListenerExecutionFailedException;
import org.springframework.amqp.support.converter.Jackson2JsonMessageConverter;
import org.springframework.amqp.support.converter.MessageConverter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.util.ErrorHandler;

import com.domloge.slinkylinky.linkservice.amqp.SupplierEngagementEventReceiver;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

@EnableRabbit
@Configuration
public class RabbitConfig {

    @Value("${rabbitmq.proposals.queue}")
    private String proposalsQueueName;

    @Value("${rabbitmq.audit.queue}")
    private String auditQueueName;

    @Value("${rabbitmq.supplierengagement.queue}")
    private String supplierEngagementQueueName;

    @Value("${rabbitmq.exchange}")
    private String exchange;

    @Value("${rabbitmq.proposals.routingkey}")
    private String proposalsRoutingkey;

    @Value("${rabbitmq.audit.routingkey}")
    private String auditRoutingkey;

    @Value("${rabbitmq.supplierengagement.routingkey}")
    private String supplierEngagementRoutingkey;

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

    @Value("${rabbitmq.concurrent.consumers}")
    private Integer concurrentConsumers;

    @Value("${rabbitmq.max.concurrent.consumers}")
    private Integer maxConcurrentConsumers;

    @Bean
    public Queue proposalsQueue() {
        return new Queue(proposalsQueueName, false);
    }

    @Bean
    public Queue auditQueue() {
        return new Queue(auditQueueName, false);
    }

    @Bean
    public Queue supplierEngagementQueue() {
        return new Queue(supplierEngagementQueueName, false);
    }

    @Bean
    public DirectExchange exchange() {
        return new DirectExchange(exchange);
    }

    @Bean
    public Binding proposalsBinding(Queue proposalsQueue, DirectExchange exchange) {
        return BindingBuilder.bind(proposalsQueue).to(exchange).with(proposalsRoutingkey);
    }

    @Bean Binding auditBinding(Queue auditQueue, DirectExchange exchange) {
        return BindingBuilder.bind(auditQueue).to(exchange).with(auditRoutingkey);
    }

    @Bean Binding supplierEngagementBinding(Queue supplierEngagementQueue, DirectExchange exchange) {
        return BindingBuilder.bind(supplierEngagementQueue).to(exchange).with(supplierEngagementRoutingkey);
    }

    @Bean
    public MessageConverter jsonMessageConverter() {
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());
        objectMapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        objectMapper.setSerializationInclusion(Include.NON_NULL);
        return new Jackson2JsonMessageConverter(objectMapper);
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
    public AmqpTemplate proposalsRabbitTemplate(ConnectionFactory connectionFactory) {
        final RabbitTemplate rabbitTemplate = new RabbitTemplate(connectionFactory);
        rabbitTemplate.setDefaultReceiveQueue(proposalsQueueName);
        rabbitTemplate.setExchange(exchange);
        rabbitTemplate.setMessageConverter(jsonMessageConverter());
        rabbitTemplate.setReplyAddress(proposalsQueue().getName());
        rabbitTemplate.setRoutingKey(proposalsRoutingkey);
        rabbitTemplate.setReplyTimeout(replyTimeout);
        rabbitTemplate.setUseDirectReplyToContainer(false);
        return rabbitTemplate;
    }

    @Bean AmqpTemplate auditRabbitTemplate(ConnectionFactory connectionFactory) {
        final RabbitTemplate rabbitTemplate = new RabbitTemplate(connectionFactory);
        rabbitTemplate.setDefaultReceiveQueue(auditQueueName);
        rabbitTemplate.setExchange(exchange);
        rabbitTemplate.setMessageConverter(jsonMessageConverter());
        rabbitTemplate.setReplyAddress(auditQueue().getName());
        rabbitTemplate.setRoutingKey(auditRoutingkey);
        rabbitTemplate.setReplyTimeout(replyTimeout);
        rabbitTemplate.setUseDirectReplyToContainer(false);
        return rabbitTemplate;
    }

    @Bean
    public AmqpAdmin amqpAdmin() {
        return new RabbitAdmin(connectionFactory());
    }

    // @Bean
    // public SimpleRabbitListenerContainerFactory rabbitListenerContainerFactory() {
    //     final SimpleRabbitListenerContainerFactory factory = new SimpleRabbitListenerContainerFactory();
    //     factory.setConnectionFactory(connectionFactory());
    //     factory.setMessageConverter(jsonMessageConverter());
    //     factory.setConcurrentConsumers(concurrentConsumers);
    //     factory.setMaxConcurrentConsumers(maxConcurrentConsumers);
    //     factory.setErrorHandler(errorHandler());
    //     return factory;
    // }
    @Bean
    SimpleMessageListenerContainer container(ConnectionFactory connectionFactory,
            MessageListenerAdapter listenerAdapter) {
        SimpleMessageListenerContainer container = new SimpleMessageListenerContainer();
        container.setConnectionFactory(connectionFactory);
        container.setQueueNames(supplierEngagementQueueName);
        container.setMessageListener(listenerAdapter);
        return container;
    }

    @Bean
    public MessageListenerAdapter listenerAdapter(SupplierEngagementEventReceiver receiver) {
        return new MessageListenerAdapter(receiver, "receiveMessage");
    }

    @Bean
    public ErrorHandler errorHandler() {
        return new ConditionalRejectingErrorHandler(new MyFatalExceptionStrategy());
    }

    public static class MyFatalExceptionStrategy extends ConditionalRejectingErrorHandler.DefaultExceptionStrategy {
        @Override
        public boolean isFatal(Throwable t) {
            if (t instanceof ListenerExecutionFailedException) {
                ListenerExecutionFailedException lefe = (ListenerExecutionFailedException) t;
                logger.error("Failed to process inbound message from queue "
                        + lefe.getFailedMessage().getMessageProperties().getConsumerQueue()
                        + "; failed message: " + lefe.getFailedMessage(), t);
            }
            return super.isFatal(t);
        }
    }
}