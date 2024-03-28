import { gitHubUser } from './roles';
import { createNewDemand, createSupplierIfMissing } from './helper';
import demandListModel from './page-models/demandListModel';
import matchingModel from './page-models/matchingModel';
import stagingModel from './page-models/stagingModel';

fixture("Staging Page")
    .page("http://localhost:3000/demand");

test("Staging page shows correct supplier and demand", async t=> {

    // await t.useRole(gitHubUser)

    await createSupplierIfMissing(0);

    await createNewDemand(1);
    await createNewDemand(2);
    await createNewDemand(3);
    await createNewDemand(4);

    // Select from the demand list
    await demandListModel.clickFulFill('Gerry O\'Leary');

    // Select our test supplier as the supplier
    await matchingModel.clickSupplier('Supplier with link already to Gerry O\'Leary')

    // check the supplier is correct
    await t.expect(stagingModel.supplierName().innerText).eql('Supplier with link already to Gerry O\'Leary')

    // check the demand is correct
    await t.expect(stagingModel.demandName(stagingModel.demand).innerText).eql('Gerry O\'Leary')

    // check the other matching demand
    //   check we at least have the 3 other demands we created
    await t.takeScreenshot({ fullPage: true, path: 'staging.png'})
    await t.expect(stagingModel.otherSelectableDemands.count).gte(3)

    // check error condition: > 3 demands selected
    await stagingModel.selectAll()
    await t.expect(stagingModel.getTooManyLinksError().exists).ok()
    
    // check error condition: demand domain duplicates
    await t.expect(stagingModel.getDuplicateDomainError().exists).ok()

    // check error condition: Moz reports existing link
    await t.expect(stagingModel.getMozLinkError().exists).ok()

    // Submit the proposal
    // await t.click(stagingModel.submitButton)
    //     .expect(proposalModel.pageTitle.innerText).eql('Proposal')
})