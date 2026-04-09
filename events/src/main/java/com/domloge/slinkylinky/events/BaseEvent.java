package com.domloge.slinkylinky.events;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;

public class BaseEvent {

    @Getter private LocalDateTime timestamp = LocalDateTime.now();

    @Getter @Setter private String organisationId;

}
