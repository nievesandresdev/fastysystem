@echo off
title FastySystem - Verificar Sistema
color 0B

echo ========================================
echo    VERIFICANDO ESTADO DEL SISTEMA
echo ========================================
echo.

REM Verificar procesos
echo Verificando procesos activos...
tasklist /FI "IMAGENAME eq node.exe" 2>nul | find /I /N "node.exe">nul
if "%ERRORLEVEL%"=="0" (
    echo [OK] Node.js procesos encontrados
) else (
    echo [INFO] No hay procesos de Node.js corriendo
)

tasklist /FI "IMAGENAME eq electron.exe" 2>nul | find /I /N "electron.exe">nul
if "%ERRORLEVEL%"=="0" (
    echo [OK] Electron proceso encontrado
) else (
    echo [INFO] Electron no esta corriendo
)

echo.
echo Verificando puertos...
netstat -an | findstr ":3000" >nul
if %errorlevel% equ 0 (
    echo [OK] Puerto 3000 (Backend) esta en uso
) else (
    echo [ERROR] Puerto 3000 (Backend) NO esta en uso
)

netstat -an | findstr ":5000" >nul
if %errorlevel% equ 0 (
    echo [OK] Puerto 5000 (Frontend) esta en uso
) else (
    echo [ERROR] Puerto 5000 (Frontend) NO esta en uso
)

echo.
echo ========================================
echo    VERIFICACION COMPLETA
echo ========================================
echo.
pause

