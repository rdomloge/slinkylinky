package com.domloge.slinkylinky.supplierengagement;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Lob;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Entity
@Getter 
@Setter
@ToString
public class AuditRecord {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    private Long entityId;

    private String entityType;

    private String who;

    private String what;

    private LocalDateTime eventTime;

    @Lob
    @Column(columnDefinition="TEXT")
    private String detail;

}
