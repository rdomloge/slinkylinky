import { Selector } from "testcafe";

class supplierCard {
    constructor() {
        this.name = '#supplier-name'
        this.editButton = '#supplier-editbtn-id'
        this.selectButton = '#supplier-selectbtn-id'
        this.da = '#supplier-da'
        this.source = '#supplier-source'
        this.email = '#supplier-email'
        this.fee = '#supplier-fee'
        this.website = 'div.grid.grid-cols-12 > a:nth-child(2) > span'

        // this.demandSiteSearchResults = Selector("div[id^='demandSiteSearchResult-']")
    }
}

export default new supplierCard();