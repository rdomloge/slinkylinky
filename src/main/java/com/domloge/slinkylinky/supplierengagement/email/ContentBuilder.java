package com.domloge.slinkylinky.supplierengagement.email;

public class ContentBuilder {
    
    private String content;

    public String getContent() {
        return content;
    }

    public void build(Context ctx) {

        content = "<p>Hi <b style='color:red'>"+ctx.getSupplierDetails().getName()
            + "</b>, please see attached for an aticle to engage with. We have you on file as charging "
            + ctx.getSupplierDetails().getCombinedCurrencyFee() +". If you agree, please post the article, create an invoice for " 
            + ctx.getSupplierDetails().getCombinedCurrencyFee() + " and then click <a href='"+ctx.getSlinkyLinkyDomain()
            + "/public/supplierresponse?id=" + ctx.getDbEngagement().getGuid()
            +"'>here</a> to upload the invoice, inform is of the URL to the article and enter the article title,</p><p>Regards, Slinkylinky</p>";
    }
}
