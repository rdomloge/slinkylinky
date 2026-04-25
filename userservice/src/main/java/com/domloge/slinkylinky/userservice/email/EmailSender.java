package com.domloge.slinkylinky.userservice.email;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Component;
import org.springframework.ui.freemarker.FreeMarkerTemplateUtils;

import freemarker.template.Configuration;
import freemarker.template.Template;
import jakarta.mail.internet.MimeMessage;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class EmailSender {

    @Autowired
    private JavaMailSender mailSender;

    @Autowired
    private Configuration freemarkerConfig;

    @Value("${mail.from}")
    private String mailFrom;

    @Value("${slinkylinky.domain}")
    private String domain;

    /**
     * Sends a verification email containing a link to
     * {@code {domain}/verify-email?token={rawToken}}.
     */
    public void sendVerificationEmail(String to, String rawToken) throws Exception {
        Template template = freemarkerConfig.getTemplate("verify-email.ftl");
        Map<String, Object> model = Map.of(
            "verificationLink", domain + "/verify-email?token=" + rawToken,
            "email", to
        );
        String body = FreeMarkerTemplateUtils.processTemplateIntoString(template, model);

        MimeMessage message = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, "utf-8");
        helper.setFrom(mailFrom);
        helper.setTo(to);
        helper.setSubject("Verify your SlinkyLinky email address");
        helper.setText(body, true);
        mailSender.send(message);
        log.info("Verification email sent to {}", to);
    }
}
