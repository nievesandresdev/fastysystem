# Inicialización de la Base de Datos

## ✅ ¿La base de datos se inicializa automáticamente?

**SÍ**, la base de datos se inicializa automáticamente de dos formas:

### 1. Durante la Instalación
Cuando ejecutas el instalador (`FastySystem-Setup.exe`), automáticamente:
- ✅ Crea el archivo `.env` con valores por defecto
- ✅ Ejecuta las migraciones (crea todas las tablas)
- ✅ Ejecuta los seeds (crea datos iniciales: roles, usuarios, unidades de medida, monedas)

### 2. Al Iniciar el Sistema
Cada vez que ejecutas `start-system.bat`, el script de inicio del backend:
- ✅ Verifica si la base de datos existe
- ✅ Ejecuta las migraciones pendientes (si hay nuevas)
- ✅ Ejecuta los seeds (solo crea lo que no existe)

## 📋 Qué se crea automáticamente

### Roles
- `admin` - Administrador del sistema
- `facturador` - Usuario que puede facturar
- Otros roles que definas en `01_roles_default.ts`

### Usuario Super Admin
- **Username:** `superadmin`
- **Password:** Valor de `SUPER_ADMIN_PASSWORD` en `.env` (por defecto: `admin123`)
- **Email:** `superadmin@email.com`
- **Roles:** `admin` y `facturador`

### Unidades de Medida
Definidas en `03_measurement_units.ts`

### Monedas
Definidas en `04_create_default_coins.ts`

## 🔧 Configuración

### Archivo .env
El instalador crea automáticamente `backend/.env` con:
```
BACKEND_PORT=3000
VITE_UI_URL=http://localhost:5000
SUPER_ADMIN_PASSWORD=admin123
LICENSE_SECRET_KEY=FASTY_SYSTEM_SECRET_KEY_2024_CHANGE_IN_PRODUCTION
```

### Cambiar la Contraseña del Super Admin
Edita `backend/.env` y cambia `SUPER_ADMIN_PASSWORD`. Luego reinicia el sistema.

## ⚠️ Notas Importantes

1. **Primera Ejecución:** La base de datos se crea la primera vez que se ejecuta el backend
2. **Migraciones:** Se ejecutan automáticamente cada vez que inicias el sistema
3. **Seeds:** Solo crean datos si no existen (no duplican)
4. **Base de Datos:** Se guarda en `backend/database.sqlite`

## 🐛 Solución de Problemas

### La base de datos no se crea
1. Verifica que el archivo `.env` existe en `backend/`
2. Verifica que las dependencias están instaladas: `cd backend && npm install`
3. Ejecuta manualmente: `cd backend && npm run migrations && npm run seed`

### Error al ejecutar migraciones
1. Verifica que TypeScript está instalado: `npm install -g typescript`
2. Verifica que tsx está instalado en node_modules
3. Revisa los logs en la consola del backend

### Resetear la base de datos
1. Elimina `backend/database.sqlite`
2. Reinicia el sistema
3. La base de datos se recreará automáticamente

