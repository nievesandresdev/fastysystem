@echo off
title FastySystem - Prueba del Sistema
color 0B

echo ========================================
echo    FASTY SYSTEM - PRUEBA DEL SISTEMA
echo ========================================
echo.
echo Este script probara que todo funciona antes de crear el instalador
echo.

cd /d "%~dp0\.."

REM Verificar Node.js
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Node.js no esta instalado.
    echo Por favor instala Node.js desde https://nodejs.org/
    pause
    exit /b 1
)

echo [OK] Node.js encontrado
echo.

REM Verificar dependencias
echo Verificando dependencias...
if not exist "backend\node_modules" (
    echo [ADVERTENCIA] Dependencias del backend no instaladas
    echo Ejecutando instalacion...
    cd backend
    call npm install
    cd ..
)

if not exist "frontend\node_modules" (
    echo [ADVERTENCIA] Dependencias del frontend no instaladas
    echo Ejecutando instalacion...
    cd frontend
    call npm install
    cd ..
)

if not exist "electron\node_modules" (
    echo [ADVERTENCIA] Dependencias de electron no instaladas
    echo Ejecutando instalacion...
    cd electron
    call npm install
    cd ..
)

echo [OK] Dependencias verificadas
echo.

REM Verificar compilacion
echo Verificando compilaciones...
if not exist "frontend\dist" (
    echo [INFO] Compilando frontend...
    cd frontend
    call npm run build
    if %errorlevel% neq 0 (
        echo [ERROR] Error compilando frontend
        pause
        exit /b 1
    )
    cd ..
)

if not exist "electron\dist\main.js" (
    echo [INFO] Compilando electron...
    cd electron
    call npm run build
    if %errorlevel% neq 0 (
        echo [ERROR] Error compilando electron
        pause
        exit /b 1
    )
    cd ..
)

echo [OK] Compilaciones verificadas
echo.

echo ========================================
echo    TODO LISTO PARA PROBAR
echo ========================================
echo.
echo El sistema esta listo. Ahora puedes:
echo.
echo 1. Probar localmente: scripts\start-system.bat
echo 2. Crear el instalador: scripts\build-installer.bat
echo.
pause

