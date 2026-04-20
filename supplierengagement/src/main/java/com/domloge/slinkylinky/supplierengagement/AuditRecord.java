package com.domloge.slinkylinky.supplierengagement;

import java.time.LocalDateTime;
import java.util.UUID;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter 
@Setter
@ToString
public class AuditRecord {

    private Long entityId;

    private String entityType;

    private String who;

    private String what;

    private LocalDateTime eventTime;

    private String detail;

    private UUID organisationId;

}
