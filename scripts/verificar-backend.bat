@echo off
title Verificar Backend
color 0B

echo ========================================
echo    VERIFICANDO BACKEND
echo ========================================
echo.

echo Verificando si el backend esta corriendo...
echo.

powershell -Command "try { $response = Invoke-WebRequest -Uri 'http://localhost:3000/api/license/check' -UseBasicParsing -TimeoutSec 2; Write-Host '[OK] Backend esta respondiendo'; Write-Host 'Status:' $response.StatusCode; Write-Host 'Content:'; $response.Content } catch { Write-Host '[ERROR] Backend NO esta respondiendo'; Write-Host 'Error:' $_.Exception.Message; Write-Host ''; Write-Host 'Verifica:'; Write-Host '1. Que la ventana \"FastySystem Backend\" este abierta'; Write-Host '2. Que no haya errores en esa ventana'; Write-Host '3. Que el puerto 3000 no este ocupado' }"

echo.
echo Verificando procesos de Node.js...
tasklist /FI "IMAGENAME eq node.exe" 2>nul | find /I "node.exe" >nul
if %errorlevel% equ 0 (
    echo [INFO] Hay procesos de Node.js corriendo
    tasklist /FI "IMAGENAME eq node.exe" | findstr "node.exe"
) else (
    echo [ADVERTENCIA] No hay procesos de Node.js corriendo
)

echo.
pause

