# Guía de Instalación - FastySystem

## Requisitos del Sistema

- Windows 10 o superior (64-bit)
- Node.js 18 o superior ([Descargar Node.js](https://nodejs.org/))
- Al menos 2GB de RAM disponible
- 500MB de espacio en disco

## Instalación para el Cliente Final

### Opción 1: Instalador Automático (Recomendado)

1. Ejecutar el archivo `FastySystem-Setup.exe`
2. Seguir las instrucciones del asistente de instalación
3. El instalador configurará todo automáticamente
4. Se creará un acceso directo en el escritorio
5. Hacer doble clic en el acceso directo para iniciar el sistema

### Opción 2: Instalación Manual

1. Copiar toda la carpeta `fastySystem` a `C:\Program Files\FastySystem`
2. Ejecutar `scripts\install-all.bat` para instalar dependencias
3. Crear un acceso directo en el escritorio apuntando a `scripts\start-system.bat`

## Activación de Licencia

Después de la instalación, el sistema requiere una licencia válida:

1. Al iniciar el sistema por primera vez, se mostrará el HWID del equipo
2. Contactar al desarrollador con el HWID para obtener la clave de licencia
3. El desarrollador generará una licencia usando el script de generación
4. Activar la licencia a través de la interfaz del sistema o directamente en el backend

## Para el Desarrollador

### Generar una Licencia

1. Obtener el HWID del equipo del cliente:
   ```bash
   node scripts/get-hwid.js
   ```

2. Generar la licencia:
   ```bash
   node scripts/generate-license.js <HWID> [dias]
   ```
   
   Ejemplo:
   ```bash
   node scripts/generate-license.js ABC123DEF456... 365
   ```

3. Enviar la clave de licencia generada al cliente

### Crear el Instalador

1. Instalar Inno Setup desde [https://jrsoftware.org/isinfo.php](https://jrsoftware.org/isinfo.php)
2. Abrir `installer/FastySystem.iss` en Inno Setup
3. Compilar el instalador (Build > Compile)
4. El instalador se generará en `installer/dist/FastySystem-Setup.exe`

### Estructura de Archivos

```
fastySystem/
├── backend/          # Servidor backend
├── frontend/         # Aplicación React
├── electron/         # Aplicación Electron
├── scripts/          # Scripts de inicio y utilidades
│   ├── start-system.bat
│   ├── generate-license.js
│   ├── get-hwid.js
│   └── install-all.bat
└── installer/        # Archivos del instalador
    └── FastySystem.iss
```

## Seguridad

- Las licencias están vinculadas al Hardware ID (HWID) del equipo
- El archivo de licencia está protegido y oculto
- No se puede copiar el sistema a otro equipo sin una nueva licencia
- Cada instalación requiere una licencia única generada para ese HWID específico

## Solución de Problemas

### El sistema no inicia

1. Verificar que Node.js está instalado: `node --version`
2. Verificar que las dependencias están instaladas en cada directorio
3. Revisar los logs en las ventanas de consola que se abren

### Error de licencia

1. Verificar que el archivo `backend/license.key` existe
2. Verificar que la licencia no ha expirado
3. Contactar al desarrollador para generar una nueva licencia

### Puerto ocupado

- El backend intentará usar un puerto alternativo automáticamente
- Verificar que no hay otros servicios usando los puertos 3000 o 5000

## Soporte

Para soporte técnico o generación de licencias, contactar al desarrollador.

