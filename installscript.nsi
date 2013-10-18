; The name of the installer
Name "PlexHTLauncher"

; The file to write
OutFile "InstallPlexHTLauncher.exe"

; The default installation directory
InstallDir $PROGRAMFILES\PlexHTLauncher

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\PlexHTLauncher" "Install_Dir"

; Request application privileges for Windows Vista
RequestExecutionLevel admin

;--------------------------------

; Pages

Page components
Page directory
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles

;--------------------------------

; The stuff to install
Section "PlexHTLauncher"
  SectionIn RO  
  
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  ; Put file there
  File PlexHTLauncher\bin\Release\PlexHTLauncher.exe
  
  ; Write the installation path into the registry
  WriteRegStr HKLM SOFTWARE\PlexHTLauncher "Install_Dir" "$INSTDIR"
  
  ; Write the registry key redirecting ehshell.exe to PlexHTLauncher
  WriteRegStr HKLM "Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\ehshell.exe" "Debugger" '"$INSTDIR\PlexHTLauncher.exe"'
  
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PlexHTLauncher" "DisplayName" "PlexHTLauncher"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PlexHTLauncher" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PlexHTLauncher" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PlexHTLauncher" "NoRepair" 1
  WriteUninstaller "uninstall.exe"
  
SectionEnd

; Optional "Portable Mode" section (can be disabled by the user)
Section /o "Launch PlexHT in Portable Mode"
  File PlexHTLaunchArgs.txt
SectionEnd

;--------------------------------

; Uninstaller

Section "Uninstall"
  
  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\ehshell.exe"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PlexHTLauncher"
  DeleteRegKey HKLM SOFTWARE\PlexHTLauncher

  ; Remove files and uninstaller
  Delete $INSTDIR\PlexHTLauncher.exe
  Delete $INSTDIR\PlexHTLaunchArgs.txt
  Delete $INSTDIR\uninstall.exe

  ; Remove directories used
  RMDir "$INSTDIR"

SectionEnd
