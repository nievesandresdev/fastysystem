; Script de Inno Setup para FastySystem
; Requiere Inno Setup 6 o superior

#define MyAppName "FastySystem"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "FastySystem"
#define MyAppURL "https://fastysystem.com"
#define MyAppExeName "FastySystem.exe"

[Setup]
; Información básica
AppId={{A1B2C3D4-E5F6-4A5B-8C9D-0E1F2A3B4C5D}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
LicenseFile=
OutputDir=dist
OutputBaseFilename=FastySystem-Setup
SetupIconFile=..\installer\fasty_logo.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=admin
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64

[Languages]
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 6.1

[Files]
; Backend - Excluir archivos innecesarios (NO copiar base de datos de desarrollo)
Source: "..\backend\*"; DestDir: "{app}\backend"; Flags: ignoreversion recursesubdirs createallsubdirs; Excludes: "*.sqlite,*.sqlite-shm,*.sqlite-wal,.env,.env.example,.gitignore,*.log,*.tmp,license.key"
; Frontend - Excluir archivos innecesarios
Source: "..\frontend\*"; DestDir: "{app}\frontend"; Flags: ignoreversion recursesubdirs createallsubdirs; Excludes: ".env,.env.example,.gitignore,*.log,*.tmp"
; Electron - Excluir archivos innecesarios
Source: "..\electron\*"; DestDir: "{app}\electron"; Flags: ignoreversion recursesubdirs createallsubdirs; Excludes: ".env,.env.example,.gitignore,*.log,*.tmp"
; Scripts
Source: "..\scripts\*"; DestDir: "{app}\scripts"; Flags: ignoreversion recursesubdirs createallsubdirs
; Script VBS para inicio silencioso
Source: "..\scripts\start-system-silent.vbs"; DestDir: "{app}\scripts"; Flags: ignoreversion
; Icono para accesos directos
Source: "..\installer\fasty_logo.ico"; DestDir: "{app}\frontend\public\img"; Flags: ignoreversion
; node_modules del backend
Source: "..\backend\node_modules\*"; DestDir: "{app}\backend\node_modules"; Flags: ignoreversion recursesubdirs createallsubdirs; Excludes: "*.md,*.txt,.git,*.log"
; node_modules del frontend
Source: "..\frontend\node_modules\*"; DestDir: "{app}\frontend\node_modules"; Flags: ignoreversion recursesubdirs createallsubdirs; Excludes: "*.md,*.txt,.git,*.log"
; node_modules de electron
Source: "..\electron\node_modules\*"; DestDir: "{app}\electron\node_modules"; Flags: ignoreversion recursesubdirs createallsubdirs; Excludes: "*.md,*.txt,.git,*.log"

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "wscript.exe"; Parameters: """{app}\scripts\start-system-silent.vbs"""; WorkingDir: "{app}"; IconFilename: "{app}\frontend\public\img\fasty_logo.ico"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "wscript.exe"; Parameters: """{app}\scripts\start-system-silent.vbs"""; WorkingDir: "{app}"; IconFilename: "{app}\frontend\public\img\fasty_logo.ico"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "wscript.exe"; Parameters: """{app}\scripts\start-system-silent.vbs"""; WorkingDir: "{app}"; IconFilename: "{app}\frontend\public\img\fasty_logo.ico"; Tasks: quicklaunchicon

[Run]
; Instalar dependencias de Node.js si es necesario
Filename: "{app}\backend\scripts\install-dependencies.bat"; Description: "Instalar dependencias"; Flags: runhidden waituntilterminated
; Crear acceso directo en el escritorio
Filename: "wscript.exe"; Parameters: """{app}\scripts\start-system-silent.vbs"""; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[Code]
var
  NodeJsInstalled: Boolean;

function InitializeSetup(): Boolean;
var
  ErrorCode: Integer;
begin
  // Verificar si Node.js está instalado
  NodeJsInstalled := RegKeyExists(HKEY_LOCAL_MACHINE, 'SOFTWARE\Node.js') or
                     RegKeyExists(HKEY_CURRENT_USER, 'SOFTWARE\Node.js');
  
  if not NodeJsInstalled then
  begin
    if MsgBox('Node.js no está instalado. ¿Desea descargarlo ahora?', mbConfirmation, MB_YESNO) = IDYES then
    begin
      ShellExec('open', 'https://nodejs.org/', '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
    end;
    Result := False;
  end
  else
    Result := True;
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  ResultCode: Integer;
begin
  if CurStep = ssPostInstall then
  begin
    // Verificar si node_modules existe antes de ejecutar npm install
    // Si ya existe (fue copiado por el instalador), no es necesario ejecutar npm install
    // Esto evita requerir internet durante la instalación
    // NOTA: Instalamos todas las dependencias (incluyendo devDependencies) porque tsx es necesario
    if not DirExists(ExpandConstant('{app}\backend\node_modules')) then
    begin
      Exec(ExpandConstant('{sys}\cmd.exe'), '/c cd /d "' + ExpandConstant('{app}\backend') + '" && npm install', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
    end;
    if not DirExists(ExpandConstant('{app}\frontend\node_modules')) then
    begin
      Exec(ExpandConstant('{sys}\cmd.exe'), '/c cd /d "' + ExpandConstant('{app}\frontend') + '" && npm install', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
    end;
    if not DirExists(ExpandConstant('{app}\electron\node_modules')) then
    begin
      Exec(ExpandConstant('{sys}\cmd.exe'), '/c cd /d "' + ExpandConstant('{app}\electron') + '" && npm install', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
    end;
    
    // Ejecutar build del frontend
    Exec(ExpandConstant('{sys}\cmd.exe'), '/c cd /d "' + ExpandConstant('{app}\frontend') + '" && npm run build', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
    
    // Ejecutar build de electron
    Exec(ExpandConstant('{sys}\cmd.exe'), '/c cd /d "' + ExpandConstant('{app}\electron') + '" && npm run build', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
    
    // Crear archivo .env por defecto si no existe
    if not FileExists(ExpandConstant('{app}\backend\.env')) then
    begin
      SaveStringToFile(ExpandConstant('{app}\backend\.env'), 
        '# Configuración del Backend - FastySystem' + #13#10 + #13#10 +
        '# Puerto del servidor backend' + #13#10 +
        'BACKEND_PORT=3000' + #13#10 + #13#10 +
        '# URL del frontend (usado para CORS)' + #13#10 +
        'VITE_UI_URL=http://localhost:5000' + #13#10 + #13#10 +
        '# Contraseña del usuario superadmin (cambiar en producción)' + #13#10 +
        'SUPER_ADMIN_PASSWORD=admin123' + #13#10 + #13#10 +
        '# Clave secreta para firmar licencias (cambiar en producción)' + #13#10 +
        'LICENSE_SECRET_KEY=FASTY_SYSTEM_SECRET_KEY_2024_CHANGE_IN_PRODUCTION' + #13#10,
        False);
    end;
    
    // Inicializar base de datos (migraciones y seeds)
    Exec(ExpandConstant('{sys}\cmd.exe'), '/c cd /d "' + ExpandConstant('{app}\backend') + '" && npm run migrations', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
    Exec(ExpandConstant('{sys}\cmd.exe'), '/c cd /d "' + ExpandConstant('{app}\backend') + '" && npm run seed', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
    
    // Otorgar permisos de escritura a todos los usuarios en la carpeta de instalación
    // Esto es especialmente importante si se instala en Program Files
    Exec(ExpandConstant('{sys}\icacls.exe'), '"' + ExpandConstant('{app}') + '" /grant Users:(OI)(CI)F /T /Q', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
    Exec(ExpandConstant('{sys}\icacls.exe'), '"' + ExpandConstant('{app}') + '" /grant *S-1-5-32-545:(OI)(CI)F /T /Q', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  end;
end;

