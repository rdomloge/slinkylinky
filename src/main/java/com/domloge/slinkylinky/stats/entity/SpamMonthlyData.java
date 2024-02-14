package com.domloge.slinkylinky.stats.entity;

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
public class SpamMonthlyData extends AbstractMonthlyData {
    
    
    @Setter @Getter int spamScore;
}
