@echo off
title Test Backend
color 0B

echo ========================================
echo    PROBANDO BACKEND
echo ========================================
echo.

echo Probando endpoint de licencia...
powershell -Command "try { $response = Invoke-WebRequest -Uri 'http://localhost:3000/api/license/check' -UseBasicParsing -TimeoutSec 5; Write-Host '[OK] Backend respondiendo'; Write-Host 'Status:' $response.StatusCode; Write-Host 'Content:' $response.Content } catch { Write-Host '[ERROR] Backend no responde:'; Write-Host $_.Exception.Message }"

echo.
echo Probando endpoint de login (sin credenciales)...
powershell -Command "try { $body = @{username='test';password='test'} | ConvertTo-Json; $response = Invoke-WebRequest -Uri 'http://localhost:3000/api/auth/login' -Method POST -Body $body -ContentType 'application/json' -UseBasicParsing -TimeoutSec 5; Write-Host '[OK] Endpoint de login accesible'; Write-Host 'Status:' $response.StatusCode } catch { Write-Host '[INFO] Endpoint responde (error esperado sin credenciales):'; Write-Host 'Status:' $_.Exception.Response.StatusCode.value__ }"

echo.
pause

