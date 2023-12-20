package com.domloge.slinkylinky.linkservice.entity.validator;

import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import com.domloge.slinkylinky.linkservice.entity.Proposal;

@Component("beforeCreateProposalValidator")
public class ProposalValidator implements Validator {
    
    @Override
    public boolean supports(Class<?> clazz) {
        return Proposal.class.equals(clazz);
    }

    @Override
    public void validate(Object target, Errors errors) {
        Proposal p = (Proposal) target;
        if(null == p.getCreatedBy()) errors.rejectValue("createdBy", "missing");
        if(p.getId() > 0 && null == p.getUpdatedBy()) errors.rejectValue("updatedBy", "missing");

        if(null == p.getPaidLinks() || p.getPaidLinks().isEmpty() || p.getPaidLinks().size() > 3) errors.rejectValue("paidLinks", "incorrect");
    }
}
