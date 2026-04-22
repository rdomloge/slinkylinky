package com.domloge.slinkylinky.woocommerce.repo;

import java.time.LocalDateTime;
import java.util.Optional;

import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.domloge.slinkylinky.events.AuditEvent;
import com.domloge.slinkylinky.woocommerce.entity.OrderEntity;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping(".rest/orders")
public class OrderSupport {
    
    @Autowired
    private OrderRepo orderRepo;

    @Autowired
    private AmqpTemplate auditTemplate;

    private ObjectMapper mapper = new ObjectMapper();

    public OrderSupport() {
        mapper.registerModule(new JavaTimeModule());
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        mapper.setSerializationInclusion(Include.NON_NULL);
        mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
    }


    @GetMapping(path = "/archiveorder", produces = "application/json")
    @ResponseBody
    public ResponseEntity<OrderEntity> archiveOrder(@RequestParam long id, @RequestHeader String user) {

        Optional<OrderEntity> orderOpt = orderRepo.findById(id);
        if(orderOpt.isPresent()) {
            OrderEntity order = orderOpt.get();
            order.setArchived(true);
            orderRepo.save(order);

            AuditEvent auditEvent = new AuditEvent();
            auditEvent.setEntityType("OrderEntity");
            auditEvent.setEventTime(LocalDateTime.now());
            auditEvent.setEntityId(String.valueOf(order.getId()));
            auditEvent.setWhat("Order " + order.getExternalId() + " archived");
            try {
                auditEvent.setDetail(mapper.writeValueAsString(order));
            }
            catch (JsonProcessingException e) {
                auditEvent.setDetail("Failed to serialize order");
            }
            auditEvent.setWho(user);
            auditTemplate.convertAndSend(auditEvent);
            log.info("Audit record sent");


            return ResponseEntity.ok(order);
        }
        else {
            return ResponseEntity.notFound().build();
        }
    }
}
