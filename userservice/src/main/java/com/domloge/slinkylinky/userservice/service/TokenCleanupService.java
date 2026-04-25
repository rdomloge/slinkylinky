package com.domloge.slinkylinky.userservice.service;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.domloge.slinkylinky.userservice.repo.EmailVerificationTokenRepo;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class TokenCleanupService {

    @Autowired
    private EmailVerificationTokenRepo tokenRepo;

    /** Nightly cleanup: remove used tokens and those expired for more than 30 days. */
    @Scheduled(cron = "0 0 3 * * *")
    public void cleanupTokens() {
        LocalDateTime cutoff = LocalDateTime.now().minusDays(30);
        int deleted = tokenRepo.deleteExpiredAndUsed(cutoff);
        log.info("Token cleanup: deleted {} expired/used rows (cutoff={})", deleted, cutoff);
    }
}
