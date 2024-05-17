package com.domloge.slinkylinky.woocommerce.sync;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.woocommerce.dto.DemandSiteDto;
import com.domloge.slinkylinky.woocommerce.dto.LineItemUrlDetails;
import com.domloge.slinkylinky.woocommerce.dto.OrderDto;
import com.domloge.slinkylinky.woocommerce.entity.OrderEntity;
import com.domloge.slinkylinky.woocommerce.entity.OrderLineItemEntity;
import com.domloge.slinkylinky.woocommerce.repo.OrderLineItemRepo;
import com.domloge.slinkylinky.woocommerce.repo.OrderRepo;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class OrderProcessor {

    private static final SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
    
    @Value("${wc.user_agent:Mozilla/5.0}")
    private String userAgent;

    @Value("${linkservice_url}")
    private String linkService_base;

    @Autowired
    private CsvReader csvReader;

    @Autowired
    private OrderRepo orderRepo;

    @Autowired
    private OrderLineItemRepo lineItemRepo;

    @Autowired
    private HttpUtils httpUtils;

    private ObjectMapper mapper = new ObjectMapper();

    @Autowired
    private CommercePortalFacade commercePortalFacade;


    public OrderProcessor() {
        mapper.registerModule(new JavaTimeModule());
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        mapper.setSerializationInclusion(Include.NON_NULL);
        mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
    }

    @Transactional
    public void process(OrderDto order, String json) throws IOException {
        log.info("Processing order {}", order.getId());
        
        if(orderRepo.findByExternalId(order.getId()).isPresent()) {
            log.info("Order {} already processed - skipping", order.getId());
            return;
        }

        OrderEntity orderEntity = new OrderEntity();
        orderEntity.setExternalId(order.getId());
        orderEntity.setWooOrderJson(json);
        orderEntity.setBillingEmailAddress(order.getBilling().getEmail());
        orderEntity.setShippingEmailAddress(order.getShipping().getEmail());
        if(order.getShipping().getFirst_name() != null && ! order.getShipping().getFirst_name().isEmpty()) {
            orderEntity.setCustomerName(order.getShipping().getFirst_name() + " " + order.getShipping().getLast_name());
        }
        else {
            orderEntity.setCustomerName(order.getBilling().getFirst_name() + " " + order.getBilling().getLast_name());
        }
        orderRepo.save(orderEntity);

        List<OrderLineItemEntity> lineItems = new LinkedList<>();

        String name = order.getBilling().getFirst_name() + " " + order.getBilling().getLast_name();
        String csv = commercePortalFacade.fetchLineItemCsv(order);
        List<LineItemUrlDetails> details = csvReader.parse(csv);
        for (LineItemUrlDetails lineItem : details) {
            OrderLineItemEntity olie = processLineItem(name, lineItem, order);
            addPrice(olie, order, lineItem);
            lineItemRepo.save(olie);
            lineItems.add(olie);
        }
        orderEntity.setLineItems(lineItems);
        orderRepo.save(orderEntity);
        log.info("========================================================================================");
    }

    private void addPrice(OrderLineItemEntity olie, OrderDto order, LineItemUrlDetails lineItem) {
        long lineItemId = lineItem.getItemId();
        order.getLine_items().stream().
            filter(li -> li.getId() == lineItemId)
            .findFirst()
            .ifPresent(li -> {
                double price = li.getPrice();
                double tax = Double.parseDouble(li.getTotal_tax());
                long productId = li.getProduct_id();
                String productNameWithWordCount = li.getName();
                String productName = li.getParent_name();

                li.getMeta_data().stream()
                    .filter(md -> md.getKey().equals("word-count"))
                    .findFirst()
                    .ifPresent(md -> {
                        olie.setWordCount(Util.parseWordCountFromLineItemMetadata(md.getValue().toString()));
                    });

                olie.setPrice(price);
                olie.setTax(tax);
                olie.setProductId(productId);
                olie.setProductName(productName);
                olie.setProductNameWithWordCount(productNameWithWordCount);
        });
    }
    
    

    private OrderLineItemEntity processLineItem(String customerName, LineItemUrlDetails lineItem, OrderDto order) throws IOException {
        // Find the corresponding Demand Site
        DemandSiteDto demandSite = findDemandSite(lineItem, customerName);
        if(null == demandSite) {
            log.debug("No demand site found for {} - creating", lineItem.getTargetURL());
            String url = linkService_base + "/demandsites";
            Map<String, String> payload = new HashMap<>();
            payload.put("url", Util.stripDomain(lineItem.getTargetURL()));
            payload.put("name", customerName+" - "+Util.stripDomain(lineItem.getTargetURL()));
            payload.put("createdBy", "LinkySync");
            httpUtils.postForLocation(url, mapper.writeValueAsString(payload));
            demandSite = findDemandSite(lineItem, customerName);
        }
        if( ! demandSite.getName().equals(customerName)) {
            log.debug("Demand site {} does not match customer name {} - cannot process line item", demandSite.getName(), customerName);
            // return;
        }

        Map<String, Object> demandDetails = new HashMap<>();
        demandDetails.put("anchorText", lineItem.getAnchorTextOptional());
        demandDetails.put("url", lineItem.getTargetURL());
        demandDetails.put("daNeeded", ""+parseDaNeeded(lineItem.getDaOrdered()));
        demandDetails.put("requested", dateTimeFormat.format(order.getDate_created_gmt()));
        demandDetails.put("name", demandSite.getName());
        demandDetails.put("categories", demandSite.getCategories()
            .stream()
            .map(c -> "/.rest/categories/"+c.getId())
            .toArray(String[]::new));
        demandDetails.put("createdBy", customerName);
        demandDetails.put("source", "LinkSync");
        
        String location = httpUtils.postForLocation(linkService_base+"/demands", mapper.writeValueAsString(demandDetails));
        long demandId = Long.parseLong(location.substring(location.lastIndexOf('/') + 1));
        OrderLineItemEntity olie = new OrderLineItemEntity();
        olie.setDemandId(demandId);

        return olie; // need to return the demand dto
    }


    private int parseDaNeeded(String s) {
        // ""DA 20+""
        String regex = "DA (\\d+)";
        java.util.regex.Pattern pattern = java.util.regex.Pattern.compile(regex);
        java.util.regex.Matcher matcher = pattern.matcher(s);
        if(matcher.find()) {
            return Integer.parseInt(matcher.group(1));
        }
        return 0;
    }

    

    private DemandSiteDto findDemandSite(LineItemUrlDetails lineItem, String customerName) throws IOException {
        String targetURL = lineItem.getTargetURL();
        String domain = Util.stripDomain(targetURL);
        String linkServiceQueryUrl = linkService_base + "/demandsites/search/findByDomainIgnoreCase?projection=fullDemandSite&domain=" + domain;
        String response = httpUtils.get(linkServiceQueryUrl);
        if(null == response) {
            log.debug("No demand site found for {}", domain);
            return null;
        }
        else {
            log.debug("Found demand site: {}", domain);
            return mapper.readValue(response, DemandSiteDto.class);
        }
    }

    
}
