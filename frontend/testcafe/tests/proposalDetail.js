import { createNewDemand, createSupplier } from './helper';
import { BASE_URL } from './base-url';

fixture("Proposal Detail Page")
    .page(`${BASE_URL}/demand`);

test("Proposal can be created", async t=> {

    // await t.useRole(gitHubUser)

    await createSupplier(1);

    await createNewDemand(5);

})