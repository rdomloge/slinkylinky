package com.domloge.slinkylinky.linkservice;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

public class Util {
    
    public static String stripDomain(String url) {
        url = url.toLowerCase();
        int httpPos = url.indexOf("http://");
        int httpsPos = url.indexOf("https://");
        if(httpPos > -1) url = url.substring(7);
        if(httpsPos > -1) url = url.substring(8);
        if(url.indexOf("/") > -1) url = url.substring(0, url.indexOf("/"));
        if(url.indexOf("www.") > -1) url = url.substring(url.indexOf("www.")+4);
        return url;
    }

    public static LocalDateTime parse(String d) {
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        LocalDate parsed = LocalDate.parse(d, dtf);
        return parsed.atStartOfDay();
    }
}
