[Setup]
Uninstallable=no
CreateAppDir=no
AppName="ATV RustDesk"
AppVersion="1.0"
PrivilegesRequired = lowest
DisableReadyMemo = yes
DisableFinishedPage= yes
DisableWelcomePage = yes
Compression = lzma2/ultra64   
OutputBaseFilename="RustDesk for ATV"
SetupIconFile="..\res\icon.ico"
OutputDir="."

[Files]
Source: "..\target\release\RustDesk.exe"; DestDir: {tmp}; 
Source: "..\target\release\sciter.dll"; DestDir: {tmp}; 


[Run]
FileName: "{tmp}\Rustdesk.exe"

[Code]

#ifdef UNICODE
  #define AW "W"
#else
  #define AW "A"
#endif
type
  HINSTANCE = THandle;

function ShellExecute(hwnd: HWND; lpOperation: string; lpFile: string;
  lpParameters: string; lpDirectory: string; nShowCmd: Integer): HINSTANCE;
  external 'ShellExecute{#AW}@shell32.dll stdcall';

function InitializeSetup: Boolean;
begin
  // if this instance of the setup is not silent which is by running
  // setup binary without /SILENT parameter, stop the initialization
  Result := WizardSilent;
  // if this instance is not silent, then...
  if not Result then
  begin
    // re-run the setup with /SILENT parameter; because executing of
    // the setup loader is not possible with ShellExec function, we
    // need to use a WinAPI workaround
    if ShellExecute(0, '', ExpandConstant('{srcexe}'), '/VERYSILENT', '',
      SW_SHOW) <= 32
    then
      // if re-running this setup to silent mode failed, let's allow
      // this non-silent setup to be run
      Result := True;
  end;
end;
