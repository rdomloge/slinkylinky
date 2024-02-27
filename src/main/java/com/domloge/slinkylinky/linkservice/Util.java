package com.domloge.slinkylinky.linkservice;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import com.google.common.net.InternetDomainName;

public class Util {
    
    public static String stripDomain(String urlString) {

        URI uri;
        try {
            uri = new URI(urlString);
            if(uri.getScheme() == null) {
                uri = new URI("https://" + urlString);
            }   
        } 
        catch (URISyntaxException e) {
            throw new RuntimeException(e);
        }
        String host = uri.getHost();
        InternetDomainName internetDomainName = InternetDomainName.from(host).topPrivateDomain(); 
        return internetDomainName.toString(); 
    }

    public static LocalDateTime parse(String d) {
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        LocalDate parsed = LocalDate.parse(d, dtf);
        return parsed.atStartOfDay();
    }
}
