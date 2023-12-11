package com.domloge.slinkylinky.linkservice.setup;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Collections;
import java.util.List;

import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.MappingIterator;
import com.fasterxml.jackson.dataformat.csv.CsvMapper;
import com.fasterxml.jackson.dataformat.csv.CsvSchema;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class Loader {
    
    public <T> List<T> loadObjectList(Class<T> type, String fileName) {
        log.info("Loading {} from {}", type.getSimpleName(), fileName);
        try {
            CsvSchema bootstrapSchema = CsvSchema.emptySchema().withHeader();
            CsvMapper mapper = new CsvMapper();
            mapper.disable(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES);
            // File file = new ClassPathResource(fileName).getFile();
            MappingIterator<T> readValues = 
                mapper.reader(type).with(bootstrapSchema).readValues(new ClassPathResource(fileName).getInputStream());
            return readValues.readAll();
        } 
        catch(FileNotFoundException fnex) {
            log.error("Could not load {}, it is missing", fileName);
            return Collections.emptyList();
        }
        catch (Exception e) {
            log.error("Error occurred while loading object list from file " + fileName, e);
            return Collections.emptyList();
        }
    }
}
