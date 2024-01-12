package com.domloge.slinkylinky.supplierengagement;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@AllArgsConstructor
@ToString
public class SupplierDetails {
    String name;
    String email;
    String website;
    String weWriteFee;
    String weWriteFeeCurrency;

    public String getCombinedCurrencyFee() {
        return weWriteFeeCurrency + weWriteFee;
    }

    public boolean validate() {
        return name != null && !name.isEmpty()
                && email != null && !email.isEmpty()
                && website != null && !website.isEmpty()
                && weWriteFee != null && !weWriteFee.isEmpty();
    }
}
