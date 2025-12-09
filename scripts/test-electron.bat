@echo off
title FastySystem - Probar Electron
color 0B

echo ========================================
echo    PROBANDO ELECTRON
echo ========================================
echo.

cd /d "%~dp0\..\electron"

REM Verificar que está compilado
if not exist "dist\main.js" (
    echo Compilando electron...
    call npm run build
    if %errorlevel% neq 0 (
        echo Error compilando electron
        pause
        exit /b 1
    )
)

REM Verificar dependencias
if not exist "node_modules" (
    echo Instalando dependencias...
    call npm install
    if %errorlevel% neq 0 (
        echo Error instalando dependencias
        pause
        exit /b 1
    )
)

REM Iniciar electron
echo Iniciando Electron...
if exist "scripts\start-electron.js" (
    node scripts/start-electron.js
) else (
    npm start
)

pause

