import { t, Selector } from "testcafe";

class matchingModel {
    constructor() {
        this.selectableSupplierCards = Selector("div[id^='selectableSupplierCard-']")
    }

    findCardByName(supplierName) {
        return this.selectableSupplierCards
            .find("div.list-card.card.relative > div.text-xl.my-2")
            .withText(supplierName)
            .parent()
            .parent()
    }

    supplierWebsiteInSupplierCard(supplierName) {
        return this.findCardByName(supplierName).find('div.list-card.card.relative > div.grid.grid-cols-12 > a:nth-child(2)')
    }

    supplierEmailInSupplierCard(supplierName) {
        return this.findCardByName(supplierName).find('div.list-card.card.relative > div.grid.grid-cols-12 > a:nth-child(4) > span')
    }

    supplierDaInSupplierCard(supplierName) {
        return this.findCardByName(supplierName).find('div.list-card.card.relative > div.grid.grid-cols-12 > span.col-span-11.align-middle.text-lg.font-bold')
    }

    supplierFeeInSupplierCard(supplierName) {
        return this.findCardByName(supplierName).find('div.list-card.card.relative > div.grid.grid-cols-12 > span:nth-child(8)')
    }

    supplierSourceInSupplierCard(supplierName) {
        return this.findCardByName(supplierName).find('div.list-card.card.relative > div.grid.grid-cols-12 > span:nth-child(10)')
    }

    supplierCategoriesInSupplierCard(supplierName) {
        return this.findCardByName(supplierName).find('#selectableSupplierCard-0 > div.list-card.card.relative > div.child-card.flex.flex-wrap > span')
    }

    async clickSupplier(supplierName) {
        await t.click(this.findCardByName(supplierName)
            .find('div.top-10.right-10.relative.float-right.z-50 > span'));
    }
}

export default new matchingModel();