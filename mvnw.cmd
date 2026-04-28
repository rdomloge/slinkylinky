@echo off
REM Maven wrapper for Windows

setlocal enabledelayedexpansion

REM Try to find Maven in common locations
if exist "C:\apps\apache-maven-3.9.12" (
    set "MAVEN_HOME=C:\apps\apache-maven-3.9.12"
) else if exist "%ProgramFiles%\apache-maven" (
    set "MAVEN_HOME=%ProgramFiles%\apache-maven"
) else (
    REM Fallback to system mvn if available
    where mvn >nul 2>&1
    if !errorlevel! equ 0 (
        call mvn %*
        exit /b !errorlevel!
    ) else (
        echo Error: Maven not found in C:\apps\apache-maven-3.9.12 or on PATH
        exit /b 1
    )
)

REM Use found Maven home
if defined MAVEN_HOME (
    "%MAVEN_HOME%\bin\mvn.cmd" %*
    exit /b !errorlevel!
)
