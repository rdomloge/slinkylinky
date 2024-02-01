package com.domloge.slinkylinky.linkservice.entity.validator;

import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import com.domloge.slinkylinky.linkservice.entity.Supplier;

public class SupplierValidator implements Validator {
    
    @Override
    public boolean supports(Class<?> clazz) {
        return Supplier.class.equals(clazz);
    }

    @Override
    public void validate(Object target, Errors errors) {
        Supplier s = (Supplier) target;
        if(null == s.getCreatedBy()) errors.rejectValue("createdBy", "missing");
        if(s.getId() > 0 && null == s.getUpdatedBy()) errors.rejectValue("updatedBy", "missing");

        if(null == s.getName() || s.getName().trim().length() < 2) errors.rejectValue("name", "incorrect");

        if( ! s.isThirdParty()) {
            if(null == s.getEmail() || s.getEmail().trim().length() < 5) errors.rejectValue("email", "incorrect");
            if(null == s.getWebsite() || s.getWebsite().trim().length() < 5) errors.rejectValue("website", "incorrect");
            if(null == s.getDomain() || s.getDomain().trim().length() < 5) errors.rejectValue("domain", "incorrect");
            if(s.getDa() < 0 || s.getDa() > 100) errors.rejectValue("da", "incorrect");
            if(s.getWeWriteFee() < 0 || s.getWeWriteFee() > 1000000) errors.rejectValue("weWriteFee", "incorrect");
            if(null == s.getWeWriteFeeCurrency() || s.getWeWriteFeeCurrency().trim().length() != 1) errors.rejectValue("weWriteFeeCurrency", "incorrect");
        }
    }
}
