# Instalador FastySystem - Guía para el Desarrollador

## Preparación del Instalador

### 1. Instalar Inno Setup

Descargar e instalar Inno Setup desde: https://jrsoftware.org/isinfo.php

### 2. Preparar el Proyecto

Antes de crear el instalador, asegúrate de:

1. **Compilar el frontend:**
   ```bash
   cd frontend
   npm run build
   ```

2. **Compilar electron:**
   ```bash
   cd electron
   npm run build
   ```

3. **Instalar dependencias de producción:**
   ```bash
   # En cada directorio
   npm install --production
   ```

### 3. Crear el Instalador

1. Abrir `installer/FastySystem.iss` en Inno Setup
2. Ir a `Build > Compile` o presionar `Ctrl+F9`
3. El instalador se generará en `installer/dist/FastySystem-Setup.exe`

## Personalización del Instalador

### Cambiar la Versión

Editar la línea en `FastySystem.iss`:
```iss
#define MyAppVersion "1.0.0"
```

### Cambiar el Icono

1. Crear o obtener un archivo `.ico`
2. Editar la línea en `FastySystem.iss`:
```iss
SetupIconFile=path\to\icon.ico
```

### Modificar Rutas de Instalación

Por defecto se instala en `C:\Program Files\FastySystem`. Para cambiar:
```iss
DefaultDirName={autopf}\{#MyAppName}
```

## Proceso de Instalación

El instalador realiza automáticamente:

1. Copia todos los archivos necesarios
2. Instala dependencias de Node.js (npm install)
3. Compila el frontend (npm run build)
4. Compila electron (npm run build)
5. Crea accesos directos en el escritorio y menú inicio
6. Configura el sistema para iniciar con un solo clic

## Generación de Licencias

### Obtener HWID del Cliente

El cliente puede obtener su HWID ejecutando:
```bash
node scripts/get-hwid.js
```

O desde la interfaz del sistema (si está implementado).

### Generar Licencia

```bash
node scripts/generate-license.js <HWID> <dias>
```

Ejemplo:
```bash
node scripts/generate-license.js ABC123DEF456GHI789JKL012MNO345PQ 365
```

### Activar Licencia

El cliente puede activar la licencia:
1. A través de la interfaz del sistema (si está implementado)
2. O manualmente copiando el archivo `license.key` en `backend/license.key`

## Seguridad de la Licencia

- **Clave Secreta:** Cambiar `LICENSE_SECRET_KEY` en producción
- **Ubicación:** `backend/src/utils/license.ts` y `scripts/generate-license.js`
- **Archivo de Licencia:** Se guarda en `backend/license.key` (oculto y protegido)

## Distribución

1. Crear el instalador (`FastySystem-Setup.exe`)
2. Probar la instalación en un equipo limpio
3. Verificar que todo funciona correctamente
4. Distribuir el instalador al cliente
5. Generar y enviar la licencia después de obtener el HWID

## Notas Importantes

- El instalador requiere permisos de administrador
- Node.js debe estar instalado en el equipo del cliente
- La primera ejecución puede tardar más mientras se instalan dependencias
- El sistema verifica la licencia en cada inicio

