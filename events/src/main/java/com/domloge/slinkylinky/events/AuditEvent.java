package com.domloge.slinkylinky.events;

import java.time.LocalDateTime;
import java.util.UUID;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AuditEvent {

    private String who;

    private String what;

    private String entityType;

    private String entityId;

    private LocalDateTime eventTime;

    private String detail;

    private UUID organisationId;

}
