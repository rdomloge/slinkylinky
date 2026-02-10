import { Selector } from 'testcafe';
import { gitHubUser } from './roles';



fixture("DemandSite List Page")
    .page("http://" + process.env.HOST + ":3000/demandsites");

test("Demand list has elements", async t=> {
    await t.expect(Selector('div')
        .find('.pageTitle').innerText)
        .contains("Demand sites");
        
    await t.expect(Selector("div[id^='demandsite-']").count).gt(10); // find divs with id starting with demandsite- and count them
})
