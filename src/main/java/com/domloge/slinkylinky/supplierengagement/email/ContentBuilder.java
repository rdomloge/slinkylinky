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

import freemarker.template.Template;
import freemarker.template.TemplateException;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class ContentBuilder {
    
    private String content;

    @Value("${spring.mail.requestsignoff}")
    private String signoff;

    @Value("${spring.mail.requestcontact}")
    private String signoffContactDetails;

    public String getContent() {
        return content;
    }

    @Autowired
    private FreeMarkerConfigurer freemarkerConfigurer;

    private String buildUsingFreemarkerTemplate(Map<String, Object> templateModel)
            throws IOException, TemplateException, MessagingException {
            
        Template freemarkerTemplate = freemarkerConfigurer.getConfiguration()
            .getTemplate("request.ftl");

        return FreeMarkerTemplateUtils.processTemplateIntoString(freemarkerTemplate, templateModel);
    }

    public void build(Context ctx) {

        String responseUrl = ctx.getSlinkyLinkyDomain() + "/public/supplierresponse?id="+ctx.getDbEngagement().getGuid();
        String fee = ctx.getEvent().getSupplierWeWriteFeeCurrency() + ctx.getEvent().getSupplierWeWriteFee();

        Map<String, Object> templateModel = new HashMap<>();
        templateModel.put("recipientName", ctx.getEvent().getSupplierName());
        templateModel.put("fee", fee);
        templateModel.put("responseUrl", responseUrl);
        templateModel.put("signoff", signoff);
        templateModel.put("signoffContactDetails", signoffContactDetails);
        templateModel.put("website", ctx.getEvent().getSupplierWebsite());
        
        try {
            content = buildUsingFreemarkerTemplate(templateModel);
        } catch (MessagingException | IOException | TemplateException e) {
            log.error("Error building email content from FreeMarker", e);
            content = "Error building email content from FreeMarker";
        }
    }
}
