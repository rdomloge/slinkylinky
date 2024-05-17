import { gitHubUser } from './roles';
import addEditSupplierPage from './page-models/addEditSupplier';
import supplierListModel from './page-models/supplierListModel';
import supplierCard from './card-models/supplierCard';
import menu from './page-models/menu';
import { clickWhenReady } from './helper';


fixture("Edit Supplier Page")
    .page("http://localhost:3000/supplier");

test("Name pulled through and persisted when edited", async t=> {
    await t.useRole(gitHubUser)
        .expect(supplierListModel.pageTitle.innerText).contains('Suppliers')

    const supplierName = 'Maryam bibi';
    const editSupplierName = '888';

    // find a supplier to edit
    await t.typeText(supplierListModel.textSearchField, 'urbansplatter', {speed: 0.5})
        .expect(supplierListModel.pageTitle.innerText).contains('Suppliers (1)');

    await clickWhenReady(supplierListModel.supplierCards.find(supplierCard.editButton))
        .expect(addEditSupplierPage.editPageTitle.innerText).contains('Edit supplier')
        .expect(addEditSupplierPage.nameInput.value).eql(supplierName);

    await t.typeText(addEditSupplierPage.nameInput, editSupplierName, {replace: true})

    // save the changes
    await clickWhenReady(addEditSupplierPage.submitButton)
        .expect(supplierListModel.pageTitle.innerText).contains('Suppliers');

    // check that the supplier card name now matches the edited name
    await t.typeText(supplierListModel.textSearchField, 'urbansplatter', {speed: 0.5})
        .expect(supplierListModel.pageTitle.innerText).contains('Suppliers (1)')
        .expect(supplierListModel.supplierCards.find(supplierCard.name).innerText).eql(editSupplierName);
    

    // check that the changes have been saved
    await clickWhenReady(supplierListModel.supplierCards.find(supplierCard.editButton))
        .expect(addEditSupplierPage.editPageTitle.innerText).contains('Edit supplier')
        .expect(addEditSupplierPage.nameInput.value).eql(editSupplierName);

    // reset the name
    await t.typeText(addEditSupplierPage.nameInput, supplierName, {replace: true})

    // save the changes
    await clickWhenReady(addEditSupplierPage.submitButton)
        .expect(supplierListModel.pageTitle.innerText).contains('Suppliers');
});

test("Website pulled through and persisted when edited", async t=> {
    await t.useRole(gitHubUser)
        .expect(supplierListModel.pageTitle.innerText).contains('Suppliers')

    const supplierWebsite = 'https://www.urbansplatter.com/';
    const editSupplierWebsite = 'https://www.editedwebsite.com/';

    // find a supplier to edit
    await t.typeText(supplierListModel.textSearchField, 'urbansplatter', {speed: 0.5})
        .expect(supplierListModel.pageTitle.innerText).contains('Suppliers (1)');

    await clickWhenReady(supplierListModel.supplierCards.find(supplierCard.editButton))
        .expect(addEditSupplierPage.editPageTitle.innerText).contains('Edit supplier')
        .expect(addEditSupplierPage.website.value).eql(supplierWebsite);

    await t.typeText(addEditSupplierPage.website, editSupplierWebsite, {replace: true})

    // save the changes
    await clickWhenReady(addEditSupplierPage.submitButton)
        .expect(supplierListModel.pageTitle.innerText).contains('Suppliers');

    // check that the supplier card name now matches the edited name
    await t.typeText(supplierListModel.textSearchField, 'editedwebsite', {speed: 0.5})
        .expect(supplierListModel.pageTitle.innerText).contains('Suppliers (1)')
        .expect(supplierListModel.supplierCards.find(supplierCard.website).innerText).eql(editSupplierWebsite);
    

    // check that the changes have been saved
    await clickWhenReady(supplierListModel.supplierCards.find(supplierCard.editButton))
        .expect(addEditSupplierPage.editPageTitle.innerText).contains('Edit supplier')
        .expect(addEditSupplierPage.website.value).eql(editSupplierWebsite);


    // reset the name
    await t.typeText(addEditSupplierPage.website, supplierWebsite, {replace: true})

    // save the changes
    await clickWhenReady(addEditSupplierPage.submitButton)
        .expect(supplierListModel.pageTitle.innerText).contains('Suppliers');
});

test("DA pulled through and persisted when edited", async t=> {
    await t.useRole(gitHubUser)
        .expect(supplierListModel.pageTitle.innerText).contains('Suppliers')

    // find a supplier to edit
    await t.typeText(supplierListModel.textSearchField, 'urbansplatter', {speed: 0.5})
        .expect(supplierListModel.pageTitle.innerText).contains('Suppliers (1)');

    // since DA can change over time we have to capture it from the search results card
    const supplierDa = await supplierListModel.supplierCards.find(supplierCard.da).innerText;
    const editSupplierDa = '1';

    await clickWhenReady(supplierListModel.supplierCards.find(supplierCard.editButton))
        .expect(addEditSupplierPage.editPageTitle.innerText).contains('Edit supplier')
        .expect(addEditSupplierPage.da.value).eql(supplierDa);  

    await t.typeText(addEditSupplierPage.da, editSupplierDa, {replace: true})

    // save the changes
    await t.click(addEditSupplierPage.submitButton)
        .expect(supplierListModel.pageTitle.innerText).contains('Suppliers');

    // check that the supplier card name now matches the edited name
    await t.typeText(supplierListModel.textSearchField, 'urbansplatter', {speed: 0.5})
    await t.expect(supplierListModel.pageTitle.innerText).contains('Suppliers (1)')
    await t.expect(supplierListModel.supplierCards.find(supplierCard.da).innerText).eql(editSupplierDa);
    

    // check that the changes have been saved
    await clickWhenReady(supplierListModel.supplierCards.find(supplierCard.editButton))
        .expect(addEditSupplierPage.editPageTitle.innerText).contains('Edit supplier', "The page title should be 'Edit supplier'")
        .expect(addEditSupplierPage.da.value).eql(editSupplierDa);

    // reset the name
    await t.typeText(addEditSupplierPage.da, supplierDa, {replace: true})

    // save the changes
    await clickWhenReady(addEditSupplierPage.submitButton)
        .expect(supplierListModel.pageTitle.innerText).contains('Suppliers');
});

test("Source pulled through and persisted when edited", async t=> {
    await t.useRole(gitHubUser)
        .expect(supplierListModel.pageTitle.innerText).contains('Suppliers')

    // find a supplier to edit
    await t.typeText(supplierListModel.textSearchField, 'urbansplatter', {speed: 0.5})
        .expect(supplierListModel.pageTitle.innerText).contains('Suppliers (1)');

    // since source can change over time we have to capture it from the search results card
    const supplierSource = await supplierListModel.supplierCards.find(supplierCard.source).innerText;
    const editSupplierSource = 'edited source';

    // await t.expect(supplierListModel.supplierCards.find(supplierCard.editButton).hasAttribute('disabled')).notOk()
    //     .click(supplierListModel.supplierCards.find(supplierCard.editButton))
    //     .expect(addEditSupplierPage.editPageTitle.innerText).contains('Edit supplier')
    //     .expect(addEditSupplierPage.source.value).eql(supplierSource);
    await clickWhenReady(supplierListModel.supplierCards.find(supplierCard.editButton))
        .expect(addEditSupplierPage.editPageTitle.innerText).contains('Edit supplier')
        .expect(addEditSupplierPage.source.value).eql(supplierSource);

    await t.typeText(addEditSupplierPage.source, editSupplierSource, {replace: true})

    // save the changes
    await t.click(addEditSupplierPage.submitButton)
    await t.expect(supplierListModel.pageTitle.innerText).contains('Suppliers');

    // check that the supplier card name now matches the edited name
    await t.typeText(supplierListModel.textSearchField, 'urbansplatter', {speed: 0.5})
        .expect(supplierListModel.pageTitle.innerText).contains('Suppliers (1)')
        .expect(supplierListModel.supplierCards.find(supplierCard.source).innerText).eql(editSupplierSource);
    

    // check that the changes have been saved
    await clickWhenReady(supplierListModel.supplierCards.find(supplierCard.editButton))
        .expect(addEditSupplierPage.editPageTitle.innerText).contains('Edit supplier')
        .expect(addEditSupplierPage.source.value).eql(editSupplierSource);

    // reset the name
    await t.typeText(addEditSupplierPage.source, supplierSource, {replace: true})

    // save the changes
    await t.click(addEditSupplierPage.submitButton)
        .expect(supplierListModel.pageTitle.innerText).contains('Suppliers');
});

test("Email pulled through and persisted when edited", async t=> {
    await t.useRole(gitHubUser)
        .expect(supplierListModel.pageTitle.innerText).contains('Suppliers')

    // find a supplier to edit
    await t.typeText(supplierListModel.textSearchField, 'urbansplatter', {speed: 0.5})
        .expect(supplierListModel.pageTitle.innerText).contains('Suppliers (1)');

    // since email can change over time we have to capture it from the search results card
    const supplierEmail = await supplierListModel.supplierCards.find(supplierCard.email).innerText;
    const editSupplierEmail = 'edited@email.com';

    // await t.click(supplierListModel.supplierCards.find(supplierCard.editButton))
    //     .expect(addEditSupplierPage.editPageTitle.innerText).contains('Edit supplier')
    //     .expect(addEditSupplierPage.email.value).eql(supplierEmail);
    await clickWhenReady(supplierListModel.supplierCards.find(supplierCard.editButton))
        .expect(addEditSupplierPage.editPageTitle.innerText).contains('Edit supplier')
        .expect(addEditSupplierPage.email.value).eql(supplierEmail);

    await t.typeText(addEditSupplierPage.email, editSupplierEmail, {replace: true})

    // save the changes
    await t.click(addEditSupplierPage.submitButton)
    await t.expect(supplierListModel.pageTitle.innerText).contains('Suppliers');

    // check that the supplier card name now matches the edited name
    await t.typeText(supplierListModel.textSearchField, 'urbansplatter', {speed: 0.5})
        .expect(supplierListModel.pageTitle.innerText).contains('Suppliers (1)')
        .expect(supplierListModel.supplierCards.find(supplierCard.email).innerText).eql(editSupplierEmail);
    

    // check that the changes have been saved
    // await t.expect(supplierListModel.supplierCards.find(supplierCard.editButton).hasAttribute('disabled')).notOk()
    //     .click(supplierListModel.supplierCards.find(supplierCard.editButton))
    //     .expect(addEditSupplierPage.editPageTitle.innerText).contains('Edit supplier')
    //     .expect(addEditSupplierPage.email.value).eql(editSupplierEmail);
    await clickWhenReady(supplierListModel.supplierCards.find(supplierCard.editButton))
        .expect(addEditSupplierPage.editPageTitle.innerText).contains('Edit supplier')
        .expect(addEditSupplierPage.email.value).eql(editSupplierEmail);

    // reset the name
    await t.typeText(addEditSupplierPage.email, supplierEmail, {replace: true})

    // save the changes
    await t.click(addEditSupplierPage.submitButton)
        .expect(supplierListModel.pageTitle.innerText).contains('Suppliers');
});

test("WeWriteFee pulled through and persisted when edited", async t=> {
    await t.useRole(gitHubUser)
        .expect(supplierListModel.pageTitle.innerText).contains('Suppliers')

    // find a supplier to edit
    await t.typeText(supplierListModel.textSearchField, 'urbansplatter', {speed: 0.5})
        .expect(supplierListModel.pageTitle.innerText).contains('Suppliers (1)');

    // since fee can change over time we have to capture it from the search results card
    const supplierFeeAndCurrency = await supplierListModel.supplierCards.find(supplierCard.fee).innerText;
    const supplierFee = supplierFeeAndCurrency.slice(1);
    const supplierCurrency = supplierFeeAndCurrency.slice(0, 1);
    const editSupplierFee = '1000';

    await t.click(supplierListModel.supplierCards.find(supplierCard.editButton), {speed: 0.7})
        .expect(addEditSupplierPage.editPageTitle.innerText).contains('Edit supplier')
        .expect(addEditSupplierPage.fee.value).eql(supplierFee);

    await t.typeText(addEditSupplierPage.fee, editSupplierFee, {replace: true})

    // save the changes
    await t.click(addEditSupplierPage.submitButton)
        .expect(supplierListModel.pageTitle.innerText).contains('Suppliers');

    // check that the supplier card name now matches the edited name
    await t.typeText(supplierListModel.textSearchField, 'urbansplatter', {speed: 0.5})
        .expect(supplierListModel.pageTitle.innerText).contains('Suppliers (1)')
        .expect(supplierListModel.supplierCards.find(supplierCard.fee).innerText).eql(supplierCurrency + editSupplierFee);
    

    // check that the changes have been saved
    // await t.expect(supplierListModel.supplierCards.find(supplierCard.editButton).hasAttribute('disabled')).notOk()
    //     .click(supplierListModel.supplierCards.find(supplierCard.editButton))
    //     .expect(addEditSupplierPage.editPageTitle.innerText).contains('Edit supplier')
    //     .expect(addEditSupplierPage.fee.value).eql(editSupplierFee);
    await clickWhenReady(supplierListModel.supplierCards.find(supplierCard.editButton))
        .expect(addEditSupplierPage.editPageTitle.innerText).contains('Edit supplier')
        .expect(addEditSupplierPage.fee.value).eql(editSupplierFee);

    // reset the name
    await t.typeText(addEditSupplierPage.fee, supplierFee, {replace: true})

    // save the changes
    await t.click(addEditSupplierPage.submitButton)
        .expect(supplierListModel.pageTitle.innerText).contains('Suppliers');
});

test("Currency pulled through and persisted when edited", async t=> {
    await t.useRole(gitHubUser)
        .expect(supplierListModel.pageTitle.innerText).contains('Suppliers')

    // find a supplier to edit
    await t.typeText(supplierListModel.textSearchField, 'urbansplatter', {speed: 0.5})
        .expect(supplierListModel.pageTitle.innerText).contains('Suppliers (1)');

    // since fee can change over time we have to capture it from the search results card
    const supplierFeeAndCurrency = await supplierListModel.supplierCards.find(supplierCard.fee).innerText;
    const supplierFee = supplierFeeAndCurrency.slice(1);
    const supplierCurrency = supplierFeeAndCurrency.slice(0, 1);
    const editSupplierCurrency = '£' === supplierCurrency ? '$' : '£';

    await supplierListModel.supplierCards.find(supplierCard.editButton).visible;
    await t.click(supplierListModel.supplierCards.find(supplierCard.editButton))
        .expect(addEditSupplierPage.editPageTitle.innerText).contains('Edit supplier') 
        .expect(addEditSupplierPage.currency.value).eql(supplierCurrency);

    await t.typeText(addEditSupplierPage.currency, editSupplierCurrency, {replace: true})

    // save the changes
    await t.click(addEditSupplierPage.submitButton, {speed: 0.7})
        .expect(supplierListModel.pageTitle.innerText).contains('Suppliers');

    // check that the supplier card currency now matches the edited currency
    await t.typeText(supplierListModel.textSearchField, 'urbansplatter', {speed: 0.5})
        .expect(supplierListModel.pageTitle.innerText).contains('Suppliers (1)')
        .expect(supplierListModel.supplierCards.find(supplierCard.fee).innerText).eql(editSupplierCurrency + supplierFee);
    

    // check that the changes have been saved
    await t.expect(supplierListModel.supplierCards.find(supplierCard.editButton).hasAttribute('disabled')).notOk()
        .click(supplierListModel.supplierCards.find(supplierCard.editButton))
        .expect(addEditSupplierPage.editPageTitle.innerText).contains('Edit supplier')
        .expect(addEditSupplierPage.currency.value).eql(editSupplierCurrency);

    // reset the currency
    await t.typeText(addEditSupplierPage.currency, supplierCurrency, {replace: true})

    // save the changes
    await t.expect(addEditSupplierPage.submitButton.hasAttribute('disabled')).notOk()
        .click(addEditSupplierPage.submitButton)
        .expect(supplierListModel.pageTitle.innerText).contains('Suppliers');
});