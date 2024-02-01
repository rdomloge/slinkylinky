package com.domloge.slinkylinky.stats.semrush;

import java.time.LocalDate;
import java.time.Month;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class Semrush {
    
    @Value("${sr.base:https://api.semrush.com}")
    private String sr_base;

    @Value("${semrush.key}")
    private String semrushKey;

    @Value("${sr.cols:Ot,Rk,Dt}")
    private String columns;

    private RestTemplate rest;



    public Semrush(RestTemplate rest) {
        this.rest = rest;
    }
    

    public String getTrafficForLastYear(String domain) {
        String url = sr_base
            +"/?type=domain_rank_history"
            +"&display_limit=12"
            +"&key="+semrushKey
            +"&export_columns="+columns
            +"&database=uk"
            +"&domain="+domain;
        String srResp = rest.getForObject(url, String.class);
        log.trace("SR response: {}", srResp);
        return srResp;
    }


    public String getTrafficData(String domain, Month monthOfDataRequired) {
        // calculate how many months we need to go back
        LocalDate now = LocalDate.now();
        LocalDate startOfFirstMonthofHistoricData = 
            LocalDate.now().minusMonths(1).minusDays(now.getDayOfMonth() - 1);
        int displayOffset = startOfFirstMonthofHistoricData.getMonthValue() - monthOfDataRequired.getValue();
        if(displayOffset < 0) {
            displayOffset += 12;
        }
        String url = sr_base
            +"/?type=domain_rank_history"
            +"&display_limit="+(displayOffset+1)
            +"&display_offset="+displayOffset
            +"&key="+semrushKey
            +"&export_columns="+columns
            +"&database=uk"
            +"&domain="+domain;

        String srResp = rest.getForObject(url, String.class);
        log.trace("SR response: {}", srResp);
        return srResp;
    }
}
