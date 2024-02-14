import { Selector } from 'testcafe';
import { Role } from 'testcafe';

export const gitHubUser = Role('http://localhost:3000/api/auth/signin', async t => {
    
    
    await t.click('body > div.page > div > div > div:nth-child(2) > form > button');
    
    await t.typeText('#login_field', 'rdomloge@gmail.com');
    await t.typeText('#password', 'Badmuthafucka0');
    
    await t.click('#login > div.auth-form-body.mt-3 > form > div > input.btn.btn-primary.btn-block.js-sign-in-button');

    const reAuthButton = Selector('#js-oauth-authorize-btn');

    if(await reAuthButton.exists) {
        await t.wait(1000)
        await t.click(reAuthButton);
    }

    await t.wait(2000)
});