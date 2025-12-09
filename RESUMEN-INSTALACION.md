# Resumen del Sistema de Instalación y Licenciamiento - FastySystem

## ✅ Componentes Creados

### 1. Sistema de Licenciamiento
- **Ubicación:** `backend/src/utils/license.ts`
- **Funcionalidad:**
  - Genera Hardware ID (HWID) único por equipo
  - Genera y verifica licencias con firma HMAC
  - Vincula licencias al HWID del equipo
  - Protege contra copia simple del sistema

### 2. Middleware de Verificación
- **Ubicación:** `backend/src/middleware/license.middleware.ts`
- **Funcionalidad:**
  - Verifica licencia en cada request (excepto rutas públicas)
  - Bloquea acceso si la licencia es inválida o expirada

### 3. Controlador y Rutas de Licencia
- **Controlador:** `backend/src/controllers/license.controller.ts`
- **Rutas:** `backend/src/routes/license.routes.ts`
- **Endpoints:**
  - `GET /api/license/hwid` - Obtiene el HWID del sistema
  - `POST /api/license/activate` - Activa una licencia
  - `GET /api/license/check` - Verifica el estado de la licencia

### 4. Scripts de Inicio
- **Backend:** `backend/scripts/start-backend.js`
  - Ejecuta migraciones
  - Ejecuta seeds
  - Inicia el servidor backend
  
- **Frontend:** `frontend/scripts/start-frontend.js`
  - Construye el frontend si es necesario
  - Inicia el servidor de preview
  
- **Sistema Completo:** `scripts/start-system.bat`
  - Inicia backend, frontend y electron en orden
  - Verifica dependencias
  - Crea ventanas minimizadas

### 5. Scripts de Utilidad
- **Generar Licencia:** `scripts/generate-license.js`
  - Genera licencias para un HWID específico
  - Uso: `node scripts/generate-license.js <HWID> [dias]`
  
- **Obtener HWID:** `scripts/get-hwid.js`
  - Obtiene el HWID del sistema actual
  - Uso: `node scripts/get-hwid.js`

- **Instalar Dependencias:** `scripts/install-all.bat`
  - Instala todas las dependencias necesarias

- **Construir Instalador:** `scripts/build-installer.bat`
  - Compila frontend y electron
  - Crea el instalador con Inno Setup

### 6. Instalador para Windows
- **Archivo:** `installer/FastySystem.iss`
- **Funcionalidad:**
  - Instala todo el sistema automáticamente
  - Instala dependencias de Node.js
  - Compila frontend y electron
  - Crea accesos directos
  - Configura el sistema para iniciar con un clic

## 🔒 Seguridad

### Protección Implementada
1. **Licencia vinculada al HWID:** No se puede copiar a otro equipo
2. **Firma HMAC:** Las licencias están firmadas criptográficamente
3. **Archivo oculto:** El archivo de licencia está oculto y protegido
4. **Verificación en cada request:** El backend verifica la licencia constantemente
5. **Expiración:** Las licencias tienen fecha de expiración

### Cambiar la Clave Secreta
⚠️ **IMPORTANTE:** Cambiar `LICENSE_SECRET_KEY` en producción:
- `backend/src/utils/license.ts` (línea 12)
- `scripts/generate-license.js` (línea 8)

## 📋 Flujo de Instalación

### Para el Desarrollador:
1. Preparar el proyecto:
   ```bash
   # Instalar dependencias
   scripts\install-all.bat
   
   # Compilar frontend y electron
   cd frontend && npm run build
   cd ../electron && npm run build
   ```

2. Crear el instalador:
   ```bash
   scripts\build-installer.bat
   ```

3. Distribuir el instalador al cliente

### Para el Cliente:
1. Ejecutar `FastySystem-Setup.exe`
2. Seguir el asistente de instalación
3. Obtener el HWID del sistema (desde la interfaz o ejecutando `node scripts/get-hwid.js`)
4. Contactar al desarrollador con el HWID
5. Recibir la clave de licencia
6. Activar la licencia en el sistema

## 🚀 Uso del Sistema

### Iniciar el Sistema
- Hacer doble clic en el acceso directo del escritorio
- O ejecutar `scripts\start-system.bat`

### Generar una Licencia (Desarrollador)
```bash
# 1. Obtener HWID del cliente
node scripts/get-hwid.js

# 2. Generar licencia (365 días por defecto)
node scripts/generate-license.js ABC123DEF456... 365

# 3. Enviar la clave de licencia al cliente
```

### Activar Licencia (Cliente)
1. Opción 1: A través de la interfaz del sistema (si está implementado)
2. Opción 2: Copiar manualmente el archivo `license.key` en `backend/license.key`

## 📁 Estructura de Archivos

```
fastySystem/
├── backend/
│   ├── src/
│   │   ├── utils/
│   │   │   └── license.ts          # Sistema de licenciamiento
│   │   ├── middleware/
│   │   │   └── license.middleware.ts
│   │   ├── controllers/
│   │   │   └── license.controller.ts
│   │   └── routes/
│   │       └── license.routes.ts
│   └── scripts/
│       └── start-backend.js
├── frontend/
│   └── scripts/
│       └── start-frontend.js
├── electron/
├── scripts/
│   ├── start-system.bat           # Inicio del sistema completo
│   ├── generate-license.js         # Generar licencias
│   ├── get-hwid.js                 # Obtener HWID
│   ├── install-all.bat             # Instalar dependencias
│   └── build-installer.bat         # Construir instalador
└── installer/
    └── FastySystem.iss              # Script del instalador
```

## ⚠️ Notas Importantes

1. **Node.js requerido:** El cliente debe tener Node.js instalado
2. **Primera ejecución:** Puede tardar mientras se instalan dependencias
3. **Puertos:** Backend (3000), Frontend (5000) - se ajustan automáticamente si están ocupados
4. **Licencia:** El sistema no funcionará sin una licencia válida
5. **HWID único:** Cada equipo tiene un HWID único basado en hardware

## 🔧 Solución de Problemas

### El sistema no inicia
- Verificar Node.js: `node --version`
- Verificar dependencias instaladas
- Revisar logs en las ventanas de consola

### Error de licencia
- Verificar que `backend/license.key` existe
- Verificar que la licencia no ha expirado
- Contactar al desarrollador para nueva licencia

### Puerto ocupado
- El sistema intenta puertos alternativos automáticamente
- Verificar que no hay otros servicios usando los puertos

## 📞 Soporte

Para soporte técnico o generación de licencias, contactar al desarrollador.

