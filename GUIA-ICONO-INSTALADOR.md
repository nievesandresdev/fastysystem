# Guía: Agregar Icono al Instalador

## ⚠️ Problema
Inno Setup requiere un archivo `.ico` para el icono del instalador, no puede usar PNG directamente.

## ✅ Solución: Convertir PNG a ICO

### Opción 1: Herramienta Online (Más Rápida)
1. Ve a: https://convertio.co/png-ico/
2. Sube el archivo: `frontend\public\img\fasty_logo.png`
3. Descarga el archivo convertido
4. Guárdalo como: `installer\fasty_logo.ico`
5. Descomenta la línea 25 en `installer\FastySystem.iss`:
   ```ini
   SetupIconFile=..\installer\fasty_logo.ico
   ```

### Opción 2: Usando PowerShell (Sin dependencias)
Ejecuta este comando en PowerShell desde la raíz del proyecto:

```powershell
# Crear un ICO simple desde el PNG
Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile("$PWD\frontend\public\img\fasty_logo.png")
$ico = [System.Drawing.Icon]::FromHandle((New-Object System.Drawing.Bitmap($img, 256, 256)).GetHicon())
$stream = [System.IO.File]::Create("$PWD\installer\fasty_logo.ico")
$ico.Save($stream)
$stream.Close()
```

**Nota:** Este método puede no crear un ICO con múltiples tamaños (16x16, 32x32, etc.), pero funcionará.

### Opción 3: Usando IrfanView (Si lo tienes instalado)
1. Abre `fasty_logo.png` en IrfanView
2. Image → Resize/Resample → Ajusta a 256x256
3. File → Save As → Selecciona formato ICO
4. Guarda como `installer\fasty_logo.ico`

## 📝 Después de Crear el ICO

1. Asegúrate de que el archivo esté en: `installer\fasty_logo.ico`
2. Edita `installer\FastySystem.iss` línea 25:
   ```ini
   SetupIconFile=..\installer\fasty_logo.ico
   ```
3. Recompila el instalador:
   ```bash
   scripts\crear-instalador.bat
   ```

## 🎯 Iconos de Accesos Directos

Los iconos de los accesos directos (escritorio, menú inicio) pueden usar PNG, pero Windows los convertirá automáticamente. Si quieres mejor calidad, también puedes usar el ICO para esos:

```ini
IconFilename: "{app}\frontend\public\img\fasty_logo.ico"
```

Pero primero necesitas copiar el ICO a la carpeta del frontend o crear una carpeta de recursos.

