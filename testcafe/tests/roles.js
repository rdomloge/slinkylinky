import { Selector } from 'testcafe';
import { Role } from 'testcafe';

export const gitHubUser = Role('http://localhost:3000/api/auth/signin', async t => {
    
    
    await t.click('body > div.page > div > div > div:nth-child(2) > form > button');
    
    await t.typeText('#login_field', process.env.githubUsername);
    await t.typeText('#password', process.env.githubPassword);
    
    await t.click('#login > div.auth-form-body.mt-3 > form > div > input.btn.btn-primary.btn-block.js-sign-in-button');

    const loginError = Selector('#js-flash-container > div > div > div');
    await t.expect(loginError.exists).notOk();

    const reAuthButton = Selector('button.js-oauth-authorize');

    if(await reAuthButton.exists) {
        await t.wait(1000)
        await t.click(reAuthButton);
    }

    await t.wait(2000)
});