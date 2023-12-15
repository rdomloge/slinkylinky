package com.domloge.slinkylinky.linkservice.entity;

import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

@Component("beforeCreateLinkDemandValidator")
public class DemandValidator implements Validator {

    @Override
    public boolean supports(Class<?> clazz) {
        return Demand.class.equals(clazz);
    }

    @Override
    public void validate(Object target, Errors errors) {
        Demand ld = (Demand) target;
        if(null == ld.getRequested()) errors.rejectValue("requested", "missing");
        if(ld.getDaNeeded() <= 0) errors.rejectValue("daNeeded", "missing");
        if(null == ld.getUrl()) errors.rejectValue("url", "missing");
        if(null == ld.getDomain()) errors.rejectValue("domain", "missing");
    }
    
}
