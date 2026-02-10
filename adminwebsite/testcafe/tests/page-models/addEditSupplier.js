import { t, Selector } from "testcafe";

class addEditSupplierModel {
    constructor() {
        this.addPageTitle = Selector('#supplier-add-id')
        this.editPageTitle = Selector('#supplier-edit-id')
        
        this.nameInput = Selector('#nameInput')
        this.da = Selector('#daInput')
        this.website = Selector('#websiteInput')
        this.source = Selector('#sourceInput')
        this.email = Selector('#emailInput')
        this.fee = Selector('#costInput')
        this.categorySelectorInput = Selector('#react-select-this-should-be-unique-on-the-page-input')
        this.currency = Selector('#currencyInput')
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
