package com.domloge.slinkylinky.linkservice.moz;

import org.springframework.http.HttpHeaders;
import java.util.Base64;
import java.nio.charset.Charset;

public class AbstractMoz {

    protected HttpHeaders createHeaders(String username, String password) {
        return new HttpHeaders() {
            {
                String auth = username + ":" + password;
                byte[] encodedAuth = Base64.getEncoder().encode(auth.getBytes(Charset.forName("US-ASCII")));
                String authHeader = "Basic " + new String(encodedAuth);
                set("Authorization", authHeader);
            }
        };
    }
}
