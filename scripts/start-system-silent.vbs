Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' Obtener la ruta del script (raíz del proyecto)
scriptPath = fso.GetParentFolderName(WScript.ScriptFullName)
appPath = fso.GetParentFolderName(scriptPath)

' Crear carpeta de logs si no existe
logsPath = appPath & "\logs"
If Not fso.FolderExists(logsPath) Then
    fso.CreateFolder(logsPath)
End If

' ============================================
' PASO 0: MATAR PROCESOS ANTERIORES (evitar conflictos)
' ============================================
' Crear script temporal para matar procesos que usan los puertos
Dim killScript
killScript = logsPath & "\kill-processes.bat"
Set killFile = fso.CreateTextFile(killScript, True)
killFile.WriteLine "@echo off"
killFile.WriteLine "REM Matar procesos node.exe y electron.exe"
killFile.WriteLine "taskkill /F /IM node.exe >nul 2>&1"
killFile.WriteLine "taskkill /F /IM electron.exe >nul 2>&1"
killFile.WriteLine "REM Matar procesos que usan el puerto 3000"
killFile.WriteLine "for /f ""tokens=5"" %%a in ('netstat -aon ^| findstr "":3000""') do taskkill /F /PID %%a >nul 2>&1"
killFile.WriteLine "REM Matar procesos que usan el puerto 5000"
killFile.WriteLine "for /f ""tokens=5"" %%a in ('netstat -aon ^| findstr "":5000""') do taskkill /F /PID %%a >nul 2>&1"
killFile.Close

' Ejecutar script de limpieza completamente oculto
On Error Resume Next
WshShell.Run "cmd /c start """" /B """ & killScript & """", 0, True
On Error Goto 0

' Esperar un momento para que los procesos se cierren
WScript.Sleep 1500

' ============================================
' PASO 1: ABRIR ELECTRON INMEDIATAMENTE (SIN TERMINAL)
' ============================================
electronPath = appPath & "\electron"

' Verificar que electron está compilado (rápido, sin esperar)
If Not fso.FileExists(electronPath & "\dist\main.js") Then
    ' Compilar en segundo plano sin bloquear (completamente oculto)
    WshShell.Run "cmd /c cd /d """ & electronPath & """ && npm run build > """ & logsPath & "\electron-build.log 2>&1", 0, False
End If

' Abrir Electron INMEDIATAMENTE (ventana oculta para el proceso, solo se verá la ventana de Electron)
' Crear script .bat temporal para asegurar el directorio correcto
Dim electronBat
electronBat = logsPath & "\start-electron-temp.bat"
Set batFile = fso.CreateTextFile(electronBat, True)
batFile.WriteLine "@echo off"
batFile.WriteLine "cd /d """ & electronPath & """"
If fso.FileExists(electronPath & "\scripts\start-electron.js") Then
    batFile.WriteLine "node scripts\start-electron.js"
Else
    batFile.WriteLine "npm start"
End If
batFile.Close
' Ejecutar el script .bat completamente oculto
WshShell.Run "cmd /c start """" /B """ & electronBat & """", 0, False

' ============================================
' PASO 2: INICIAR BACKEND Y FRONTEND EN PARALELO
' ============================================
backendPath = appPath & "\backend"
frontendPath = appPath & "\frontend"

' Iniciar backend en segundo plano (completamente oculto, sin terminal)
' Crear script .bat temporal para asegurar el directorio correcto
Dim backendBat
backendBat = logsPath & "\start-backend-temp.bat"
Set batFile = fso.CreateTextFile(backendBat, True)
batFile.WriteLine "@echo off"
batFile.WriteLine "cd /d """ & backendPath & """"
If fso.FileExists(backendPath & "\scripts\start-backend.js") Then
    batFile.WriteLine "node scripts\start-backend.js >> """ & logsPath & "\backend.log"" 2>&1"
Else
    batFile.WriteLine "npx tsx src\server.ts >> """ & logsPath & "\backend.log"" 2>&1"
End If
batFile.Close
' Ejecutar el script .bat completamente oculto
WshShell.Run "cmd /c start """" /B """ & backendBat & """", 0, False

' Iniciar frontend en segundo plano (completamente oculto, sin terminal)
' Crear script .bat temporal para asegurar el directorio correcto
Dim frontendBat
frontendBat = logsPath & "\start-frontend-temp.bat"
Set batFile = fso.CreateTextFile(frontendBat, True)
batFile.WriteLine "@echo off"
batFile.WriteLine "cd /d """ & frontendPath & """"
If fso.FileExists(frontendPath & "\scripts\start-frontend.js") Then
    batFile.WriteLine "node scripts\start-frontend.js >> """ & logsPath & "\frontend.log"" 2>&1"
Else
    batFile.WriteLine "npx vite preview --port 5000 --host localhost >> """ & logsPath & "\frontend.log"" 2>&1"
End If
batFile.Close
' Ejecutar el script .bat completamente oculto
WshShell.Run "cmd /c start """" /B """ & frontendBat & """", 0, False

' ============================================
' PASO 3: VERIFICAR QUE TODO FUNCIONA (en segundo plano)
' ============================================
' Esperar más tiempo antes de verificar (los servicios necesitan tiempo para iniciar)
WScript.Sleep 12000

' Verificar backend (con múltiples intentos, pero no bloquear)
Set http = CreateObject("MSXML2.XMLHTTP")
Dim backendReady, frontendReady
backendReady = False
frontendReady = False

' Intentar verificar backend (más intentos y más tiempo)
For i = 1 To 20
    On Error Resume Next
    http.Open "GET", "http://localhost:3000/api/license/check", False
    http.SetTimeouts 3000, 3000, 3000, 3000
    http.Send
    ' Aceptar cualquier código de estado 2xx o 3xx como válido
    If Err.Number = 0 And http.Status >= 200 And http.Status < 400 Then
        backendReady = True
        Exit For
    End If
    On Error Goto 0
    WScript.Sleep 1500
Next

' Intentar verificar frontend (más intentos y más tiempo)
For i = 1 To 20
    On Error Resume Next
    http.Open "GET", "http://localhost:5000", False
    http.SetTimeouts 3000, 3000, 3000, 3000
    http.Send
    ' Aceptar cualquier código de estado 2xx o 3xx como válido
    If Err.Number = 0 And http.Status >= 200 And http.Status < 400 Then
        frontendReady = True
        Exit For
    End If
    On Error Goto 0
    WScript.Sleep 1500
Next

' Verificar adicional: si los logs muestran que los servicios están corriendo,
' considerar que están listos aunque la verificación HTTP falle
' (puede ser un problema de timing o de red local)
Dim backendLogExists, frontendLogExists
backendLogExists = fso.FileExists(logsPath & "\backend.log")
frontendLogExists = fso.FileExists(logsPath & "\frontend.log")

' Si los logs existen y tienen contenido, verificar si mencionan que están corriendo
Dim backendRunningInLog, frontendRunningInLog
backendRunningInLog = False
frontendRunningInLog = False

If backendLogExists Then
    Set logFile = fso.OpenTextFile(logsPath & "\backend.log", 1)
    Dim backendLogContent
    backendLogContent = logFile.ReadAll
    logFile.Close
    ' Buscar indicadores de que el backend está corriendo
    If InStr(backendLogContent, "Backend corriendo") > 0 Or InStr(backendLogContent, "Servidor backend iniciado") > 0 Or InStr(backendLogContent, "localhost:3000") > 0 Then
        backendRunningInLog = True
    End If
End If

If frontendLogExists Then
    Set logFile = fso.OpenTextFile(logsPath & "\frontend.log", 1)
    Dim frontendLogContent
    frontendLogContent = logFile.ReadAll
    logFile.Close
    ' Buscar indicadores de que el frontend está corriendo
    If InStr(frontendLogContent, "Local:") > 0 Or InStr(frontendLogContent, "localhost:5000") > 0 Or InStr(frontendLogContent, "Frontend deber") > 0 Then
        frontendRunningInLog = True
    End If
End If

' Si los logs indican que están corriendo, considerar que están listos
If backendRunningInLog Then
    backendReady = True
End If
If frontendRunningInLog Then
    frontendReady = True
End If

' Solo mostrar error si REALMENTE no están funcionando (ni HTTP ni logs)
' Mostrar error solo si ambos servicios fallan completamente
Dim shouldShowError
shouldShowError = False

If Not backendReady And Not backendRunningInLog Then
    shouldShowError = True
End If
If Not frontendReady And Not frontendRunningInLog Then
    shouldShowError = True
End If

' Si hay errores REALES, mostrar una ventana de terminal con los logs
If shouldShowError Then
    ' Crear un script temporal para mostrar los logs
    Dim tempBat
    tempBat = logsPath & "\show-errors.bat"
    Set logFile = fso.CreateTextFile(tempBat, True)
    logFile.WriteLine "@echo off"
    logFile.WriteLine "title FastySystem - Errores de Inicio"
    logFile.WriteLine "color 0C"
    logFile.WriteLine "echo ========================================"
    logFile.WriteLine "echo    FASTY SYSTEM - ERRORES DE INICIO"
    logFile.WriteLine "echo ========================================"
    logFile.WriteLine "echo."
    
    If Not backendReady And Not backendRunningInLog Then
        logFile.WriteLine "echo [ERROR] Backend no responde"
        logFile.WriteLine "echo."
        If fso.FileExists(logsPath & "\backend.log") Then
            logFile.WriteLine "echo Contenido de backend.log:"
            logFile.WriteLine "echo ----------------------------------------"
            logFile.WriteLine "type """ & logsPath & "\backend.log"""
            logFile.WriteLine "echo ----------------------------------------"
        Else
            logFile.WriteLine "echo El archivo backend.log no existe o está vacío"
        End If
        logFile.WriteLine "echo."
    End If
    
    If Not frontendReady And Not frontendRunningInLog Then
        logFile.WriteLine "echo [ERROR] Frontend no responde"
        logFile.WriteLine "echo."
        If fso.FileExists(logsPath & "\frontend.log") Then
            logFile.WriteLine "echo Contenido de frontend.log:"
            logFile.WriteLine "echo ----------------------------------------"
            logFile.WriteLine "type """ & logsPath & "\frontend.log"""
            logFile.WriteLine "echo ----------------------------------------"
        Else
            logFile.WriteLine "echo El archivo frontend.log no existe o está vacío"
        End If
        logFile.WriteLine "echo."
    End If
    
    logFile.WriteLine "echo."
    logFile.WriteLine "echo Los logs completos están en: " & logsPath
    logFile.WriteLine "echo."
    logFile.WriteLine "pause"
    logFile.Close
    
    ' Mostrar la ventana de errores
    WshShell.Run """" & tempBat & """", 1, False
End If

' Salir silenciosamente (Electron ya está abierto)
WScript.Quit
