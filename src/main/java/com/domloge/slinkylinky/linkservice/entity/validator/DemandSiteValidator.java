package com.domloge.slinkylinky.linkservice.entity.validator;

import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import com.domloge.slinkylinky.linkservice.entity.DemandSite;

@Component("beforeCreateDemandSiteValidator")
public class DemandSiteValidator implements Validator {

    @Override
    public boolean supports(Class<?> clazz) {
        return DemandSite.class.equals(clazz);
    }

    @Override
    public void validate(Object target, Errors errors) {
        DemandSite ds = (DemandSite) target;
        if(null == ds.getCreatedBy()) errors.rejectValue("createdby", "missing");
        if(null == ds.getName() || ds.getName().trim().length() < 3) errors.rejectValue("name", "missing");

        if(ds.getId() > 0 && null == ds.getUpdatedBy()) errors.rejectValue("updatedby", "missing");
    }
    
}
