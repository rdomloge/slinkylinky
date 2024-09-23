package com.domloge.slinkylinky.supplierengagement.email;

import com.domloge.slinkylinky.events.ProposalUpdateEvent;
import com.domloge.slinkylinky.supplierengagement.entity.Engagement;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
public class Context {

    @Setter
    @Getter
    private ProposalUpdateEvent event;
    
    @Getter 
    @Setter 
    private Engagement dbEngagement;
    
    

}
