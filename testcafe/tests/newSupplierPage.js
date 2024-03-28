import { gitHubUser } from './roles';
import addEditSupplierPage from './page-models/addEditSupplier';
import supplierListModel from './page-models/supplierListModel';
import supplierCard from './card-models/supplierCard';
import menu from './page-models/menu';


fixture("New Supplier Page")
    .page("http://localhost:3000/supplier/Add");

test("New supplier initial state", async t=> {
    await t.expect(addEditSupplierPage.loadStatsButton.exists).notOk();
    await t.expect(addEditSupplierPage.submitButton.hasAttribute('disabled')).ok();

    await t.expect(addEditSupplierPage.nameInput.value).eql('');
    await t.expect(addEditSupplierPage.da.value).eql('0');
    await t.expect(addEditSupplierPage.website.value).eql('');
    await t.expect(addEditSupplierPage.source.value).eql('');
    await t.expect(addEditSupplierPage.email.value).eql('');
    await t.expect(addEditSupplierPage.currency.value).eql('£');
    await t.expect(addEditSupplierPage.fee.value).eql('0');
});

test("Submit button disabled until 3 chars in name field", async t=> {
    await t.useRole(gitHubUser)

    // put something valid in the website field so that the submit button is enabled
    await t.typeText(addEditSupplierPage.website, 'www.google.com');

    await t.typeText(addEditSupplierPage.nameInput, 'a', {speed: 0.5});
    await t.expect(addEditSupplierPage.submitButton.hasAttribute('disabled')).ok();
    await t.typeText(addEditSupplierPage.nameInput, 'b', {speed: 0.5});
    await t.expect(addEditSupplierPage.submitButton.hasAttribute('disabled')).ok();
    await t.typeText(addEditSupplierPage.nameInput, 'c', {speed: 0.5});
    await t.expect(addEditSupplierPage.submitButton.hasAttribute('disabled')).notOk();
});

test("Submit load stats button invisible until valid domain in website field", async t=> {
    await t.useRole(gitHubUser)
    await t.typeText(addEditSupplierPage.website, 'w', {speed: 0.5});
    await t.expect(addEditSupplierPage.loadStatsButton.exists).notOk();
    await t.typeText(addEditSupplierPage.website, 'w', {speed: 0.5});
    await t.expect(addEditSupplierPage.loadStatsButton.exists).notOk();
    await t.typeText(addEditSupplierPage.website, 'w', {speed: 0.5});
    await t.expect(addEditSupplierPage.loadStatsButton.exists).notOk();
    await t.typeText(addEditSupplierPage.website, '.google.com', {speed: 0.5});
    await t.expect(addEditSupplierPage.loadStatsButton.exists).ok();
    
    // clear the website field and check that the load stats button is gone
    await t.selectText(addEditSupplierPage.website).pressKey('delete');
    await t.expect(addEditSupplierPage.loadStatsButton.exists).notOk();
});

test("Submit button disabled if website domain already exists", async t=> {
    // sign in, create a valid name and a valid domain
    await t.useRole(gitHubUser)
    await t.typeText(addEditSupplierPage.nameInput, 'Test Supplier');
    await t.typeText(addEditSupplierPage.website, 'www.thisdoesnotexist.com', {speed: 0.5});
    await t.expect(addEditSupplierPage.submitButton.hasAttribute('disabled')).notOk(); // all good

    // set a domain that already exists
    await t.selectText(addEditSupplierPage.website).pressKey('delete');
    await t.typeText(addEditSupplierPage.website, 'www.urbansplatter.com', {speed: 0.5});
    await t.expect(addEditSupplierPage.submitButton.hasAttribute('disabled')).ok(); // should be disabled
});

test("Submit button disabled if website domain invalid", async t=> {
    await t.useRole(gitHubUser)
    await t.typeText(addEditSupplierPage.nameInput, 'Test Supplier');
    await t.typeText(addEditSupplierPage.website, 'www.thisdoesnotexist.com', {speed: 0.5});
    await t.expect(addEditSupplierPage.submitButton.hasAttribute('disabled')).notOk();

    await t.selectText(addEditSupplierPage.website).pressKey('delete');
    await t.typeText(addEditSupplierPage.website, 'a.b.c', {speed: 0.5});
    await t.expect(addEditSupplierPage.submitButton.hasAttribute('disabled')).ok();
});

test("Load stats button hidden if website domain exists", async t=> {
    await t.useRole(gitHubUser)
    await t.typeText(addEditSupplierPage.website, 'www.urbansplatter.com', {speed: 0.5});
    await t.expect(addEditSupplierPage.loadStatsButton.exists).notOk();

    await t.expect(addEditSupplierPage.supplierExistsMessage.innerText).eql('Error! Supplier exists.');
});

test("Black list a site and confirm that the error message appears and is persisted when we come back ", async t=> {
    await t.useRole(gitHubUser)
    const dateTimeString = new Date().getTime();
    const website = `www.${dateTimeString}.com`;

    // enter the website and confirm that it is initially accepted
    await t.typeText(addEditSupplierPage.nameInput, 'Test Supplier');
    await t.typeText(addEditSupplierPage.website, website, {speed: 0.5});
    await t.expect(addEditSupplierPage.loadStatsButton.exists).ok();
    await t.expect(addEditSupplierPage.submitButton.hasAttribute('disabled')).notOk();
    await t.expect(addEditSupplierPage.loadStatsButton.exists).ok();

    // click the load stats button to black list the site
    await t.click(addEditSupplierPage.loadStatsButton)
        .expect(addEditSupplierPage.blackListButton.exists).ok();
    
    // confirm the black list
    await t.click(addEditSupplierPage.blackListButton)
        .expect(addEditSupplierPage.confirmBlacklistButton.exists).ok();
    await t.click(addEditSupplierPage.confirmBlacklistButton);
    await t.expect(addEditSupplierPage.blacklistedSupplierMessage.innerText).eql('Error! Supplier is blacklisted.');

    // go back to the home page and come back to the new supplier page
    await t.click(menu.supplierItem)
        .expect(supplierListModel.pageTitle.innerText).contains('Suppliers');
    await t.click(supplierListModel.newButton)
        .expect(addEditSupplierPage.pageTitle.innerText).contains('New supplier');
    
    await t.typeText(addEditSupplierPage.website, website, {speed: 0.5});
    await t.expect(addEditSupplierPage.blacklistedSupplierMessage.innerText).eql('Error! Supplier is blacklisted.');
});

test("Disable existing Supplier", async t=> {
    await t.click(menu.supplierItem)
        .expect(supplierListModel.pageTitle.innerText).contains('Suppliers');

    await t.useRole(gitHubUser)
    
    await t.typeText(supplierListModel.textSearchField, 'urbansplatter', {speed: 0.5})
        .expect(supplierListModel.pageTitle.innerText).contains('Suppliers (1)');

    await t.click(supplierListModel.supplierCards.find(supplierCard.editButton))
        .expect(addEditSupplierPage.pageTitle.innerText).contains('Edit supplier');

    const currentState = await addEditSupplierPage.disableInput.checked;

    await t.click(addEditSupplierPage.disableToggle)
    await t.click(addEditSupplierPage.submitButton)
        .expect(supplierListModel.pageTitle.innerText).contains('Suppliers');

    await t.typeText(supplierListModel.textSearchField, 'urbansplatter', {speed: 0.5})
        .expect(supplierListModel.pageTitle.innerText).contains('Suppliers (1)');

    await t.click(supplierListModel.supplierCards.find(supplierCard.editButton))
        .expect(addEditSupplierPage.pageTitle.innerText).contains('Edit supplier')
        .expect(addEditSupplierPage.disableInput.checked).eql(!currentState);

});