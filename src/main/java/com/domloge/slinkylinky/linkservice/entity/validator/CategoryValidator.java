package com.domloge.slinkylinky.linkservice.entity.validator;

import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import com.domloge.slinkylinky.linkservice.entity.Category;

public class CategoryValidator implements Validator {
    
    @Override
    public boolean supports(Class<?> clazz) {
        return Category.class.equals(clazz);
    }

    @Override
    public void validate(Object target, Errors errors) {
        Category c = (Category) target;
        if(null == c.getCreatedBy()) errors.rejectValue("createdBy", "missing");
        if(null == c.getName() || c.getName().trim().length() < 3) errors.rejectValue("name", "missing");

        if(c.getId() > 0 && null == c.getUpdatedBy()) errors.rejectValue("updatedBy", "missing");
    }
}
