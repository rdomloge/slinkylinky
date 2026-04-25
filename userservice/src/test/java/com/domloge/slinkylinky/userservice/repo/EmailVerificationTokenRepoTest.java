package com.domloge.slinkylinky.userservice.repo;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.UUID;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.test.context.ActiveProfiles;

import com.domloge.slinkylinky.userservice.entity.EmailVerificationToken;

@DataJpaTest
@ActiveProfiles("test")
class EmailVerificationTokenRepoTest {

    @Autowired
    private EmailVerificationTokenRepo repo;

    // SHA-256 hex hashes are always exactly 64 chars; use fixed test values
    private static final String HASH_VALID   = "a".repeat(64);
    private static final String HASH_EXPIRED = "b".repeat(64);
    private static final String HASH_USED    = "c".repeat(64);
    private static final String HASH_ACTIVE  = "d".repeat(64);
    private static final String HASH_H1      = "1".repeat(64);
    private static final String HASH_H2      = "2".repeat(64);
    private static final String HASH_H3      = "3".repeat(64);

    @Test
    void findByTokenHashAndUsedFalseAndExpiresAtAfter_findsValidToken() {
        repo.save(token(HASH_VALID, "user1", LocalDateTime.now().plusHours(1)));

        Optional<EmailVerificationToken> found = repo.findByTokenHashAndUsedFalseAndExpiresAtAfter(
            HASH_VALID, LocalDateTime.now());
        assertTrue(found.isPresent());
        assertEquals("user1", found.get().getUserId());
    }

    @Test
    void findByTokenHashAndUsedFalseAndExpiresAtAfter_rejectsExpiredToken() {
        repo.save(token(HASH_EXPIRED, "user2", LocalDateTime.now().minusHours(1)));

        Optional<EmailVerificationToken> found = repo.findByTokenHashAndUsedFalseAndExpiresAtAfter(
            HASH_EXPIRED, LocalDateTime.now());
        assertFalse(found.isPresent());
    }

    @Test
    void findByTokenHashAndUsedFalseAndExpiresAtAfter_rejectsUsedToken() {
        EmailVerificationToken t = token(HASH_USED, "user3", LocalDateTime.now().plusHours(1));
        t.setUsed(true);
        repo.save(t);

        Optional<EmailVerificationToken> found = repo.findByTokenHashAndUsedFalseAndExpiresAtAfter(
            HASH_USED, LocalDateTime.now());
        assertFalse(found.isPresent());
    }

    @Test
    void invalidateAllForUser_marksAllTokensUsed() {
        repo.save(token(HASH_H1, "user-x", LocalDateTime.now().plusHours(1)));
        repo.save(token(HASH_H2, "user-x", LocalDateTime.now().plusHours(2)));
        repo.save(token(HASH_H3, "user-y", LocalDateTime.now().plusHours(1)));

        int updated = repo.invalidateAllForUser("user-x");
        assertEquals(2, updated);
        assertFalse(repo.findByTokenHashAndUsedFalseAndExpiresAtAfter(HASH_H1, LocalDateTime.now()).isPresent());
        assertFalse(repo.findByTokenHashAndUsedFalseAndExpiresAtAfter(HASH_H2, LocalDateTime.now()).isPresent());
        assertTrue(repo.findByTokenHashAndUsedFalseAndExpiresAtAfter(HASH_H3, LocalDateTime.now()).isPresent());
    }

    @Test
    void deleteExpiredAndUsed_removesOnlyExpiredOrUsedRows() {
        repo.save(token(HASH_ACTIVE, "u1", LocalDateTime.now().plusHours(1)));
        repo.save(token(HASH_EXPIRED, "u2", LocalDateTime.now().minusHours(1)));
        EmailVerificationToken usedToken = token(HASH_USED, "u3", LocalDateTime.now().plusHours(1));
        usedToken.setUsed(true);
        repo.save(usedToken);

        int deleted = repo.deleteExpiredAndUsed(LocalDateTime.now());
        assertEquals(2, deleted);
        assertTrue(repo.findById(HASH_ACTIVE).isPresent());
        assertFalse(repo.findById(HASH_EXPIRED).isPresent());
        assertFalse(repo.findById(HASH_USED).isPresent());
    }

    private EmailVerificationToken token(String hash, String userId, LocalDateTime expiresAt) {
        EmailVerificationToken t = new EmailVerificationToken();
        t.setTokenHash(hash);
        t.setUserId(userId);
        t.setEmail(userId + "@example.com");
        t.setOrgId(UUID.randomUUID());
        t.setExpiresAt(expiresAt);
        t.setCreatedAt(LocalDateTime.now());
        return t;
    }
}
