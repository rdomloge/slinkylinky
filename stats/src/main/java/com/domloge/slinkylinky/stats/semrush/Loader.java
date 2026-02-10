package com.domloge.slinkylinky.stats.semrush;

import java.util.Collections;
import java.util.List;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.MappingIterator;
import com.fasterxml.jackson.dataformat.csv.CsvMapper;
import com.fasterxml.jackson.dataformat.csv.CsvSchema;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class Loader {
    public static <T> List<T> loadObjectList(Class<T> type, String csvData) {
        try {
            CsvSchema schema = CsvSchema.builder()
                .addNumberColumn("organicTraffic")
                .addColumn("rank")
                .addColumn("date")
                .build()
                .withColumnSeparator(';')
                .withHeader();
            CsvMapper mapper = new CsvMapper();
            mapper.disable(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES);
            MappingIterator<T> readValues = 
                mapper.reader(type).with(schema).readValues(csvData);
            return readValues.readAll();
        } 
        catch (Exception e) {
            log.error("Error occurred while loading object list from data: " + csvData, e);
            return Collections.emptyList();
        }
    }
}
