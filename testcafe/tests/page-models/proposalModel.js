import { t, Selector } from "testcafe";

class proposalModel {
    constructor() {
        this.pageTitle = Selector('div').find('.pageTitle')

        this.supplierName = Selector('#supplierPanel > div > div.text-xl.my-2')

        this.demandCards = Selector("div[id^='demandcard-']")
***REMOVED***

    async findSupplierCardByName(name) {
        this.demandCards.withText(name)
***REMOVED***
}

export default new proposalModel();