package com.domloge.slinkylinky.stats.entity;

import java.time.LocalDate;

import com.domloge.slinkylinky.stats.Util;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Index;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import lombok.Getter;
import lombok.Setter;


@Table(uniqueConstraints = 
    @UniqueConstraint(columnNames = {"uniqueYearMonth", "domain"}),
    indexes = @Index(columnList = "date, domain"))
@Entity
public class SemRushMonthlyData {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Getter @Setter private long id;
    
    @Column(nullable = false)
    @Getter private LocalDate date; // no lombok setter - set through setDate(), which also sets uniqueYearMonth

    @Column(nullable = false)
    @Getter private String uniqueYearMonth; // no lombok setter - set through setDate()
    
    @Column(nullable = false)
    @Getter @Setter private long traffic;

    @Column(nullable = false)
    @Getter @Setter private long srrank;

    @Column(nullable = false)
    @Getter @Setter private String domain;

    public void setDate(LocalDate date) {
        this.date = date;
        this.uniqueYearMonth = date.getYear()+"-"+Util.dd(date.getMonthValue());
    }
}
