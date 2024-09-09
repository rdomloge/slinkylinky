import demandListModel from './page-models/demandListModel';
import { createNewDemand } from './helper';
import matchingModel from './page-models/matchingModel';
import stagingModel from './page-models/stagingModel';
import proposalModel from './page-models/proposalModel';

const matchingSuppliers = require('./matching-supplier-data.json');

fixture("Matching page")
    .page("http://localhost:3000/demand");

test("Suppliers match expected", async t=> {
    
    await createNewDemand(0);

    await demandListModel.clickFulFill('Acticare');

    for (let i = 0; i < matchingSuppliers.length; i++) {
        const s = matchingSuppliers[i];
        const supplierCard = matchingModel.findCardByName(s.name)
        const url = await matchingModel.supplierWebsiteInSupplierCard(s.name).innerText;
        console.log(url)
        await t.expect(matchingModel.supplierWebsiteInSupplierCard(s.name).innerText).eql(s.url)
        await t.expect(matchingModel.supplierEmailInSupplierCard(s.name).innerText).eql(s.email)
        await t.expect(matchingModel.supplierDaInSupplierCard(s.name).innerText).eql(s.da)
        await t.expect(matchingModel.supplierFeeInSupplierCard(s.name).innerText).eql(s.fee)
        await t.expect(matchingModel.supplierSourceInSupplierCard(s.name).innerText).eql(s.source)
    }
    
    await matchingModel.clickSupplier('Jason')
    // need to check that selecting Jason correctly redirected us to staging

    // // probably shouldn't do this - this is a test of the matching page
    // await t.click(stagingModel.submitButton)
    //     .expect(proposalModel.pageTitle.innerText).eql('Proposal')
        
})