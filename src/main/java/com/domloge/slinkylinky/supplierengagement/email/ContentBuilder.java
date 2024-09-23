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

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.fasterxml.jackson.annotation.JsonInclude.Include;

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

    @Value("${slinkyLinky.domain}")
    private String slinkyLinkyDomain;

    @Value("${spring.mail.declineEmailRecipientName}")
    private String declineEmailRecipientName;

    @Value("${linkservice_baseurl}")
    private String linkService_base;

    @Autowired
    private HttpUtils httpUtils;

    private ObjectMapper mapper = new ObjectMapper();

    public ContentBuilder() {
        mapper.registerModule(new JavaTimeModule());
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        mapper.setSerializationInclusion(Include.NON_NULL);
        mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
    }


    public String getContent() {
        return content;
    }

    @Autowired
    private FreeMarkerConfigurer freemarkerConfigurer;

    private String buildUsingFreemarkerTemplate(Map<String, Object> templateModel, String templateName)
            throws IOException, TemplateException, MessagingException {
            
        Template freemarkerTemplate = freemarkerConfigurer.getConfiguration()
            .getTemplate(templateName);

        return FreeMarkerTemplateUtils.processTemplateIntoString(freemarkerTemplate, templateModel);
    }

    public String buildForSupplierEngagement(Context ctx) {

        String responseUrl = slinkyLinkyDomain + "/public/supplierresponse?id="+ctx.getDbEngagement().getGuid();
        String fee = ctx.getEvent().getSupplierWeWriteFeeCurrency() + ctx.getEvent().getSupplierWeWriteFee();

        Map<String, Object> templateModel = new HashMap<>();
        templateModel.put("recipientName", ctx.getEvent().getSupplierName());
        templateModel.put("fee", fee);
        templateModel.put("responseUrl", responseUrl);
        templateModel.put("signoff", signoff);
        templateModel.put("signoffContactDetails", signoffContactDetails);
        templateModel.put("website", ctx.getEvent().getSupplierWebsite());
        
        try {
            return buildUsingFreemarkerTemplate(templateModel, "request.ftl");
        } 
        catch (MessagingException | IOException | TemplateException e) {
            log.error("Error building email content from FreeMarker", e);
            return "Error building email content from FreeMarker";
        }
    }

    public String buildForDecline(Context ctx) throws IOException {
        Map<String, Object> templateModel = new HashMap<>();

        Proposal p = loadProposalDemandDomains(ctx);

        templateModel.put("recipientName", declineEmailRecipientName);
        templateModel.put("supplierName", ctx.getDbEngagement().getSupplierName());
        templateModel.put("supplierDomain", ctx.getDbEngagement().getSupplierWebsite());
        templateModel.put("demand1Domain", p.getPaidLinks().get(0).getDemand().getDomain());
        if(p.getPaidLinks().size() > 1) {
            templateModel.put("demand2Domain", p.getPaidLinks().get(1).getDemand().getDomain());
        }   
        if(p.getPaidLinks().size() > 2) {
            templateModel.put("demand3Domain", p.getPaidLinks().get(2).getDemand().getDomain());
        }   
        templateModel.put("declineReason", ctx.getDbEngagement().getDeclinedReason());
        templateModel.put("doNotContact", ctx.getDbEngagement().isDoNotContact());

        try {
            return buildUsingFreemarkerTemplate(templateModel, "supplier-declined.ftl");
        } 
        catch (MessagingException | IOException | TemplateException e) {
            log.error("Error building email content from FreeMarker", e);
            return "Error building email content from FreeMarker";
        }
    }

    private Proposal loadProposalDemandDomains(Context ctx) throws IOException {
        long proposalId = ctx.getDbEngagement().getProposalId();
        String url = linkService_base + "/proposals/" + proposalId + "?projection=fullProposal";
        String response = httpUtils.get(url);
        if(null == response) {
            log.error("Error fetching proposal {}", proposalId);
            throw new RuntimeException("Could not find proposal " + proposalId);
        }
        return mapper.readValue(response, Proposal.class);
    }
}
