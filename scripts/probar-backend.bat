@echo off
title Probar Backend
color 0B

echo ========================================
echo    PROBANDO BACKEND
echo ========================================
echo.

cd /d "%~dp0\..\backend"

echo Iniciando servidor backend directamente...
echo Esto mostrara todos los errores si los hay.
echo.
echo Presiona Ctrl+C para detener el servidor
echo.

npx tsx src\server.ts

pause

