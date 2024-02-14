import { t, Selector } from "testcafe";

class addEditSupplierModel {
    constructor() {
        this.pageTitle = Selector('div').find('.pageTitle')
        
        this.nameInput = Selector('#__next > div > div.col-span-7.h-full > div.list-card.card > div:nth-child(4) > div > input')
        this.da = Selector('#__next > div > div.col-span-7.h-full > div.list-card.card > div:nth-child(5) > div > input')
        this.website = Selector('#__next > div > div.col-span-7.h-full > div.list-card.card > div:nth-child(6) > div > input')
        this.source = Selector('#__next > div > div.col-span-7.h-full > div.list-card.card > div:nth-child(7) > div > input')
        this.email = Selector('#__next > div > div.col-span-7.h-full > div.list-card.card > div:nth-child(8) > div > input')
        this.fee = Selector('#__next > div > div.col-span-7.h-full > div.list-card.card > div:nth-child(10) > div > input')
        this.categorySelectorInput = Selector('#react-select-this-should-be-unique-on-the-page-input')
        this.submitButton = Selector('button')
            .with({visibilityCheck: true})
            .withExactText('Submit');
***REMOVED***
}


export default new addEditSupplierModel();
