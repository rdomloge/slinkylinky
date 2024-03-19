Install nodejs
Install testcafe

SET YOUR GITHUB PASSWORD AS AN ENVIRONMENT VAR (for powershell)
$env:githubUsername="username";
$env:githubPassword="password";

npx testcafe "chrome '--window-size=1300,1000'" tests/staging.js
npx testcafe "chrome '--window-size=1300,1000'" tests/**/*.js