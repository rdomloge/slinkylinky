package com.domloge.slinkylinky.events;

import lombok.Getter;
import lombok.Setter;

@Getter
public class SupplierEvent extends BaseEvent{
    
    public enum EventType {
        CREATED, DISABLED
    }



    @Setter
    public EventType type;

    @Setter
    public String domain;

    @Setter
    public long supplierId;

    public static SupplierEvent buildForCreated(EventType type, String domain, long supplierId) {
        SupplierEvent event = new SupplierEvent();
        event.type = type;
        event.domain = domain;
        event.supplierId = supplierId;
        return event;
    }
}
