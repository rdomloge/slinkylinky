package com.domloge.slinkylinky.linkservice.entity.validator;

import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import com.domloge.slinkylinky.linkservice.entity.Supplier;

@Component("beforeCreateSupplierValidator")
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
            // if(s.getSemRushAuthorityScore() < 0 || s.getSemRushAuthorityScore() > 100) errors.rejectValue("semRushAuthorityScore", "incorrect");
            // if(s.getSemRushUkMonthlyTraffic() < 0 || s.getSemRushUkMonthlyTraffic() > 100000000) errors.rejectValue("semRushUkMonthlyTraffic", "incorrect");
            // if(s.getSemRushUkJan23Traffic() < 0 || s.getSemRushUkJan23Traffic() > 100000000) errors.rejectValue("semRushUkJan23Traffic", "incorrect");
            if(s.getWeWriteFee() < 0 || s.getWeWriteFee() > 1000000) errors.rejectValue("weWriteFee", "incorrect");
            if(null == s.getWeWriteFeeCurrency() || s.getWeWriteFeeCurrency().trim().length() != 1) errors.rejectValue("weWriteFeeCurrency", "incorrect");
        }
    }
}
