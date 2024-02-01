package com.domloge.slinkylinky.linkservice.entity.audit;

import java.time.LocalDateTime;

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

}
