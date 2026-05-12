import { Selector } from 'testcafe';
import { gitHubUser } from './roles';
import { BASE_URL } from './base-url';



fixture("DemandSite List Page")
    .page(`${BASE_URL}/demandsites`);

test("Demand list has elements", async t=> {
    await t.expect(Selector('div')
        .find('.pageTitle').innerText)
        .contains("Demand sites");
        
    await t.expect(Selector("div[id^='demandsite-']").count).gt(10); // find divs with id starting with demandsite- and count them
})
