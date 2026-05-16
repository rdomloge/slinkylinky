package com.domloge.slinkylinky.supplierengagement.email;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeSet;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.messaging.MessagingException;
import org.springframework.stereotype.Component;
import org.springframework.ui.freemarker.FreeMarkerTemplateUtils;
import org.springframework.web.servlet.view.freemarker.FreeMarkerConfigurer;

import com.domloge.slinkylinky.supplierengagement.entity.MappingStatus;
import com.domloge.slinkylinky.supplierengagement.entity.SupplierLead;
import com.domloge.slinkylinky.supplierengagement.repo.CollaboratorCategoryMappingRepo;

import freemarker.template.Template;
import freemarker.template.TemplateException;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class LeadEmailContentBuilder {

    @Autowired
    private FreeMarkerConfigurer freemarkerConfigurer;

    @Autowired
    private CollaboratorCategoryMappingRepo mappingRepo;

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
        List<String> mappedCategoryNames = resolveMappedCategoryNames(lead);

        Map<String, Object> model = new HashMap<>();
        model.put("domain",               lead.getDomain());
        model.put("responseUrl",          responseUrl);
        model.put("suggestedFee",         suggestedFee);
        model.put("currencySymbol",       currencySymbol);
        model.put("signoff",              signoff);
        model.put("signoffContactDetails", signoffContactDetails);
        model.put("mappedCategoryNames",  mappedCategoryNames);

        try {
            Template template = freemarkerConfigurer.getConfiguration().getTemplate("lead-outreach.ftl");
            return FreeMarkerTemplateUtils.processTemplateIntoString(template, model);
        } catch (MessagingException | IOException | TemplateException e) {
            log.error("Error building lead outreach email content", e);
            return "Error building lead outreach email content";
        }
    }

    private List<String> resolveMappedCategoryNames(SupplierLead lead) {
        if (lead.getCategories() == null || lead.getCategories().isEmpty()) return List.of();
        TreeSet<String> names = new TreeSet<>(String.CASE_INSENSITIVE_ORDER);
        for (String cat : lead.getCategories()) {
            if (cat == null || cat.isBlank()) continue;
            mappingRepo.findByCollaboratorCategory(cat).ifPresent(m -> {
                if (m.getStatus() == MappingStatus.MAPPED && m.getSlCategoryName() != null
                        && !m.getSlCategoryName().isBlank()) {
                    names.add(m.getSlCategoryName());
                }
            });
        }
        return List.copyOf(names);
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
