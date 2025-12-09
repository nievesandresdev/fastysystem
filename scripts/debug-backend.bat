@echo off
title Debug Backend
color 0E

echo ========================================
echo    DEBUG BACKEND
echo ========================================
echo.

cd /d "%~dp0\..\backend"

echo Verificando directorio...
if not exist "src\server.ts" (
    echo [ERROR] Archivo server.ts no encontrado
    pause
    exit /b 1
) else (
    echo [OK] Archivo server.ts existe
)

echo.
echo Verificando dependencias...
if not exist "node_modules" (
    echo [ERROR] node_modules no existe
    echo Instalando...
    call npm install
) else (
    echo [OK] node_modules existe
)

echo.
echo Verificando tsx...
if not exist "node_modules\.bin\tsx.cmd" (
    echo [ERROR] tsx no encontrado
    echo Instalando tsx...
    call npm install tsx --save-dev
) else (
    echo [OK] tsx encontrado
)

echo.
echo Verificando puerto 3000...
netstat -an | findstr ":3000" >nul
if %errorlevel% equ 0 (
    echo [ADVERTENCIA] Puerto 3000 esta en uso
    echo Cierra el proceso que lo esta usando
    echo.
    netstat -ano | findstr ":3000"
) else (
    echo [OK] Puerto 3000 disponible
)

echo.
echo ========================================
echo    INICIANDO BACKEND MANUALMENTE
echo ========================================
echo.
echo Esto mostrara todos los errores...
echo.

REM Ejecutar migraciones primero
echo Ejecutando migraciones...
call npm run migrations
if %errorlevel% neq 0 (
    echo [ERROR] Migraciones fallaron
    pause
    exit /b 1
)

echo.
echo Iniciando servidor directamente...
echo.
npx tsx src\server.ts

pause

