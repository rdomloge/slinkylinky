package com.domloge.slinkylinky.woocommerce.sync;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;

import com.google.common.net.InternetDomainName;

public class Util {
    
    public static String stripDomain(String urlString) throws IOException {

        URI uri;
        try {
            uri = new URI(urlString);
        } 
        catch (URISyntaxException e) {
            throw new IOException(e);
        }
        String host = uri.getHost();
        InternetDomainName internetDomainName = InternetDomainName.from(host).topPrivateDomain(); 
        return internetDomainName.toString(); 
    }
}
