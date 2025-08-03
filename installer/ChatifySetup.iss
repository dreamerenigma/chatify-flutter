#pragma charset("utf-8")

[Setup]
AppName=Chatify
AppVersion=1.2.67+168
DefaultDirName={autopf}\Chatify
DefaultGroupName=Chatify
OutputDir=.
OutputBaseFilename=ChatifySetup
Compression=lzma2
SolidCompression=yes
ArchitecturesInstallIn64BitMode=x64
SetupIconFile=..\windows\runner\resources\app_icon.ico

[Files]
Source: "..\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs createallsubdirs

[Icons]
Name: "{group}\Chatify"; Filename: "{app}\�hatify.exe"
Name: "{group}\Uninstall Chatify"; Filename: "{uninstallexe}"

[Run]
Filename: "{app}\chatify.exe"; Description: "Запустить Chatify"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
Type: filesandordirs; Name: "{app}"
