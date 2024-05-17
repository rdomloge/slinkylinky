package com.domloge.slinkylinky.woocommerce.entity;

import java.time.LocalDateTime;
import java.util.List;

import org.hibernate.annotations.Fetch;
import org.hibernate.annotations.FetchMode;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Lob;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
@Table(name = "wooOrder", indexes = {
    @jakarta.persistence.Index(name = "externalId", columnList = "externalId", unique = true)
})
public class OrderEntity {
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    protected long id;

    @Column(unique = true)
    private long externalId;

    @Column(columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP", insertable = false, updatable = false)
    private LocalDateTime dateCreated;

    @Lob
    @Column(columnDefinition="TEXT")
    private String wooOrderJson;

    private String billingEmailAddress;

    private String shippingEmailAddress;

    private String customerName;

    @OneToMany(fetch = FetchType.EAGER)
    @Fetch(FetchMode.SUBSELECT)
    private List<OrderLineItemEntity> lineItems;

    @Column(columnDefinition = "boolean default false")
    private boolean linkDetailsEmailSent = false;

    private LocalDateTime linkDetailsEmailSentDate = null;

    @Column(columnDefinition = "boolean default false")
    private boolean archived = false;
}