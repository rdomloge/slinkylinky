package com.domloge.slinkylinky.audit;

import java.util.Set;

import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

@Component("beforeCreateAuditRecordValidator")
public class AuditValidator implements Validator {

    private static final Set<String> GLOBAL_ENTITY_TYPES = Set.of("BlackListedSupplier", "Category");

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
        if (ar.getEntityType() != null && null == ar.getOrganisationId() && !GLOBAL_ENTITY_TYPES.contains(ar.getEntityType())) {
            errors.rejectValue("organisationId", "missing",
                "organisationId is required for entity type: " + ar.getEntityType());
        }
    }
}
