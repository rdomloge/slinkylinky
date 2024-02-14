import addEditDemand from './page-models/addEditDemand';
import { gotoNewDemandPage } from './helper';
import { gitHubUser } from './roles';


fixture("New Demand Page")
    .page("http://localhost:3000/demand");

test("New demand initial state", async t=> {
        
    await gotoNewDemandPage();

    await t.expect(addEditDemand.submitButton.hasAttribute('disabled')).ok();
    await t.expect(addEditDemand.nameInput.hasAttribute('disabled')).notOk();
    await t.expect(addEditDemand.nameLabel.exists).notOk();
    await t.expect(addEditDemand.anchorTextInput.hasAttribute('disabled')).ok();
    await t.expect(addEditDemand.urlInput.hasAttribute('disabled')).ok();
    await t.expect(addEditDemand.requestedInput.hasAttribute('disabled')).notOk();
    await t.expect(addEditDemand.daNeededInput.hasAttribute('disabled')).ok();
    await t.expect(addEditDemand.newDemandSiteButton.hasAttribute('disabled')).notOk();
***REMOVED***

test("New demand demand site search ", async t=> {

    await gotoNewDemandPage();

    await t.typeText(addEditDemand.nameInput, "ca")
    const emptySearchResult = addEditDemand.demandSiteSearchResults
    await t.expect(emptySearchResult.exists).notOk()

    await t.typeText(addEditDemand.nameInput, "r")
    const firstSearchResult = addEditDemand.demandSiteSearchResults
    await t.expect(firstSearchResult.exists).ok()
})

test("New demand demandSite selection ", async t=> {
    
    await gotoNewDemandPage();

    await t.useRole(gitHubUser)
        .typeText(addEditDemand.nameInput, "car")
    const firstSearchResultSelectButton = addEditDemand.demandSiteSearchResults.nth(0).find('div.flex-0.pr-4.m-auto > button')
    await t.click(firstSearchResultSelectButton) // SELECT THE FIRST DEMAND SITE

    await t.expect(addEditDemand.submitButton.hasAttribute('disabled')).notOk();
    await t.expect(addEditDemand.nameInput.exists).notOk();
    await t.expect(addEditDemand.nameLabel.exists).ok();
    await t.expect(addEditDemand.anchorTextInput.hasAttribute('disabled')).notOk();
    await t.expect(addEditDemand.urlInput.hasAttribute('disabled')).notOk();
    await t.expect(addEditDemand.requestedInput.hasAttribute('disabled')).notOk();
    await t.expect(addEditDemand.daNeededInput.hasAttribute('disabled')).notOk();

    // verify that the url has taken the value of the selected demand site
    // await t.expect(addEditDemand.urlInput.value).eql('shop.acticareuk.com'); // don't do this any more - want to force user to copy and paste
    await t.expect(addEditDemand.nameLabel.innerText).eql('Acticare');

    // fill in the missing values
    await t.typeText(addEditDemand.urlInput, "/testPromo") 
    await t.typeText(addEditDemand.requestedInput, "2024-02-12")
    await t.typeText(addEditDemand.daNeededInput, "30")
    await t.typeText(addEditDemand.anchorTextInput, "Anchor text created by TestCafe")

    // submit the form
    await t.click(addEditDemand.submitButton)
        .expect(addEditDemand.pageTitle.innerText).contains("Demand ");
})

test("New demand create new demandSite ", async t=> {
    
    await gotoNewDemandPage();

    await t.click(addEditDemand.newDemandSiteButton)
        .expect(addEditDemand.newDemandSiteNameInput.exists).ok()
        .expect(addEditDemand.newDemandSiteUrlInput.exists).ok();

    await t.typeText(addEditDemand.newDemandSiteNameInput, "TestCafe demandsite")
    await t.typeText(addEditDemand.newDemandSiteUrlInput, "testcafe.com")
    await t.click(addEditDemand.newDemandSiteCreateButton)
        .expect(addEditDemand.newDemandSiteNameInput.exists).notOk()
        .expect(addEditDemand.newDemandSiteUrlInput.exists).notOk();

    // verify that the search results now match the new demand site
    const firstSearchResult = addEditDemand.demandSiteSearchResults.nth(0)
    await t.expect(firstSearchResult.exists).ok()
    await t.expect(firstSearchResult.find('div.flex-1 > p.text-lg').innerText).contains("TestCafe demandsite")
    await t.expect(firstSearchResult.find('div.flex-1 > p.mb-6').innerText).contains("testcafe.com")
    await t.expect(firstSearchResult.find('div.flex-1 > span').innerText).eql("0")

    await t.expect(addEditDemand.nameLabel.innerText).eql('TestCafe demandsite');
    // await t.expect(addEditDemand.urlInput.value).eql('testcafe.com'); // don't do this any more - want to force user to copy and paste
    await t.expect(addEditDemand.nameInput.exists).notOk();


    // fill in the missing values
    await t.typeText(addEditDemand.urlInput, "/testPromo")
    await t.typeText(addEditDemand.anchorTextInput, "Anchor text created by TestCafe")
    await t.typeText(addEditDemand.requestedInput, "2024-02-12")
    await t.typeText(addEditDemand.daNeededInput, "30")

    // submit the form
    await t.click(addEditDemand.submitButton)
        .expect(addEditDemand.pageTitle.innerText).contains("Demand ");
})