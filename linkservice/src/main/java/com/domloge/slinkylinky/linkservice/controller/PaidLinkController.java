package com.domloge.slinkylinky.linkservice.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.domloge.slinkylinky.linkservice.repo.PaidLinkRepo;

@Controller
@RequestMapping(".rest/paidlinksupport")
public class PaidLinkController {
    
    @Autowired
    private PaidLinkRepo paidLinkRepo;
    

    @GetMapping(path = "/getcountsforsuppliers", produces = "application/json")
    @ResponseBody
    public Map<Long, Long> getUsageCounts(@RequestParam long... supplierIds) {
        Map<Long, Long> counts = new HashMap<>();
        for(long supplierId : supplierIds) {
            counts.put(supplierId, paidLinkRepo.countBySupplierId(supplierId));
        }    
        return counts;
    }
}
