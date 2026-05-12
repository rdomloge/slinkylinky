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

# CONFIGURATION

The app base URL is centralised in `tests/base-url.js`. Override via environment variables:

| Variable   | Description            | Default                 |
|------------|------------------------|-------------------------|
| `HOST`     | Hostname               | `localhost`             |
| `APP_PORT` | Port number            | `5173`                  |
| `PROTOCOL` | `http` or `https`      | `http`                  |

**Examples:**

```bash
# Use a custom port
APP_PORT=8080 npx testcafe chrome tests/staging.js

# Use a remote staging server
HOST=staging.example.com APP_PORT=443 PROTOCOL=https npx testcafe chrome tests/staging.js

# Docker with custom port
APP_PORT=8080 ./run_locally.sh
```