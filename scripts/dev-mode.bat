@echo off
title FastySystem - Modo Desarrollo
color 0A

echo ========================================
echo    FASTYSYSTEM - MODO DESARROLLO
echo ========================================
echo.
echo Este script iniciara:
echo   - Backend en modo desarrollo (puerto 3000)
echo   - Frontend en modo desarrollo (puerto 5273)
echo   - Electron apuntando al puerto de desarrollo
echo.
echo Presiona Ctrl+C para detener todos los servicios
echo.
pause

cd /d "%~dp0\.."

REM Verificar Node.js
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Node.js no esta instalado
    pause
    exit /b 1
)

REM Verificar dependencias del backend
if not exist "backend\node_modules" (
    echo [INFO] Instalando dependencias del backend...
    cd backend
    call npm install
    cd ..
)

REM Verificar dependencias del frontend
if not exist "frontend\node_modules" (
    echo [INFO] Instalando dependencias del frontend...
    cd frontend
    call npm install
    cd ..
)

REM Verificar dependencias de electron
if not exist "electron\node_modules" (
    echo [INFO] Instalando dependencias de electron...
    cd electron
    call npm install
    cd ..
)

REM Compilar electron si es necesario
if not exist "electron\dist\main.js" (
    echo [INFO] Compilando Electron...
    cd electron
    call npm run build
    cd ..
)

echo.
echo ========================================
echo    INICIANDO SERVICIOS
echo ========================================
echo.

REM Iniciar backend en una nueva ventana
echo [1/3] Iniciando Backend (puerto 3000)...
start "FastySystem Backend" cmd /k "cd /d %~dp0\..\backend && set NODE_ENV=development && npx tsx src\server.ts"

REM Esperar un poco para que el backend inicie
timeout /t 3 /nobreak >nul

REM Iniciar frontend en una nueva ventana
echo [2/3] Iniciando Frontend (puerto 5273)...
start "FastySystem Frontend" cmd /k "cd /d %~dp0\..\frontend && set NODE_ENV=development && npm run dev"

REM Esperar un poco para que el frontend inicie
timeout /t 5 /nobreak >nul

REM Iniciar electron en una nueva ventana (apuntando al puerto de desarrollo)
echo [3/3] Iniciando Electron...
echo.
echo NOTA: Electron necesita ser configurado para apuntar al puerto 5273
echo       Temporalmente modifica electron/src/main.ts:
echo       const FRONTEND_URL = 'http://localhost:5273';
echo.
start "FastySystem Electron" cmd /k "cd /d %~dp0\..\electron && npm start"

echo.
echo ========================================
echo    SERVICIOS INICIADOS
echo ========================================
echo.
echo Backend:  http://localhost:3000
echo Frontend: http://localhost:5273
echo Electron: Se abrira automaticamente
echo.
echo Para detener los servicios, cierra las ventanas o presiona Ctrl+C
echo.
pause

