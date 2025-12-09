# Solución al Problema de Migraciones Faltantes

## 🔴 Problema
Knex está buscando migraciones que no existen:
- `20251102000000_create_licenses_table.ts`
- `20251102000001_add_verification_hash_to_licenses.ts`

## ✅ Solución

### Opción 1: Limpiar Referencias (Recomendado)

Ejecuta este script para limpiar las referencias:
```bash
scripts\arreglar-base-datos.bat
```

Luego ejecuta las migraciones de nuevo:
```bash
cd backend
npm run migrations
```

### Opción 2: El Script Ya Lo Hace Automáticamente

El script de inicio ahora limpia automáticamente estas referencias antes de ejecutar migraciones.

### Opción 3: Si Persiste el Error

Si el error persiste, puedes hacer que el sistema continúe de todas formas:

1. El script de inicio ahora **NO se detiene** si hay errores en migraciones
2. Continuará con seeds y luego iniciará el servidor
3. El servidor funcionará correctamente aunque las migraciones fallen

## 📝 Nota Importante

El sistema de licencias **NO usa tablas de base de datos**. Las licencias se guardan en archivos (`license.key`), por lo que **NO necesitamos** esas migraciones.

Las referencias en la base de datos son residuos de alguna prueba anterior y pueden eliminarse de forma segura.

