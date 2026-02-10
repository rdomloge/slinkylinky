package com.domloge.slinkylinky.stats.entity;

import java.time.LocalDate;

import com.domloge.slinkylinky.stats.Util;

import jakarta.persistence.Column;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.MappedSuperclass;
import lombok.Getter;
import lombok.Setter;

@MappedSuperclass
public abstract class AbstractMonthlyData {
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Getter @Setter protected long id;

    @Setter @Getter protected String domain;

    @Column(nullable = false)
    @Getter protected LocalDate date; // no lombok setter - set through setDate(), which also sets uniqueYearMonth

    @Column(nullable = false)
    @Getter protected String uniqueYearMonth; // no lombok setter - set through setDate()

    public void setDate(LocalDate date) {
        this.date = date;
        this.uniqueYearMonth = date.getYear()+"-"+Util.dd(date.getMonthValue());
    }

    public abstract String getDataPointName();
    public abstract String getDataPointValue();
}
