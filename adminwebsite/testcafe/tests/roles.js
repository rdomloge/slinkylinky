import { Selector } from 'testcafe';
import { Role } from 'testcafe';

export const gitHubUser = Role("http://" + process.env.HOST + ":3000/api/auth/signin", async t => {
    
    console.log('Logging in to GitHub using ', "http://" + process.env.HOST + ":3000/api/auth/signin");
    await t.click('body > div.page > div > div > div:nth-child(2) > form > button');
    console.log('Clicked on GitHub login button. Logging in with', obfuscate(process.env.githubUsername), 'and', obfuscate(process.env.githubPassword));
    
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
    console.log('Logged in to GitHub');
});


/**
 * Obfuscates a string by replacing characters after the first three with asterisks.
 * If the string is less than 3 characters, it returns the first character followed by an asterisk.
 * 
 * @param {string} str - The string to obfuscate.
 * @returns {string} - The obfuscated string.
 */
function obfuscate(str) {
    // if string is less than 3 characters, return just the first character
    if (str.length < 3) {
        return str ? str[0] + '*' : '';
    }
    return str ? str.substring(0, 3) + '***' : '';
}