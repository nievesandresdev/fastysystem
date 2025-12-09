# Solución al Problema de Login

## Problemas Comunes

### 1. Backend no está corriendo
**Síntoma:** Error de conexión o timeout al intentar login

**Solución:**
- Verifica que la ventana "FastySystem Backend" esté abierta
- Revisa los logs del backend para ver errores
- Verifica que el puerto 3000 esté disponible

### 2. URL de API incorrecta
**Síntoma:** Error 404 o "Network Error"

**Solución:**
- Verifica que `VITE_API_URL_GENERAL` esté configurado en `frontend/.env`
- Debe ser: `VITE_API_URL_GENERAL=http://localhost:3000/api`
- Recompila el frontend después de cambiar: `cd frontend && npm run build`

### 3. CORS bloqueando las peticiones
**Síntoma:** Error de CORS en la consola del navegador

**Solución:**
- Verifica que `VITE_UI_URL` esté configurado en `backend/.env`
- Debe ser: `VITE_UI_URL=http://localhost:5000`
- Reinicia el backend después de cambiar

### 4. Licencia no activada
**Síntoma:** Error 403 "Licencia inválida"

**Solución:**
- El login debería funcionar sin licencia (está en rutas públicas)
- Pero otras rutas requieren licencia
- Activa la licencia después del login

## Verificación Rápida

Ejecuta este script para verificar todo:
```bash
scripts\verificar-conexion.bat
```

## Verificar Manualmente

1. **Backend:**
   ```bash
   # Abre en navegador o usa curl
   http://localhost:3000/api/license/check
   ```

2. **Frontend:**
   ```bash
   # Abre en navegador
   http://localhost:5000
   ```

3. **Login:**
   - Usuario: `superadmin`
   - Password: `admin123` (o el valor de `SUPER_ADMIN_PASSWORD` en `.env`)

## Debug en la Consola del Navegador

Abre las herramientas de desarrollador (F12) y revisa:
- **Console:** Busca errores de red o JavaScript
- **Network:** Verifica que las peticiones a `/api/auth/login` se estén haciendo
- **Response:** Revisa la respuesta del servidor

