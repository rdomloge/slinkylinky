package com.domloge.slinkylinky.userservice.repo;

import java.time.LocalDateTime;
import java.util.Optional;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.transaction.annotation.Transactional;

import com.domloge.slinkylinky.userservice.entity.EmailVerificationToken;

@RepositoryRestResource(exported = false)
public interface EmailVerificationTokenRepo extends CrudRepository<EmailVerificationToken, String> {

    Optional<EmailVerificationToken> findByTokenHashAndUsedFalseAndExpiresAtAfter(
            String tokenHash, LocalDateTime now);

    @Transactional
    @Modifying
    @Query("UPDATE EmailVerificationToken t SET t.used = true WHERE t.userId = :userId AND t.used = false")
    int invalidateAllForUser(@Param("userId") String userId);

    @Transactional
    @Modifying(clearAutomatically = true)
    @Query("DELETE FROM EmailVerificationToken t WHERE t.used = true OR t.expiresAt < :cutoff")
    int deleteExpiredAndUsed(@Param("cutoff") LocalDateTime cutoff);
}
