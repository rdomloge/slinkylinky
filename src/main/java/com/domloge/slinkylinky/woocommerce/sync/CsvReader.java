package com.domloge.slinkylinky.woocommerce.sync;

import java.io.IOException;
import java.util.List;

import org.springframework.stereotype.Component;

import com.domloge.slinkylinky.woocommerce.dto.LineItemUrlDetails;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.MappingIterator;
import com.fasterxml.jackson.dataformat.csv.CsvMapper;
import com.fasterxml.jackson.dataformat.csv.CsvSchema;

@Component
public class CsvReader {
    CsvMapper mapper = new CsvMapper();
    // CsvSchema schema = mapper.schemaFor(LineItemUrlDetails.class);
        
    
    public List<LineItemUrlDetails> parse(String csv) throws IOException {
        CsvSchema schema = CsvSchema.builder()
            .addColumn("daOrdered")
            .addColumn("chooseWordCount")
            .addColumn("anchorTextOptional")
            .addColumn("targetURL")
            .build()
            .withColumnSeparator(',')
            .withQuoteChar('"')
            .withHeader();
        
        mapper.disable(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES);
        MappingIterator<LineItemUrlDetails> readValues = 
            mapper.reader(LineItemUrlDetails.class).with(schema).readValues(csv);
        return readValues.readAll();
    }
}
