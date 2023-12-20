package com.domloge.slinkylinky.linkservice.entity.validator;

import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import com.domloge.slinkylinky.linkservice.entity.audit.AuditRecord;

@Component("beforeCreateAuditRecordValidator")
public class AuditValidator implements Validator {

    @Override
    public boolean supports(Class<?> clazz) {
        return AuditRecord.class.equals(clazz);
    }

    @Override
    public void validate(Object target, Errors errors) {
        AuditRecord ar = (AuditRecord) target;
        if(null == ar.getDetail()) errors.rejectValue("detail", "missing");
        if(null == ar.getEventTime()) errors.rejectValue("eventTime", "missing");
        if(null == ar.getWhat()) errors.rejectValue("what", "missing");
        if(null == ar.getWho() || ar.getWho().trim().isEmpty()) errors.rejectValue("who", "missing");
        if(null == ar.getEntityType()) errors.rejectValue("entityType", "missing");
    }
}
