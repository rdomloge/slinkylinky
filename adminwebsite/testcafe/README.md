# RUNNING IN WINDOWS 

Install nodejs
Install testcafe

SET YOUR GITHUB PASSWORD AS AN ENVIRONMENT VAR (for powershell)
$env:githubUsername="username";
$env:githubPassword="password";
$env:HOST="localhost";

npx testcafe --config-file .\.windows..testcaferc.json "chrome '--window-size=1300,1000'" tests/staging.js
npx testcafe --config-file .\.windows..testcaferc.json "chrome '--window-size=1300,1000'" tests/**/*.js

# RUNNING IN LINUX/CONTAINER
SET YOUR GITHUB USERNAME/PASSWORD AS AN ENVIRONMENT VAR (for bash)
export githubUsername="username"
export githubPassword="password"

run the run_locally.sh script