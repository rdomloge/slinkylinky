import { Selector } from 'testcafe';
import { Role } from 'testcafe';

export const gitHubUser = Role('http://localhost:3000/api/auth/signin', async t => {
    
    
    await t.click('body > div.page > div > div > div:nth-child(2) > form > button');
    
    await t.typeText('#login_field', process.env.githubUsername);
    await t.typeText('#password', process.env.githubPassword);
    
    await t.click('#login > div.auth-form-body.mt-3 > form > div > input.btn.btn-primary.btn-block.js-sign-in-button');

    const loginError = Selector('#js-flash-container > div > div > div');
    await t.expect(loginError.exists).notOk();

    const reAuthButton = Selector('body > div.logged-in.env-production.page-responsive.color-bg-subtle > div.application-main > main > div > div.px-3.mt-5 > div.Box.color-shadow-small > div.Box-footer.p-3.p-md-4.clearfix > div:nth-child(1) > form > div > button.js-oauth-authorize-btn.btn.btn-primary.width-full.ws-normal');

    if(await reAuthButton.exists) {
        await t.wait(1000) // takes a moment for the button to become clickable
        await t.click(reAuthButton);
    }

    await t.wait(2000)

    // check that the button now says 'Sign out'
    await t.expect(Selector('#__next > nav > div > div.float-right > div > div > button').innerText).eql('Sign out');
});