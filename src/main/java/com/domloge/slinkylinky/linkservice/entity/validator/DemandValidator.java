package com.domloge.slinkylinky.linkservice.entity.validator;

import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import com.domloge.slinkylinky.linkservice.entity.Demand;

public class DemandValidator implements Validator {

    @Override
    public boolean supports(Class<?> clazz) {
        return Demand.class.equals(clazz);
    }

    @Override
    public void validate(Object target, Errors errors) {
        Demand d = (Demand) target;
        if(null == d.getRequested()) errors.rejectValue("requested", "missing");
        if(d.getDaNeeded() <= 0) errors.rejectValue("daNeeded", "missing");
        if(null == d.getUrl()) errors.rejectValue("url", "missing");
        if(null == d.getDomain()) errors.rejectValue("domain", "missing");

        if(null == d.getCreatedBy()) errors.rejectValue("createdby", "missing");
        if(d.getId() > 0 && null == d.getUpdatedBy()) errors.rejectValue("updatedby", "missing");
    }
    
}
