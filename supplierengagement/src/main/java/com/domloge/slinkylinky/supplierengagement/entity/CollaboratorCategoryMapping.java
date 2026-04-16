package com.domloge.slinkylinky.supplierengagement.entity;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
@Table(name = "collaborator_category_mapping")
public class CollaboratorCategoryMapping {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    /** The raw category string as received from Collaborator.pro. */
    @Column(nullable = false, unique = true, length = 255)
    private String collaboratorCategory;

    /** ID of the matched SlinkyLinky Category (from linkservice). Denormalised — no FK constraint. */
    private Long slCategoryId;

    /** Name of the matched SlinkyLinky Category. Denormalised for display without a cross-service call. */
    @Column(length = 255)
    private String slCategoryName;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private MappingStatus status = MappingStatus.PENDING;

    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(nullable = false)
    private LocalDateTime updatedAt;

    @PrePersist
    private void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = createdAt;
    }

    @PreUpdate
    private void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}
