package com.domloge.slinkylinky.linkservice.entity;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;

import com.domloge.slinkylinky.linkservice.Util;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import lombok.Getter;
import lombok.Setter;

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
    private String requested;
    private String createdBy;

    @ManyToMany
    private List<Category> categories;

    public LocalDate getRequestedDate() {
        try {
            return LocalDate.parse(requested, browserFormat);
        }
        catch(DateTimeParseException dtpex) {
            return LocalDate.parse(requested, csvFormat);
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
