# Instrucciones para Diagnosticar el Backend

## 🔍 Problema Actual
El backend no está respondiendo en el puerto 3000.

## 📋 Pasos para Diagnosticar

### Opción 1: Script Simple (Recomendado)

Desde la raíz del proyecto, ejecuta:
```bash
scripts\probar-backend.bat
```

Este script iniciará el servidor directamente y mostrará todos los errores.

### Opción 2: Desde PowerShell

Si estás en PowerShell, usa `.\` antes del nombre:
```bash
cd backend
.\test-server.bat
```

### Opción 3: Desde CMD (Símbolo del sistema)

Abre CMD (no PowerShell) y ejecuta:
```bash
cd backend
test-server.bat
```

## 🔎 Qué Buscar

Cuando ejecutes el script, deberías ver:

### ✅ Si funciona correctamente:
```
🌐 CORS configurado para: [ 'http://localhost:5000', ... ]
🔧 Puerto Backend: 3000
🔗 URL Frontend: http://localhost:5000
✅ Backend corriendo en http://localhost:3000
✅ API disponible en http://localhost:3000/api
```

### ❌ Si hay errores:
- Errores de importación
- Errores de módulos no encontrados
- Errores de puerto ocupado
- Errores de base de datos

## 📝 Qué Hacer con los Resultados

1. **Si el servidor inicia correctamente:**
   - El problema está en el script de inicio automático
   - Comparte la salida completa

2. **Si hay errores:**
   - Copia TODO el mensaje de error
   - Compártelo para que pueda corregirlo

## 🚀 Probar la Conexión

Una vez que el servidor esté corriendo, abre otra terminal y ejecuta:
```bash
scripts\test-backend.bat
```

Esto verificará que el backend responda correctamente.

