@echo off
setlocal
cd /d "%~dp0"

echo === Jenkins Windows Worker Setup ===
echo.

REM Check Docker is available and running
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Docker Desktop is not running or not installed.
    echo Start Docker Desktop and re-run this script.
    pause
    exit /b 1
)

REM Create .env from example if it doesn't exist
if not exist ".env" (
    if not exist ".env.example" (
        echo ERROR: .env.example not found. Run this script from the workers directory.
        pause
        exit /b 1
    )
    copy ".env.example" ".env" >nul
    echo Created .env from .env.example
    echo.
    echo IMPORTANT: Edit .env and fill in:
    echo   - JENKINS_URL: the external IP of Jenkins on the Pi cluster (port 8099)
    echo   - Worker secrets: from Jenkins UI (Manage Jenkins -^> Nodes -^> [node] -^> agent command line)
    echo.
    echo Opening .env in Notepad. Save it, then re-run this script.
    notepad ".env"
    exit /b 0
)

echo Pulling latest worker images...
docker compose --env-file .env pull
echo.

echo Starting all workers...
docker compose --env-file .env up -d
if %errorlevel% neq 0 (
    echo ERROR: docker compose up failed. Check your .env values and that Docker Desktop is running.
    pause
    exit /b %errorlevel%
)

echo.
echo Setup complete!
echo Workers are running and will automatically restart whenever Docker Desktop starts (unless manually stopped).
echo.
echo To stop workers:  stop-workers.bat
echo To start workers: start-workers.bat
echo To view logs:     docker compose logs -f
pause
