package com.domloge.slinkylinky.userservice.token;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

import org.junit.jupiter.api.Test;

class TokenHasherTest {

    private final TokenHasher hasher = new TokenHasher();

    @Test
    void generateRawToken_producesNonNullNonBlankToken() {
        String token = hasher.generateRawToken();
        assertNotNull(token);
        assertNotEquals("", token.trim());
    }

    @Test
    void generateRawToken_producesUniqueTokens() {
        String t1 = hasher.generateRawToken();
        String t2 = hasher.generateRawToken();
        assertNotEquals(t1, t2);
    }

    @Test
    void hash_produces64CharHexString() {
        String hash = hasher.hash("some-token-value");
        assertNotNull(hash);
        assertEquals(64, hash.length());
        // verify hex-only characters
        assert hash.matches("[0-9a-f]{64}") : "Expected 64-char lowercase hex but got: " + hash;
    }

    @Test
    void hash_isStableAcrossCallsForSameInput() {
        String input = hasher.generateRawToken();
        assertEquals(hasher.hash(input), hasher.hash(input));
    }

    @Test
    void hash_differentiatesDistinctInputs() {
        assertNotEquals(hasher.hash("token-a"), hasher.hash("token-b"));
    }
}
