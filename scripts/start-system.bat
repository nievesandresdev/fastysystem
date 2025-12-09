@echo off
REM Script completamente silencioso - no mostrar ventanas
REM Solo se mostrará una ventana si hay errores

cd /d "%~dp0\.."

REM Verificar si estamos en una ubicación con problemas de permisos
echo %cd% | findstr /i "Program Files" >nul
if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo    ADVERTENCIA: PROBLEMA DE PERMISOS
    echo ========================================
    echo.
    echo La aplicacion esta instalada en Program Files.
    echo Esto puede causar problemas al escribir en la base de datos.
    echo.
    echo Se recomienda reinstalar en:
    echo %LOCALAPPDATA%\Programs\FastySystem
    echo.
    echo Continuando de todas formas...
    echo.
    timeout /t 3 /nobreak >nul
)

REM Verificar que estamos en el directorio correcto
if not exist "backend" (
    echo Error: No se encuentra el directorio backend
    pause
    exit /b 1
)

if not exist "frontend" (
    echo Error: No se encuentra el directorio frontend
    pause
    exit /b 1
)

if not exist "electron" (
    echo Error: No se encuentra el directorio electron
    pause
    exit /b 1
)

REM Verificar Node.js
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo Error: Node.js no esta instalado.
    echo Por favor instala Node.js desde https://nodejs.org/
    pause
    exit /b 1
)

REM Verificar que las dependencias estan instaladas
if not exist "backend\node_modules" (
    echo Advertencia: Dependencias del backend no encontradas.
    echo Ejecutando instalacion...
    cd backend
    call npm install --production
    cd ..
)

if not exist "frontend\node_modules" (
    echo Advertencia: Dependencias del frontend no encontradas.
    echo Ejecutando instalacion...
    cd frontend
    call npm install --production
    cd ..
)

if not exist "electron\node_modules" (
    echo Advertencia: Dependencias de electron no encontradas.
    echo Ejecutando instalacion...
    cd electron
    call npm install --production
    cd ..
)

REM Crear carpeta de logs si no existe
if not exist "logs" mkdir logs

REM Crear carpeta de logs si no existe
if not exist "logs" mkdir logs

REM Iniciar backend en segundo plano (SIN ventana visible)
cd backend
if exist "scripts\start-backend.js" (
    start "" /B cmd /c "node scripts\start-backend.js > ..\logs\backend.log 2>&1"
) else (
    start "" /B cmd /c "npx tsx src\server.ts > ..\logs\backend.log 2>&1"
)
cd ..

REM Esperar un poco para que el backend inicie
timeout /t 5 /nobreak >nul

REM Iniciar frontend en segundo plano (SIN ventana visible)
cd frontend
if exist "scripts\start-frontend.js" (
    start "" /B cmd /c "node scripts\start-frontend.js > ..\logs\frontend.log 2>&1"
) else (
    start "" /B cmd /c "npx vite preview --port 5000 --host localhost > ..\logs\frontend.log 2>&1"
)
cd ..

REM Esperar un poco para que el frontend inicie
timeout /t 5 /nobreak >nul

REM Verificar que el frontend está respondiendo
curl -s http://localhost:5000 >nul 2>&1
if %errorlevel% neq 0 (
    timeout /t 5 /nobreak >nul
)

REM Verificar que electron está compilado
if not exist "electron\dist\main.js" (
    cd electron
    call npm run build > ..\logs\electron-build.log 2>&1
    cd ..
)

REM Iniciar electron en segundo plano (SIN ventana visible, solo la ventana de la app)
cd electron
if exist "scripts\start-electron.js" (
    start "" /B cmd /c "node scripts\start-electron.js > ..\logs\electron.log 2>&1"
) else (
    start "" /B cmd /c "npm start > ..\logs\electron.log 2>&1"
)
cd ..

REM Esperar un momento y verificar que todo está funcionando
timeout /t 8 /nobreak >nul

REM Verificar backend
curl -s http://localhost:3000/api/license/check >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ========================================
    echo    ERROR: Backend no responde
    echo ========================================
    echo Revisa logs\backend.log para ver el error
    echo.
    type logs\backend.log
    echo.
    pause
    exit /b 1
)

REM Verificar frontend
curl -s http://localhost:5000 >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ========================================
    echo    ERROR: Frontend no responde
    echo ========================================
    echo Revisa logs\frontend.log para ver el error
    echo.
    type logs\frontend.log
    echo.
    pause
    exit /b 1
)

REM Si todo está bien, cerrar esta ventana sin mostrar nada
exit

