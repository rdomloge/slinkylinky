package com.domloge.slinkylinky.userservice.entity;

import java.time.LocalDateTime;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "email_verification_token")
@Getter
@Setter
public class EmailVerificationToken {

    @Id
    @Column(name = "token_hash", length = 64, columnDefinition = "VARCHAR(64)")
    private String tokenHash;

    @Column(name = "user_id", nullable = false)
    private String userId;

    @Column(nullable = false, length = 254)
    private String email;

    @Column(name = "org_id", nullable = false)
    private UUID orgId;

    @Column(name = "expires_at", nullable = false)
    private LocalDateTime expiresAt;

    @Column(nullable = false)
    private boolean used = false;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
}
