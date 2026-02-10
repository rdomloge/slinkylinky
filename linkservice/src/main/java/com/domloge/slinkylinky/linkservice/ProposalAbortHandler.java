package com.domloge.slinkylinky.linkservice;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.linkservice.entity.Proposal;
import com.domloge.slinkylinky.linkservice.entity.Supplier;
import com.domloge.slinkylinky.linkservice.entity.audit.ProposalAuditor;
import com.domloge.slinkylinky.linkservice.repo.PaidLinkRepo;
import com.domloge.slinkylinky.linkservice.repo.ProposalRepo;
import com.domloge.slinkylinky.linkservice.repo.SupplierRepo;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class ProposalAbortHandler {

    @Autowired
    private SupplierRepo supplierRepo;

    @Autowired
    private PaidLinkRepo paidLinkRepo;
    
    @Autowired
    private ProposalRepo proposalRepo;

    @Autowired
    private ProposalAuditor proposalAuditor;

    
    public void handle(long proposalId, String user) {
        Proposal proposal = proposalRepo.findById(proposalId).get();
        proposal.setUpdatedBy(user);
        
        proposalRepo.delete(proposal);
        
        proposal.getPaidLinks().forEach(pl -> {
            paidLinkRepo.delete(pl);
        });

        Supplier s = proposal.getPaidLinks().get(0).getSupplier();
        if(s.isThirdParty()) {
            log.info("Deleting 3rd party supplier {}, for proposal abort", s.getName());
            supplierRepo.delete(s);
        }

        proposalAuditor.handleAfterDelete(proposal);
        log.info(user + " deleted proposal " + proposalId);
    }
}
