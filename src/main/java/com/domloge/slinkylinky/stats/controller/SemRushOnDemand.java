package com.domloge.slinkylinky.stats.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.domloge.slinkylinky.stats.semrush.Loader;
import com.domloge.slinkylinky.stats.semrush.SemRushResponseLine;
import com.domloge.slinkylinky.stats.semrush.Semrush;

import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping(".rest/semrush")
@Slf4j
public class SemRushOnDemand {
    
    @Autowired
    private Semrush semrush;


    @GetMapping(path = "/lookup", produces = "application/json")
    public ResponseEntity<SemRushResponseLine[]> generate(@RequestParam String domain, @RequestHeader String user) {
        log.info("{} generating SEMrush data for {}", user, domain);
        SemRushResponseLine[] lines = getTrafficForLastYear(domain);
        return new ResponseEntity<SemRushResponseLine[]>(lines, HttpStatus.OK);
    }

    private SemRushResponseLine[] getTrafficForLastYear(String domain) {
        String resp = semrush.getTrafficForLastYear(domain);
        List<SemRushResponseLine> lines = Loader.loadObjectList(SemRushResponseLine.class, resp);
        if(lines.size() != 12) log.warn("Expected 12 lines, got {} - SEMrush has incomplete data", lines.size());
        return lines.stream().toArray(SemRushResponseLine[]::new);
    }
}
