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
        this.currency = Selector('#__next > div > div.col-span-7.h-full > div.list-card.card > div.w-20.inline-block.pr-8.mt-8 > div > input')
        this.supplierExistsMessage = Selector('#supplierExistsMessage')
        this.blacklistedSupplierMessage = Selector('#blacklistedSupplierMessage')
        this.blackListButton = Selector('#stats-modal > div > div > button')
        this.confirmBlacklistButton = Selector('#blacklist-modal > div > div > button')   
        this.disableToggle = Selector('#__next > div > div.col-span-7.h-full > div.list-card.card > div.float-right.p-1 > label > div')
        this.disableInput = Selector('#__next > div > div.col-span-7.h-full > div.list-card.card > div.float-right.p-1 > label > input')
        

        this.loadStatsButton = Selector('button')
            .withExactText('Load');

        this.submitButton = Selector('button')
            .with({visibilityCheck: true})
            .withExactText('Submit');
    }
}


export default new addEditSupplierModel();
