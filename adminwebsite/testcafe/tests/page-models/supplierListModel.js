import { t, Selector } from "testcafe";

class supplierListModel {
    constructor() {
        this.pageTitle = Selector('#supplier-list-id')
        
        this.newButton = Selector('button')
            .with({visibilityCheck: true})
            .withExactText('New');

        this.supplierMenuItem = Selector('#__next > div > div:nth-child(1) > div > div:nth-child(3) > a')

        this.textSearchField = Selector('#nameEmailDomainFilter')

        this.supplierCardNames = Selector('#supplier-name')

        this.supplierCards = Selector("div[id^='supplier-card-']")
    }
}


export default new supplierListModel();
