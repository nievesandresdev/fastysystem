@echo off
title FastySystem - Preparar para Instalador
color 0C

echo ========================================
echo    PREPARANDO PARA CREAR INSTALADOR
echo ========================================
echo.
echo Este script cerrara todos los procesos relacionados
echo y preparara el proyecto para crear el instalador.
echo.

REM Cerrar procesos de Node.js relacionados con FastySystem
echo Cerrando procesos de Node.js...
taskkill /F /IM node.exe /T >nul 2>&1
timeout /t 2 /nobreak >nul

REM Cerrar procesos de Electron
echo Cerrando procesos de Electron...
taskkill /F /IM electron.exe /T >nul 2>&1
timeout /t 2 /nobreak >nul

REM Cerrar ventanas de consola relacionadas
echo Cerrando ventanas relacionadas...
taskkill /F /FI "WINDOWTITLE eq FastySystem*" /T >nul 2>&1

echo.
echo [OK] Procesos cerrados
echo.
echo Ahora puedes ejecutar: scripts\crear-instalador.bat
echo.
pause

