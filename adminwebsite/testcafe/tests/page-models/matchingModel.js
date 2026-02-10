import { t, Selector } from "testcafe";
import supplierCard from "../card-models/supplierCard";
import { clickWhenReady } from "../helper";

class matchingModel {
    constructor() {
        this.selectableSupplierCards = Selector("div[id^='selectableSupplierCard-']")
    }

    findCardByName(supplierName) {
        return Selector('#supplier-name')
            .withExactText(supplierName)
            .parent('div[id^=selectableSupplierCard-]')
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
        console.log(`clicking supplier ${supplierName}`);
        const matchingCard = this.findCardByName(supplierName);
        await t.expect(matchingCard.exists).ok();

        console.log(null != matchingCard ? `found card` : `no card found`);
        
        const selectBtn = matchingCard.find(supplierCard.selectButton);
        await t.expect(selectBtn.exists).ok();

        console.log(null != selectBtn ? `found select button` : `no select button found`);
        console.log("Type: "+(typeof selectBtn));
        await clickWhenReady(selectBtn);
    }
}

export default new matchingModel();