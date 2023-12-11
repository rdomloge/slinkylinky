package com.domloge.slinkylinky.linkservice.entity;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;

import org.hibernate.annotations.Fetch;
import org.hibernate.annotations.FetchMode;

import com.domloge.slinkylinky.linkservice.Util;

import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Index;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Table(indexes = {@Index(columnList="name"), 
                    @Index(columnList = "daNeeded"),
                    @Index(columnList = "domain"),
                    @Index(columnList = "requested")})
@Entity
@Getter 
@Setter
public class LinkDemand {

    private static final DateTimeFormatter csvFormat = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private static final DateTimeFormatter browserFormat = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    private String name;//
    private String url;//
    private int daNeeded;//
    private String anchorText;//
    private String domain;
    private LocalDateTime requested;
    private String createdBy;

    @ManyToMany(fetch = FetchType.EAGER)
    @Fetch(FetchMode.JOIN)
    private List<Category> categories;


    public void setRequestedFromString(String s) {
        try {
            setRequested(LocalDate.parse(s, browserFormat).atStartOfDay());
        }
        catch(DateTimeParseException dtpex) {
            setRequested(LocalDate.parse(s, csvFormat).atStartOfDay());
        }
    }

    public void setDomain(String domain) {
        this.domain = Util.stripDomain(domain); // it's sometimes got www.
    }

    public void setUrl(String url) {
        this.domain = Util.stripDomain(url);
        this.url = url;
    }
}
