package com.domloge.slinkylinky.userservice.captcha;

import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

/**
 * Always passes — active only outside the "production" profile.
 * In production, provide a real CaptchaVerifier bean; startup will fail if none is present.
 */
@Component
@Profile("!production")
public class NoOpCaptchaVerifier implements CaptchaVerifier {

    @Override
    public boolean verify(String token) {
        return true;
    }
}
