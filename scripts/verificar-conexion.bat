@echo off
title Verificar Conexion Backend-Frontend
color 0B

echo ========================================
echo    VERIFICANDO CONEXION
echo ========================================
echo.

echo Verificando Backend (puerto 3000)...
powershell -Command "try { $response = Invoke-WebRequest -Uri 'http://localhost:3000/api/license/check' -UseBasicParsing -TimeoutSec 2; Write-Host '[OK] Backend esta respondiendo en http://localhost:3000'; Write-Host $response.Content } catch { Write-Host '[ERROR] Backend NO esta respondiendo en http://localhost:3000'; Write-Host 'Verifica:'; Write-Host '- Que el backend este corriendo'; Write-Host '- Que no haya errores en la ventana del backend'; Write-Host '- Que el puerto 3000 no este ocupado' }"

echo.
echo Verificando Frontend (puerto 5000)...
powershell -Command "try { $response = Invoke-WebRequest -Uri 'http://localhost:5000' -UseBasicParsing -TimeoutSec 2; Write-Host '[OK] Frontend esta respondiendo en http://localhost:5000' } catch { Write-Host '[ERROR] Frontend NO esta respondiendo en http://localhost:5000' }"

echo.
echo Verificando proceso del Backend...
tasklist /FI "WINDOWTITLE eq FastySystem Backend*" 2>nul | find /I "cmd.exe" >nul
if %errorlevel% equ 0 (
    echo [OK] Proceso del Backend encontrado
) else (
    echo [ADVERTENCIA] Proceso del Backend no encontrado
)

echo.
echo Verificando proceso del Frontend...
tasklist /FI "WINDOWTITLE eq FastySystem Frontend*" 2>nul | find /I "cmd.exe" >nul
if %errorlevel% equ 0 (
    echo [OK] Proceso del Frontend encontrado
) else (
    echo [ADVERTENCIA] Proceso del Frontend no encontrado
)

echo.
echo ========================================
echo    VERIFICACION COMPLETA
echo ========================================
echo.
echo Si hay errores, revisa las ventanas minimizadas
echo del Backend y Frontend para ver los logs.
echo.
pause

