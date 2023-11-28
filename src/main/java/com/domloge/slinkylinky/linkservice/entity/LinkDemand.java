package com.domloge.slinkylinky.linkservice.entity;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

import com.domloge.slinkylinky.linkservice.Util;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToMany;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter 
@Setter
public class LinkDemand {

    private static final DateTimeFormatter format = DateTimeFormatter.ofPattern("dd/MM/yyy");
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    private String name;//
    private String url;//
    private int daNeeded;//
    private String anchorText;//
    private String domain;
    private String requested;

    @ManyToMany
    private List<Category> categories;

    public LocalDate getRequestedDate() {
        return LocalDate.parse(requested, format);
    }

    public void setDomain(String domain) {
        this.domain = Util.stripDomain(domain); // it's sometimes got www.
    }
}
