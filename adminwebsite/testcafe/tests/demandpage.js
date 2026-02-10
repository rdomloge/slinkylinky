import { Role, Selector } from 'testcafe';
import { gitHubUser } from './roles';
import { createNewDemand, createSupplier } from './helper';


fixture("Demand List Page")
    .page("http://" + process.env.HOST + ":3000/demand");

console.log("Running testcafe tests for demand page against " + process.env.HOST + ":3000/demand");

test("Functionality enabled on login", async t => {

    await t.expect(Selector('div').find('.pageTitle').innerText).contains("Demand");

    console.log("Demand page loaded.");
    
    const newButton = Selector('button')
        .with({visibilityCheck: true})
        .withExactText('New');

    // have to make sure there is some demand
    console.log("Creating a new demand");
    await createNewDemand(0);
    console.log("Created a new demand");
    await t.useRole(Role.anonymous());

    const firstDemandCard = Selector('#demandCard-0');
    const firstDemandSelectLink = firstDemandCard.find('section > div > a:nth-child(1) > span');
    const firstDemandEditLink = firstDemandCard.find('section > div > a:nth-child(2) > span'); 
    const firstDemandDeleteLink = firstDemandCard.find('section > div > div > span');
    
    await t.expect(newButton.hasAttribute('disabled')).ok();
    await t.expect(firstDemandSelectLink.visible).notOk();
    await t.expect(firstDemandEditLink.visible).notOk();
    await t.expect(firstDemandDeleteLink.visible).notOk();

    await t
        .useRole(gitHubUser)
        .expect(Selector('#__next > nav > div > div.float-right > div > div > button').innerText).eql('Sign out');
        
    await t.expect(newButton.hasAttribute('disabled')).notOk();
    await t.expect(firstDemandSelectLink.visible).ok();
    await t.expect(firstDemandEditLink.visible).ok();
    await t.expect(firstDemandDeleteLink.visible).ok();
});

