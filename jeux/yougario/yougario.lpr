program yougario;

{$mode objfpc}{$H+}

uses
  cthreads, Interfaces, // this includes the LCL widgetset
  Forms, terrain, player
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

