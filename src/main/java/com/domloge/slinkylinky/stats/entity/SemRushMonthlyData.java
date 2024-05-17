package com.domloge.slinkylinky.stats.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Index;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import lombok.Getter;
import lombok.Setter;


@Table(uniqueConstraints = 
    @UniqueConstraint(columnNames = {"uniqueYearMonth", "domain"}),
    indexes = @Index(columnList = "date, domain"))
@Entity
public class SemRushMonthlyData extends AbstractMonthlyData {

    @Column(nullable = false)
    @Getter @Setter private long traffic;

    @Column(nullable = false)
    @Getter @Setter private long srrank;

    @Override
    public String getDataPointName() {
        return "SEMRush traffic";
    }

    @Override
    public String getDataPointValue() {
        return String.valueOf(traffic);
    }
}
