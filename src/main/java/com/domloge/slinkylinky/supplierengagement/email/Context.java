package com.domloge.slinkylinky.supplierengagement.email;

import org.springframework.beans.factory.annotation.Value;

import com.domloge.slinkylinky.supplierengagement.SupplierDetails;
import com.domloge.slinkylinky.supplierengagement.entity.Engagement;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import jakarta.mail.internet.MimeMessage;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
public class Context {

    @Setter
    private JsonObject proposal;
    
    @Getter 
    @Setter 
    private Engagement dbEngagement;
    
    @Getter
    @Setter
    private String slinkyLinkyDomain;
    
    @Setter
    private SupplierDetails supplierDetails;

    @Setter
    @Getter
    private ContentBuilder contentBuilder;

    @Setter
    @Getter
    private MimeMessage message;

    public SupplierDetails getSupplierDetails() {
        if(supplierDetails == null) {
            supplierDetails = findSupplierDetails();
        }
        return supplierDetails;
    }
    
    private SupplierDetails findSupplierDetails() {
        JsonArray paidLinks = proposal.get("paidLinks").getAsJsonArray();
        JsonObject supplier = paidLinks.get(0).getAsJsonObject().get("supplier").getAsJsonObject();
        String name = supplier.has("name") ? supplier.get("name").getAsString() : "";
        String email = supplier.has("email") ? supplier.get("email").getAsString() : "";
        String website = supplier.has("website") ? supplier.get("website").getAsString() : "";
        String weWriteFee = supplier.has("weWriteFee") ? supplier.get("weWriteFee").getAsString() : "Unknown";
        String weWriteFeeCurrency = supplier.has("weWriteFeeCurrency") ? supplier.get("weWriteFeeCurrency").getAsString() : "£";
        return new SupplierDetails(name, email, website, weWriteFee, weWriteFeeCurrency);
    }
}
