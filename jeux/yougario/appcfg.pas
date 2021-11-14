unit AppCfg;

{$mode objfpc}{$H+}

interface

const
  ServerName: string = 'yougario.people.sfaxware.com';
  ServerPort: Word = 4100;

var
  progPath, ProgDir, ProgName, LibDir: string;
  UserHomeDir: string;
  CfgPath: string;

implementation

uses
  sysutils;

procedure LoadConfiguration;
var
  CfgFile: Text;
  c: Char;
begin
  {$IFDEF Windows}
    UserHomeDir := GetEnvironmentVariable('USERPROFILE');
  {$ELSE Windows}
    UserHomeDir := GetEnvironmentVariable('HOME');
  {$ENDIF Windows}
  CfgPath := GetEnvironmentVariable('XDG_CONFIG_HOME');
  if CfgPath = '' then begin
    CfgPath := UserHomeDir + '/.config/';
  end;
  CfgPath += ProgName;
  if not DirectoryExists(CfgPath) then begin
    MkDir(CfgPath);
  end;
  CfgPath += '/' + ProgName + '.cfg';
  Assign(CfgFile, CfgPath);
  {$IoChecks Off}Reset(CfgFile);{$IoChecks On}
  if IOResult = 0 then begin
    WriteLn(CfgPath);
    ReadLn(CfgFile, ServerPort, c, ServerName);
    WriteLn(ServerName, ' ', ServerPort);
    Close(CfgFile);
  end;
end;

procedure StoreConfiguration;
var
  CfgFile: Text;
begin
  Assign(CfgFile, CfgPath);
  {$IoChecks Off}Rewrite(CfgFile);{$IoChecks On}
  if IOResult = 0 then begin
    WriteLn(CfgFile, ServerPort, ' ', ServerName);
    Close(CfgFile);
  end;
end;

initialization
  ProgPath := ParamStr(0);
  ProgName := ExtractFileName(progPath);
  ProgDir := ExtractFileDir(ProgPath);
  LibDir := ExtractFileDir(ProgDir);
  ChDir(LibDir);
  LoadConfiguration;

finalization
  StoreConfiguration;
end.

