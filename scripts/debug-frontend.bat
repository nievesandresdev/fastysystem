@echo off
title Debug Frontend
color 0E

echo ========================================
echo    DEBUG FRONTEND
echo ========================================
echo.

cd /d "%~dp0\..\frontend"

echo Verificando directorio...
if not exist "dist" (
    echo [ERROR] Directorio dist no existe
    echo Compilando...
    call npm run build
    if %errorlevel% neq 0 (
        echo Error compilando
        pause
        exit /b 1
    )
) else (
    echo [OK] Directorio dist existe
)

echo.
echo Verificando puerto 5000...
netstat -an | findstr ":5000" >nul
if %errorlevel% equ 0 (
    echo [ADVERTENCIA] Puerto 5000 esta en uso
    echo Cierra el proceso que lo esta usando
) else (
    echo [OK] Puerto 5000 disponible
)

echo.
echo Iniciando frontend manualmente...
echo.
npx vite preview --port 5000 --host localhost

pause

