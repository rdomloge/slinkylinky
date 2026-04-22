package com.domloge.slinkylinky.linkservice.entity.validator;

import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import com.domloge.slinkylinky.events.AuditEvent;

@Component("beforeCreateAuditEventValidator")
public class AuditValidator implements Validator {

    @Override
    public boolean supports(Class<?> clazz) {
        return AuditEvent.class.equals(clazz);
    }

    @Override
    public void validate(Object target, Errors errors) {
        AuditEvent ae = (AuditEvent) target;
        if(null == ae.getDetail()) errors.rejectValue("detail", "missing");
        if(null == ae.getEventTime()) errors.rejectValue("eventTime", "missing");
        if(null == ae.getWhat()) errors.rejectValue("what", "missing");
        if(null == ae.getWho() || ae.getWho().trim().isEmpty()) errors.rejectValue("who", "missing");
    }
}
