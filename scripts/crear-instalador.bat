@echo off
title FastySystem - Crear Instalador
color 0E

echo ========================================
echo    FASTY SYSTEM - CREAR INSTALADOR
echo ========================================
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

echo [PASO 1/5] Verificando dependencias...
echo.

REM Verificar e instalar dependencias del backend
if not exist "backend\node_modules" (
    echo Instalando dependencias del backend...
    cd backend
    call npm install
    if %errorlevel% neq 0 (
        echo [ERROR] Error instalando dependencias del backend
        pause
        exit /b 1
    )
    cd ..
) else (
    echo [OK] Dependencias del backend ya instaladas
)

REM Verificar e instalar dependencias del frontend
if not exist "frontend\node_modules" (
    echo Instalando dependencias del frontend...
    cd frontend
    call npm install
    if %errorlevel% neq 0 (
        echo [ERROR] Error instalando dependencias del frontend
        pause
        exit /b 1
    )
    cd ..
) else (
    echo [OK] Dependencias del frontend ya instaladas
)

REM Verificar e instalar dependencias de electron
if not exist "electron\node_modules" (
    echo Instalando dependencias de electron...
    cd electron
    call npm install
    if %errorlevel% neq 0 (
        echo [ERROR] Error instalando dependencias de electron
        pause
        exit /b 1
    )
    cd ..
) else (
    echo [OK] Dependencias de electron ya instaladas
)

echo.
echo [PASO 2/5] Compilando frontend...
cd frontend
call npm run build
if %errorlevel% neq 0 (
    echo [ERROR] Error compilando frontend
    pause
    exit /b 1
)
cd ..
echo [OK] Frontend compilado correctamente
echo.

echo [PASO 3/5] Compilando electron...
cd electron
call npm run build
if %errorlevel% neq 0 (
    echo [ERROR] Error compilando electron
    pause
    exit /b 1
)
cd ..
echo [OK] Electron compilado correctamente
echo.

echo [PASO 4/5] Verificando Inno Setup...
REM Buscar Inno Setup en ubicaciones comunes
set INNO_SETUP=
if exist "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" (
    set "INNO_SETUP=C:\Program Files (x86)\Inno Setup 6\ISCC.exe"
    goto :found_inno
)
if exist "C:\Program Files\Inno Setup 6\ISCC.exe" (
    set "INNO_SETUP=C:\Program Files\Inno Setup 6\ISCC.exe"
    goto :found_inno
)
REM Buscar en otras ubicaciones usando dir
for /f "delims=" %%i in ('dir /b /ad "C:\Program Files\Inno Setup*" 2^>nul') do (
    if exist "C:\Program Files\%%i\ISCC.exe" (
        set "INNO_SETUP=C:\Program Files\%%i\ISCC.exe"
        goto :found_inno
    )
)
for /f "delims=" %%i in ('dir /b /ad "C:\Program Files (x86)\Inno Setup*" 2^>nul') do (
    if exist "C:\Program Files (x86)\%%i\ISCC.exe" (
        set "INNO_SETUP=C:\Program Files (x86)\%%i\ISCC.exe"
        goto :found_inno
    )
)

:found_inno
if "%INNO_SETUP%"=="" (
    echo [ERROR] Inno Setup no encontrado.
    echo.
    echo Por favor instala Inno Setup desde:
    echo https://jrsoftware.org/isinfo.php
    echo.
    echo O especifica la ruta manualmente editando este script.
    pause
    exit /b 1
)

echo [OK] Inno Setup encontrado: %INNO_SETUP%
echo.

REM Crear directorio dist si no existe
if not exist "installer\dist" mkdir "installer\dist"

echo [PASO 5/5] Compilando instalador...
echo Esto puede tardar varios minutos...
echo.
"%INNO_SETUP%" "installer\FastySystem.iss"
if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Error compilando instalador
    echo Revisa los mensajes de error arriba
    pause
    exit /b 1
)

echo.
echo ========================================
echo    INSTALADOR CREADO EXITOSAMENTE!
echo ========================================
echo.
echo El instalador se encuentra en:
echo installer\dist\FastySystem-Setup.exe
echo.
echo Siguiente paso: Ejecuta el instalador para probarlo
echo.
pause

