@echo off
cd /d "%~dp0"

echo Stopping Jenkins workers...
docker compose --env-file .env stop
echo Workers stopped. They will NOT auto-restart with Docker Desktop (restart=unless-stopped).
echo Run start-workers.bat to start them again and re-enable auto-start.
