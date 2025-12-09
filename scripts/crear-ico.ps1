# Script para convertir PNG a ICO usando PowerShell
# Sin dependencias externas

$inputFile = Join-Path $PSScriptRoot "..\frontend\public\img\fasty_logo.png"
$outputFile = Join-Path $PSScriptRoot "..\installer\fasty_logo.ico"

Write-Host "Convirtiendo PNG a ICO..." -ForegroundColor Green
Write-Host "Entrada: $inputFile" -ForegroundColor Cyan
Write-Host "Salida: $outputFile" -ForegroundColor Cyan

if (-not (Test-Path $inputFile)) {
    Write-Host "Error: No se encuentra el archivo PNG" -ForegroundColor Red
    exit 1
}

# Crear directorio si no existe
$outputDir = Split-Path -Parent $outputFile
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

try {
    Add-Type -AssemblyName System.Drawing
    
    # Cargar la imagen
    $img = [System.Drawing.Image]::FromFile($inputFile)
    
    # Crear bitmap redimensionado a 256x256 (tamaño estándar para ICO)
    $bitmap = New-Object System.Drawing.Bitmap($img, 256, 256)
    
    # Obtener handle del icono
    $iconHandle = $bitmap.GetHicon()
    $icon = [System.Drawing.Icon]::FromHandle($iconHandle)
    
    # Guardar como ICO
    $stream = [System.IO.File]::Create($outputFile)
    $icon.Save($stream)
    $stream.Close()
    
    # Liberar recursos
    $icon.Dispose()
    $bitmap.Dispose()
    $img.Dispose()
    
    Write-Host "✅ ICO creado exitosamente: $outputFile" -ForegroundColor Green
    Write-Host "Ahora puedes descomentar SetupIconFile en FastySystem.iss" -ForegroundColor Yellow
    
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Solución alternativa: Usa https://convertio.co/png-ico/" -ForegroundColor Yellow
    exit 1
}

