package com.domloge.slinkylinky.events;

import java.time.LocalDateTime;

import lombok.Getter;

public class BaseEvent {

    @Getter private LocalDateTime timestamp = LocalDateTime.now();
    
}
