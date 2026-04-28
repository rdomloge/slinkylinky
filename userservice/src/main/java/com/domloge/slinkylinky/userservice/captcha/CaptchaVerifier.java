package com.domloge.slinkylinky.userservice.captcha;

/**
 * Anti-bot verification hook. Stubbed as a no-op; swap in a real provider (hCaptcha, etc.)
 * without changing controller code.
 */
public interface CaptchaVerifier {

    /**
     * Verifies a captcha response token.
     * @param token the client-side captcha token (may be null if captcha is not yet wired in the UI)
     * @return true if the token is valid or captcha is disabled; false if the challenge failed
     */
    boolean verify(String token);
}
