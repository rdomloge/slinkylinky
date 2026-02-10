package com.domloge.slinkylinky.linkservice.entity.validator;

import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import com.domloge.slinkylinky.linkservice.entity.BlackListedSupplier;

public class BlackListedSupplierValidator implements Validator {

    @Override
    public boolean supports(Class<?> clazz) {
        return BlackListedSupplier.class.equals(clazz);
    }

    @Override
    public void validate(Object target, Errors errors) {
        
        BlackListedSupplier b = (BlackListedSupplier) target;
        
        if(null == b.getCreatedBy()) errors.rejectValue("createdBy", "missing");
        if(b.getDateCreated() == null) errors.rejectValue("dateCreated", "missing");
        
        if(null == b.getDomain() || b.getDomain().trim().length() < 3) errors.rejectValue("domain", "missing");
        if(b.getDa() < 0) errors.rejectValue("da", "negative");
        if(b.getSpamRating() < 0) errors.rejectValue("spamRating", "negative");
        
    }
    
}
