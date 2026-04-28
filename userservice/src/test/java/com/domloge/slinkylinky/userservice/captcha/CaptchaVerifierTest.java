package com.domloge.slinkylinky.userservice.captcha;

import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.Test;

class CaptchaVerifierTest {

    @Test
    void noOpVerifier_alwaysReturnsTrue() {
        CaptchaVerifier verifier = new NoOpCaptchaVerifier();
        assertTrue(verifier.verify(null));
        assertTrue(verifier.verify(""));
        assertTrue(verifier.verify("some-captcha-token"));
    }
}
