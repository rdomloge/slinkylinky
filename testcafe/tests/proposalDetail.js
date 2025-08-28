import { createNewDemand, createSupplier } from './helper';

fixture("Proposal Detail Page")
    .page("http://" + process.env.HOST + ":3000/demand");

test("Proposal can be created", async t=> {

    // await t.useRole(gitHubUser)

    await createSupplier(1);

    await createNewDemand(5);

})