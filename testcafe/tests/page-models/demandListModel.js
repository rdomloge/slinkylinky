import { t, Selector } from "testcafe";

class demandListModel {
    constructor() {
        this.pageTitle = Selector('div').find('.pageTitle')
        
        this.newButton = Selector('button')
            .with({visibilityCheck: true})
            .withExactText('New');

        this.demandCards = Selector("div[id^='demandCard-']")
        this.demandListMenuItem = Selector('#__next > div > div:nth-child(1) > div > div:nth-child(1) > a')
***REMOVED***

    findCardByName(demandName) {
        return this.demandCards
            .find('div > div.text-xl.my-2')
            .withText(demandName)
            .parent()
            .parent();
***REMOVED***

    async clickFulFill(demandName) {
        
        this.fullFillLink = this.findCardByName(demandName)
            .find('section > div > a:nth-child(1) > span');

        await t.click(this.fullFillLink)
***REMOVED***
}


export default new demandListModel();
