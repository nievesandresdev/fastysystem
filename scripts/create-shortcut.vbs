Set oWS = WScript.CreateObject("WScript.Shell")
sLinkFile = oWS.SpecialFolders("Desktop") & "\FastySystem.lnk"
Set oLink = oWS.CreateShortcut(sLinkFile)
oLink.TargetPath = WScript.Arguments(0) & "\scripts\start-system.bat"
oLink.WorkingDirectory = WScript.Arguments(0)
oLink.Description = "FastySystem - Sistema de Gestion"
oLink.IconLocation = "shell32.dll,13"
oLink.Save

