package com.domloge.slinkylinky.supplierengagement.entity;

public enum MappingStatus {
    /** Newly seen category with no mapping yet — blocks lead workflow actions. */
    PENDING,
    /** Mapped to a SlinkyLinky Category. */
    MAPPED,
    /** Explicitly ignored — does not block lead workflow actions. */
    IGNORED
}
