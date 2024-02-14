import { Selector } from "testcafe";

class AddEditDemand {
    constructor() {
        this.pageTitle = Selector('div').find('.pageTitle')
        this.submitButton = Selector('#createnew')
            .with({visibilityCheck: true})
            .withExactText('Submit')

        this.nameInput = Selector('#name')
        this.nameLabel = Selector('#nameLbl')
        this.anchorTextInput = Selector('#anchorText')
        this.urlInput = Selector('#url')
        this.requestedInput = Selector('#requested')
        this.daNeededInput = Selector('#daNeeded')
        this.newDemandSiteButton = Selector('#newDemandSite')

        this.newDemandSiteNameInput = Selector('#newDemandSiteName')
        this.newDemandSiteUrlInput = Selector('#newDemandSiteWebsite')
        this.newDemandSiteCreateButton = Selector('#createDemandSiteButton')

        this.demandSiteSearchResults = Selector("div[id^='demandSiteSearchResult-']")
***REMOVED***
}

export default new AddEditDemand();