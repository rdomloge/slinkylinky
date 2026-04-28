package com.domloge.slinkylinky.supplierengagement.email;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.messaging.MessagingException;
import org.springframework.stereotype.Component;
import org.springframework.ui.freemarker.FreeMarkerTemplateUtils;
import org.springframework.web.servlet.view.freemarker.FreeMarkerConfigurer;

import com.domloge.slinkylinky.supplierengagement.entity.SupplierLead;

import freemarker.template.Template;
import freemarker.template.TemplateException;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class LeadEmailContentBuilder {

    @Autowired
    private FreeMarkerConfigurer freemarkerConfigurer;

    @Value("${slinkyLinky.domain}")
    private String slinkyLinkyDomain;

    @Value("${spring.mail.requestsignoff}")
    private String signoff;

    @Value("${spring.mail.requestcontact}")
    private String signoffContactDetails;

    public String buildOutreachContent(SupplierLead lead) {
        String responseUrl = slinkyLinkyDomain + "/public/leadresponse?guid=" + lead.getGuid();
        String suggestedFee = calculateSuggestedFee(lead.getPrice());
        String currencySymbol = getCurrencySymbol(lead.getCurrency());

        Map<String, Object> model = new HashMap<>();
        model.put("domain",               lead.getDomain());
        model.put("responseUrl",          responseUrl);
        model.put("suggestedFee",         suggestedFee);
        model.put("currencySymbol",       currencySymbol);
        model.put("signoff",              signoff);
        model.put("signoffContactDetails", signoffContactDetails);

        try {
            Template template = freemarkerConfigurer.getConfiguration().getTemplate("lead-outreach.ftl");
            return FreeMarkerTemplateUtils.processTemplateIntoString(template, model);
        } catch (MessagingException | IOException | TemplateException e) {
            log.error("Error building lead outreach email content", e);
            return "Error building lead outreach email content";
        }
    }

    private String calculateSuggestedFee(java.math.BigDecimal price) {
        if (price == null) {
            return "contact us";
        }
        long priceAsLong = price.longValue();
        long roundedDown = (priceAsLong / 5) * 5;
        return String.valueOf(roundedDown);
    }

    private String getCurrencySymbol(String currencyCode) {
        if (currencyCode == null || currencyCode.isEmpty()) {
            return "";
        }
        if (currencyCode.length() == 3) {
            try {
                return java.util.Currency.getInstance(currencyCode).getSymbol();
            } catch (IllegalArgumentException e) {
                log.warn("Invalid currency code: {}", currencyCode);
                return "";
            }
        }
        return currencyCode;
    }
}
