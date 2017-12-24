; Script generated by the Inno Script Studio Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Backstage"
#define MyAppVersion "1.4"
#define MyAppPublisher "Caldas Lopes"
#define MyAppURL "https://github.com/linux-man/backstage"
#define MyAppExeName "backstage.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{0DF7DA6D-8B10-43D0-8F3E-A1A18654A750}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\{#MyAppName}
DefaultGroupName={#MyAppName}
LicenseFile=LICENSE.txt
OutputBaseFilename=setup
SetupIconFile=sketch.ico
Compression=lzma
SolidCompression=yes
ChangesAssociations=yes
;ArchitecturesInstallIn64BitMode=x64

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "backstage.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "data\*"; DestDir: "{app}\data"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "lib\*"; DestDir: "{app}\lib"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "source\*"; DestDir: "{app}\source"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[Registry]
Root: "HKCR"; Subkey: ".stage"; ValueType: string; ValueData: "BackstageProject"; Flags: uninsdeletevalue
Root: "HKCR"; Subkey: "BackstageProject"; ValueType: string; ValueData: "Backstage Project"; Flags: uninsdeletekey
Root: "HKCR"; Subkey: "BackstageProject\DefaultIcon"; ValueType: string; ValueData: "{app}\BACKSTAGE.EXE,0"
Root: "HKCR"; Subkey: "BackstageProject\shell\open\command"; ValueType: string; ValueData: "cmd.exe /K ""cd {app} && BACKSTAGE.EXE"" %1"
Root: "HKLM"; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\backstage.exe"; ValueType: string; ValueName: "Path"; ValueData: "{app}"; Flags: uninsdeletekey
Root: "HKLM"; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\backstage.exe"; ValueType: string; ValueName: ""; ValueData: "{app}\backstage.exe"; Flags: uninsdeletekey

[Dirs]
Name: "{app}\data"
Name: "{app}\lib"
Name: "{app}\source"
