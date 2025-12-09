@echo off
title FastySystem - Construir Instalador
color 0E

echo ========================================
echo    FASTY SYSTEM - CONSTRUIR INSTALADOR
echo ========================================
echo.

cd /d "%~dp0\.."

REM Verificar Inno Setup
set INNO_SETUP="C:\Program Files (x86)\Inno Setup 6\ISCC.exe"
if not exist %INNO_SETUP% (
    set INNO_SETUP="C:\Program Files\Inno Setup 6\ISCC.exe"
)

if not exist %INNO_SETUP% (
    echo Error: Inno Setup no encontrado.
    echo Por favor instala Inno Setup desde https://jrsoftware.org/isinfo.php
    echo.
    echo Buscando en ubicaciones alternativas...
    for %%i in ("C:\Program Files\Inno Setup*" "C:\Program Files (x86)\Inno Setup*") do (
        if exist "%%i\ISCC.exe" (
            set INNO_SETUP="%%i\ISCC.exe"
            goto :found
        )
    )
    pause
    exit /b 1
)

:found
echo Inno Setup encontrado: %INNO_SETUP%
echo.

REM Compilar frontend
echo [1/4] Compilando frontend...
cd frontend
if not exist "node_modules" (
    echo Instalando dependencias del frontend...
    call npm install
)
call npm run build
if %errorlevel% neq 0 (
    echo Error compilando frontend
    pause
    exit /b 1
)
cd ..

REM Compilar electron
echo [2/4] Compilando electron...
cd electron
if not exist "node_modules" (
    echo Instalando dependencias de electron...
    call npm install
)
call npm run build
if %errorlevel% neq 0 (
    echo Error compilando electron
    pause
    exit /b 1
)
cd ..

REM Crear directorio dist si no existe
if not exist "installer\dist" mkdir "installer\dist"

REM Compilar instalador
echo [3/4] Compilando instalador...
%INNO_SETUP% "installer\FastySystem.iss"
if %errorlevel% neq 0 (
    echo Error compilando instalador
    pause
    exit /b 1
)

echo.
echo [4/4] Instalador creado exitosamente!
echo.
echo El instalador se encuentra en: installer\dist\FastySystem-Setup.exe
echo.

pause

