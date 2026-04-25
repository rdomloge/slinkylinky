package com.domloge.slinkylinky.userservice.captcha;

import org.springframework.stereotype.Component;

/** Always passes — replace with a real implementation when hCaptcha is integrated. */
@Component
public class NoOpCaptchaVerifier implements CaptchaVerifier {

    @Override
    public boolean verify(String token) {
        return true;
    }
}
