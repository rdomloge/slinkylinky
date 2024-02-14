import { t } from "testcafe";
import demandList from "./page-models/demandListModel";
import addEditDemand from "./page-models/addEditDemand";
import { gitHubUser } from './roles';
import supplierListModel from "./page-models/supplierListModel";
import addEditSupplier from "./page-models/addEditSupplier";

const demandData = require('./demand-data.json');
const supplierData = require('./supplier-data.json');

export async function gotoNewDemandPage() {
    
    if ( ! (await demandList.pageTitle.innerText).startsWith("Demand ")) {
        await t.click(demandList.demandListMenuItem)
            .expect(demandList.pageTitle.innerText).contains("Demand ");
    }
    
    await t.useRole(gitHubUser)
        .click(demandList.newButton)
        .expect(addEditDemand.pageTitle.innerText).contains("New demand");
}

export async function gotoNewSupplierPage() {
    await t.useRole(gitHubUser)
        .click(supplierListModel.supplierMenuItem)
        .expect(supplierListModel.pageTitle.innerText).contains("Suppliers");
    
    await t.click(supplierListModel.newButton)
        .expect(addEditSupplier.pageTitle.innerText).contains("New supplier");
}

export async function createSupplier(dataIndex) {
    
    if(null == dataIndex || dataIndex < 0 || dataIndex >= demandData.length) {
        throw new Error("Invalid dataIndex");
    }

    await gotoNewSupplierPage();

    await t.typeText(addEditSupplier.nameInput, supplierData[dataIndex].name);
    await t.typeText(addEditSupplier.da, supplierData[dataIndex].da);
    await t.typeText(addEditSupplier.website, supplierData[dataIndex].website);
    await t.typeText(addEditSupplier.source, supplierData[dataIndex].source);
    await t.typeText(addEditSupplier.email, supplierData[dataIndex].email);
    await t.typeText(addEditSupplier.fee, supplierData[dataIndex].fee);
    await t.typeText(addEditSupplier.categorySelectorInput, supplierData[dataIndex].categories[0]);
    await t.pressKey('enter');
    await t.click(addEditSupplier.submitButton)
        .expect(addEditSupplier.pageTitle.innerText).contains('Edit supplier');
}

export async function createNewDemand(dataIndex) {

    if(null == dataIndex || dataIndex < 0 || dataIndex >= demandData.length) {
        throw new Error("Invalid dataIndex");
    }

    // await t.debug()
    await gotoNewDemandPage();

    await t.useRole(gitHubUser)
        .typeText(addEditDemand.nameInput, demandData[dataIndex].name);
    const firstSearchResultSelectButton = addEditDemand.demandSiteSearchResults.nth(0).find('div.flex-0.pr-4.m-auto > button');
    await t.click(firstSearchResultSelectButton); // SELECT THE FIRST DEMAND SITE
    await t.expect(addEditDemand.nameLabel.innerText).eql(demandData[dataIndex].demandSiteExcpectName);

    // fill in the missing values
    await t.typeText(addEditDemand.urlInput, demandData[dataIndex].url);
    await t.typeText(addEditDemand.requestedInput, demandData[dataIndex].requested);
    await t.typeText(addEditDemand.daNeededInput, demandData[dataIndex].daNeeded);
    await t.typeText(addEditDemand.anchorTextInput, demandData[dataIndex].anchorText);

    // submit the form
    await t.click(addEditDemand.submitButton)
        .expect(addEditDemand.pageTitle.innerText).contains("Demand ");
}