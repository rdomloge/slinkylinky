import { t, Selector } from "testcafe";

class stagingModel {
    constructor() {
        this.submitButton = Selector('#submitProposal')

        this.supplier = Selector('#__next > div > div.col-span-7.h-full > div.grid.grid-cols-2.gap-4 > div:nth-child(1) > div.list-card.card.relative')

        this.demand = Selector('#__next > div > div.col-span-7.h-full > div.grid.grid-cols-2.gap-4 > div:nth-child(1) > div.card.list-card.grid.grid-cols-10 > div')

        this.otherMatchingDemandPanel = Selector('#__next > div > div.col-span-7.h-full > div.grid.grid-cols-2.gap-4 > div:nth-child(2)')

        this.otherSelectableDemands = this.otherMatchingDemandPanel.find('div.bg-stone-300')

        this.errors = Selector('[id^="error-"]');
***REMOVED***

    demandName(demand) {
        return demand.find('div.text-xl.my-2')
***REMOVED***

    async selectAll() {
        var checkBoxes = Selector('input[type=checkbox]')

        var panelCount = await this.otherSelectableDemands.count
        console.log('Other demand count: ' + panelCount)

        for (let index = 0; index < await this.otherSelectableDemands.count; index++) {
            const selectableDemand = this.otherSelectableDemands.nth(index);
            this.selectASelectableDemand(selectableDemand)
    ***REMOVED***
***REMOVED***

    getTooManyLinksError() {
        return this.errors.withText('Too many links')
***REMOVED***

    getDuplicateDomainError() {
        return this.errors.withText('Duplicate domain')
***REMOVED***

    getMozLinkError() {
        return this.errors.withText('3rd party link')
***REMOVED***

    async selectASelectableDemand(selectableDemand) {
        var checkBox = selectableDemand.find('input[type=checkbox]')
        await t.click(checkBox)
***REMOVED***

    supplierName() {
        return this.supplier.find('div.text-xl.my-2') 
***REMOVED***

    supplierUrl() {
        return this.supplier.find('div.grid.grid-cols-12 > span:nth-child(2)')
***REMOVED***

    supplierEmail() {
        return this.supplier.find('div.grid.grid-cols-12 > span:nth-child(4)')
***REMOVED***

    supplierDa() {
        return this.supplier.find('div.grid.grid-cols-12 > span:nth-child(6)')
***REMOVED***

    supplierFee() {
        return this.supplier.find('div.grid.grid-cols-12 > span:nth-child(8)')
***REMOVED***

    supplierSource() {
        return this.supplier.find('div.grid.grid-cols-12 > span:nth-child(10)')
***REMOVED***
}

export default new stagingModel();