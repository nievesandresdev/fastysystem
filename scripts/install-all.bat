@echo off
title FastySystem - Instalacion de Dependencias
color 0B

echo ========================================
echo    FASTY SYSTEM - INSTALACION
echo ========================================
echo.

cd /d "%~dp0\.."

REM Verificar Node.js
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo Error: Node.js no esta instalado.
    echo Por favor instala Node.js desde https://nodejs.org/
    pause
    exit /b 1
)

echo [1/3] Instalando dependencias del Backend...
cd backend
call npm install
if %errorlevel% neq 0 (
    echo Error instalando dependencias del backend
    pause
    exit /b 1
)
cd ..

echo [2/3] Instalando dependencias del Frontend...
cd frontend
call npm install
if %errorlevel% neq 0 (
    echo Error instalando dependencias del frontend
    pause
    exit /b 1
)
cd ..

echo [3/3] Instalando dependencias de Electron...
cd electron
call npm install
if %errorlevel% neq 0 (
    echo Error instalando dependencias de electron
    pause
    exit /b 1
)
cd ..

echo.
echo ========================================
echo    Instalacion completada
echo ========================================
echo.
pause

