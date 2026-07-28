@echo off
title Launching TGDrive Pro...
echo ===================================================
echo           Starting TGDrive Pro Cloud System        
echo ===================================================

:: Ensure Node.js is in PATH for this session
set "PATH=%PATH%;C:\Program Files\nodejs"

:: Check & Install Backend Dependencies if missing
if not exist "%~dp0backend\node_modules" (
    echo [Setup] Installing Backend dependencies...
    cd /d "%~dp0backend"
    call npm install
)

:: Check & Install Frontend Dependencies if missing
if not exist "%~dp0frontend\node_modules" (
    echo [Setup] Installing Frontend dependencies...
    cd /d "%~dp0frontend"
    call npm install
)

echo Starting Backend Server (Port 4000)...
start "TGDrive Pro Backend" cmd /k "cd /d "%~dp0backend" && npm run dev"

echo Starting Frontend Dev Server (Port 5173)...
start "TGDrive Pro Frontend" cmd /k "cd /d "%~dp0frontend" && npm run dev"

echo.
echo Waiting 4 seconds for servers to initialize...
timeout /t 4 /nobreak >nul

echo Opening TGDrive Pro in your web browser...
start http://localhost:5173

echo ===================================================
echo  TGDrive Pro is now running!
echo  Backend:  http://localhost:4000
echo  Frontend: http://localhost:5173
echo ===================================================
