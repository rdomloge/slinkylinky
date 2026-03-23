package com.domloge.slinkylinky.woocommerce.sync;

import java.io.IOException;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.ui.freemarker.FreeMarkerTemplateUtils;
import org.springframework.web.servlet.view.freemarker.FreeMarkerConfigurer;

import freemarker.template.Template;
import freemarker.template.TemplateException;

@Component
public class LinkDetailsContentBuilder {

    @Autowired
    private FreeMarkerConfigurer freemarkerConfigurer;

    private String buildUsingFreemarkerTemplate(Map<String, Object> templateModel)
            throws IOException, TemplateException {
            
        Template freemarkerTemplate = freemarkerConfigurer.getConfiguration()
            .getTemplate("order-complete.ftl");

        return FreeMarkerTemplateUtils.processTemplateIntoString(freemarkerTemplate, templateModel);
    }

    public String build(String senderName, String recipientName, Map<String, Object> templateModel) throws IOException, TemplateException {

        templateModel.put("senderName", senderName);
        templateModel.put("recipientName", recipientName);

        return buildUsingFreemarkerTemplate(templateModel);
    }
    
}
