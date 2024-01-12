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
import lombok.ToString;

@Getter 
@Setter
@ToString
public class AuditRecord {
    private long id;

    private Long entityId;

    private String entityType;

    private String who;

    private String what;

    private LocalDateTime eventTime;

    private String detail;

}
