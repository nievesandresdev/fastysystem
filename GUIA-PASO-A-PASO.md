# Guía Paso a Paso - Crear y Probar el Instalador

## 📋 Paso 1: Verificar Requisitos

### 1.1 Verificar Node.js
Abre PowerShell o CMD y ejecuta:
```bash
node --version
npm --version
```

Si no está instalado, descarga desde: https://nodejs.org/

### 1.2 Instalar Inno Setup
1. Descarga Inno Setup desde: https://jrsoftware.org/isinfo.php
2. Instala la versión 6 o superior
3. Acepta la instalación por defecto

## 📦 Paso 2: Preparar el Proyecto

### 2.1 Instalar Dependencias
Abre PowerShell en la raíz del proyecto (`fastySystem`) y ejecuta:

```bash
scripts\install-all.bat
```

O manualmente:
```bash
cd backend && npm install
cd ../frontend && npm install
cd ../electron && npm install
```

### 2.2 Crear Archivos .env (si no existen)

**backend/.env:**
```
BACKEND_PORT=3000
VITE_UI_URL=http://localhost:5000
SUPER_ADMIN_PASSWORD=admin123
LICENSE_SECRET_KEY=FASTY_SYSTEM_SECRET_KEY_2024_CHANGE_IN_PRODUCTION
```

**frontend/.env:**
```
VITE_API_URL_GENERAL=http://localhost:3000/api
VITE_UI_URL=http://localhost:5000
VITE_FRONTEND_PORT=5000
```

**electron/.env:**
```
VITE_UI_URL=http://localhost:5000
```

## 🔨 Paso 3: Compilar el Proyecto

### 3.1 Compilar Frontend
```bash
cd frontend
npm run build
cd ..
```

### 3.2 Compilar Electron
```bash
cd electron
npm run build
cd ..
```

## 🏗️ Paso 4: Crear el Instalador

### Opción A: Automático (Recomendado)
```bash
scripts\build-installer.bat
```

### Opción B: Manual con Inno Setup
1. Abre Inno Setup
2. File > Open
3. Selecciona `installer\FastySystem.iss`
4. Build > Compile (o Ctrl+F9)
5. El instalador se creará en `installer\dist\FastySystem-Setup.exe`

## 🧪 Paso 5: Probar la Instalación

### 5.1 Probar Localmente (Sin Instalador)
Antes de crear el instalador, prueba que todo funciona:

```bash
# Terminal 1 - Backend
cd backend
npm start

# Terminal 2 - Frontend  
cd frontend
npm run preview

# Terminal 3 - Electron
cd electron
npm start
```

O usa el script de inicio:
```bash
scripts\start-system.bat
```

### 5.2 Probar el Instalador
1. Ejecuta `installer\dist\FastySystem-Setup.exe`
2. Sigue el asistente de instalación
3. El sistema se instalará en `C:\Program Files\FastySystem`
4. Busca el acceso directo en el escritorio
5. Haz doble clic para iniciar

## 🔑 Paso 6: Generar y Activar Licencia

### 6.1 Obtener HWID del Sistema
Después de instalar, ejecuta en el equipo:
```bash
cd "C:\Program Files\FastySystem"
node scripts\get-hwid.js
```

### 6.2 Generar Licencia (En tu máquina de desarrollo)
```bash
node scripts\generate-license.js <HWID_DEL_CLIENTE> 365
```

### 6.3 Activar Licencia
Copia la clave generada y guárdala en:
```
C:\Program Files\FastySystem\backend\license.key
```

O activa a través de la API:
```bash
POST http://localhost:3000/api/license/activate
Body: { "licenseKey": "LA_CLAVE_GENERADA" }
```

## ✅ Verificación Final

1. ✅ El instalador se creó correctamente
2. ✅ La instalación se completó sin errores
3. ✅ El sistema inicia con el acceso directo
4. ✅ El backend está corriendo (puerto 3000)
5. ✅ El frontend está corriendo (puerto 5000)
6. ✅ Electron abre la aplicación
7. ✅ La licencia está activada y funciona

## 🐛 Solución de Problemas

### Error: "Inno Setup no encontrado"
- Verifica que Inno Setup está instalado
- El script busca en ubicaciones comunes, si está en otra ubicación, edita `scripts\build-installer.bat`

### Error: "npm install falla"
- Verifica conexión a internet
- Limpia caché: `npm cache clean --force`
- Elimina `node_modules` y vuelve a instalar

### Error: "El sistema no inicia"
- Verifica que Node.js está en el PATH
- Revisa las ventanas de consola que se abren
- Verifica que los puertos 3000 y 5000 no están ocupados

### Error: "Licencia inválida"
- Verifica que el HWID es correcto
- Asegúrate de usar la misma clave secreta en generación y verificación
- Verifica que el archivo `license.key` está en la ubicación correcta

