# 🚀 Inicio Rápido - Crear Instalador

## Opción 1: Automático (Recomendado) ⚡

Ejecuta este comando en PowerShell desde la raíz del proyecto:

```bash
scripts\crear-instalador.bat
```

Este script hará todo automáticamente:
1. ✅ Verifica e instala dependencias
2. ✅ Compila frontend
3. ✅ Compila electron
4. ✅ Crea el instalador

## Opción 2: Manual 📝

### Paso 1: Instalar Dependencias
```bash
scripts\install-all.bat
```

### Paso 2: Compilar
```bash
# Frontend
cd frontend
npm run build
cd ..

# Electron
cd electron
npm run build
cd ..
```

### Paso 3: Crear Instalador
1. Abre Inno Setup
2. File > Open > `installer\FastySystem.iss`
3. Build > Compile (Ctrl+F9)
4. El instalador estará en `installer\dist\FastySystem-Setup.exe`

## 🧪 Probar Antes de Instalar

Para verificar que todo funciona:

```bash
scripts\test-system.bat
```

Luego prueba el sistema:
```bash
scripts\start-system.bat
```

## 📦 Requisitos Previos

- ✅ Node.js 18+ instalado
- ✅ Inno Setup 6+ instalado ([Descargar](https://jrsoftware.org/isinfo.php))

## ⚠️ Si Algo Falla

1. **Inno Setup no encontrado:**
   - Instala Inno Setup desde https://jrsoftware.org/isinfo.php
   - O edita `scripts\crear-instalador.bat` y especifica la ruta manualmente

2. **Error al compilar:**
   - Verifica que todas las dependencias están instaladas: `scripts\install-all.bat`
   - Revisa los mensajes de error en la consola

3. **El instalador no funciona:**
   - Prueba primero localmente: `scripts\start-system.bat`
   - Verifica que los puertos 3000 y 5000 no están ocupados

## 📍 Ubicación del Instalador

Una vez creado, el instalador estará en:
```
installer\dist\FastySystem-Setup.exe
```

¡Listo para distribuir! 🎉

