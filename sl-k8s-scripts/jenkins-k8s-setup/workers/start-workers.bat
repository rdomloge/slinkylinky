@echo off
cd /d "%~dp0"

if not exist ".env" (
    echo ERROR: .env not found. Run setup-autostart.bat first.
    pause
    exit /b 1
)

echo Starting Jenkins workers...
docker compose --env-file .env up -d
if %errorlevel% neq 0 (
    echo ERROR: Failed to start workers. Is Docker Desktop running?
    pause
    exit /b %errorlevel%
)
echo Workers started.
