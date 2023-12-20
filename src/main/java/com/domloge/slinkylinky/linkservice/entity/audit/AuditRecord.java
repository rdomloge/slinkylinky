package com.domloge.slinkylinky.linkservice.entity.audit;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Lob;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter 
@Setter
public class AuditRecord {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    private Long entityId;

    private String entityType;

    @NotBlank(message = "who is mandatory")
    private String who;

    @NotBlank(message = "what is mandatory")
    private String what;

    @NotNull(message = "eventTime is mandatory")
    private LocalDateTime eventTime;

    @Lob
    @Column(columnDefinition="TEXT")
    private String detail;

}
