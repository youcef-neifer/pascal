{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit Mypackage;

{$warn 5023 off : no warning about unused units}
interface

uses
  Unit2, Unit1, DrawRect, Event, MathDeYoucef, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('Unit2', @Unit2.Register);
end;

initialization
  RegisterPackage('Mypackage', @Register);
end.
