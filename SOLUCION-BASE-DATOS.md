# Solución: Base de Datos Independiente por Instalación

## ✅ Problema Resuelto

Cada instalación del sistema ahora usa su **propia base de datos independiente**, ubicada en:
```
{app}\backend\database.sqlite
```

Donde `{app}` es el directorio de instalación (por defecto: `C:\Program Files\FastySystem`).

## 🔧 Cambios Realizados

### 1. **knexfile.ts** - Rutas Relativas
- ✅ Usa rutas relativas al directorio `backend/` donde está el archivo
- ✅ No depende de `process.cwd()` para evitar conflictos
- ✅ La base de datos siempre se crea en `backend/database.sqlite`

### 2. **license.ts** - Archivo de Licencia
- ✅ El archivo `license.key` se guarda en la raíz del proyecto instalado
- ✅ Cada instalación tiene su propia licencia

### 3. **Instalador (FastySystem.iss)**
- ✅ **NO copia** la base de datos de desarrollo (`*.sqlite`)
- ✅ **NO copia** archivos `.env` de desarrollo
- ✅ **NO copia** archivos `license.key` de desarrollo
- ✅ Crea un nuevo archivo `.env` con valores por defecto
- ✅ Ejecuta migraciones para crear la base de datos nueva
- ✅ Ejecuta seeds para inicializar datos

### 4. **Scripts de Inicio**
- ✅ `start-backend.bat` cambia al directorio `backend/` antes de ejecutar
- ✅ `start-backend.js` cambia el directorio de trabajo con `process.chdir()`
- ✅ Todos los scripts usan rutas relativas

## 📋 Verificación

Cuando ejecutes el sistema instalado, verás en la consola del backend:

```
📊 [db] Configuración de base de datos:
📊 [db] Connection filename: C:\Program Files\FastySystem\backend\database.sqlite
📊 [db] process.cwd(): C:\Program Files\FastySystem\backend
📊 [db] NODE_ENV: production
```

Si ves una ruta diferente (como `C:\Users\andre\proyectos\fastySystem\backend\database.sqlite`), significa que el sistema está usando la base de datos de desarrollo.

## 🚨 Solución si Aún Usa la Base de Datos de Desarrollo

Si después de instalar, el sistema sigue usando la base de datos de desarrollo:

1. **Verifica que el instalador no copió la base de datos:**
   - Busca `database.sqlite` en `{app}\backend\`
   - Si no existe, el sistema la creará automáticamente

2. **Verifica que los scripts cambien al directorio correcto:**
   - Abre la consola del backend cuando se ejecuta
   - Verifica que `process.cwd()` apunte a `{app}\backend`

3. **Verifica variables de entorno:**
   - Asegúrate de que no haya un `.env` en el sistema que apunte a rutas de desarrollo
   - El instalador crea un `.env` nuevo con valores por defecto

4. **Reinstala limpiamente:**
   - Desinstala el sistema
   - Elimina manualmente `{app}\backend\database.sqlite` si existe
   - Reinstala el sistema

## 📝 Notas Importantes

- **Primera Instalación:** La base de datos se crea automáticamente durante la instalación
- **Migraciones:** Se ejecutan automáticamente cada vez que inicias el sistema
- **Seeds:** Solo crean datos si no existen (no duplican)
- **Licencia:** Cada instalación requiere su propia licencia (basada en el HWID de la máquina)

