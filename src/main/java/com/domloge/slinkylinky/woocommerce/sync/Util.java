package com.domloge.slinkylinky.woocommerce.sync;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.google.common.net.InternetDomainName;

public class Util {

    // Need a regex to parse the number from the string '500 Words'
    private static final String WORD_COUNT_REGEX = "([0-9]+)\\s+Words";
    private static Pattern pattern = Pattern.compile(WORD_COUNT_REGEX);
    
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

    public static int parseWordCountFromLineItemMetadata(String metadata) {
        Matcher matcher = pattern.matcher(metadata);
        if (matcher.find()) {
            return Integer.parseInt(matcher.group(1));
        }
        throw new RuntimeException(metadata + " does not match " + WORD_COUNT_REGEX);
    }
}
