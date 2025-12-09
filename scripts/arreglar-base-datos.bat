@echo off
title Arreglar Base de Datos
color 0E

echo ========================================
echo    ARREGLAR BASE DE DATOS
echo ========================================
echo.
echo Este script limpiara las referencias a migraciones
echo que fueron eliminadas porque no son necesarias.
echo.
echo NOTA: El sistema de licencias usa archivos, no base de datos,
echo por lo que esas migraciones no son necesarias.
echo.

cd /d "%~dp0\..\backend"

if exist "database.sqlite" (
    echo Limpiando referencias a migraciones eliminadas...
    echo.
    echo Usando Node.js para limpiar...
    node scripts\limpiar-migraciones-faltantes.js
    if %errorlevel% neq 0 (
        echo [INFO] Error al limpiar (puede ser normal)
    )
) else (
    echo [INFO] Base de datos no existe, se creara automaticamente
)

echo.
echo [OK] Proceso completado
echo.
echo Ahora puedes ejecutar las migraciones normalmente:
echo   cd backend
echo   npm run migrations
echo.
pause

