import { Selector } from "testcafe";

class supplierCard {
    constructor() {
        this.name = Selector('#supplier-name')
        this.editButton = 'p.text-right'

        this.website = Selector('div.grid.grid-cols-12 > a:nth-child(2) > span')

        // this.demandSiteSearchResults = Selector("div[id^='demandSiteSearchResult-']")
    }
}

export default new supplierCard();