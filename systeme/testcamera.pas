unit TestCamera;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, MathDeYoucef, gl, glu, glut;

type

  { TMouse }


  { TCamera }

  TCamera = class
    position: TVector2DV;
    MoveMouse: record
      IsInMoveMouse: Boolean;
      Left: Boolean;
      Rigth: Boolean;
      Top: Boolean;
      Bottom: Boolean;
      Distance: Double;
    end;
    constructor Create(Width, Height: Double);
    procedure Move;
  end;

var
  cs: TRTLCriticalSection;
implementation

uses
  Unit2;

{ TCamera }

constructor TCamera.Create(Width, Height: Double);
begin
  position.x := Width / 2;
  position.y := Height / 2;
end;

procedure TCamera.Move;
begin
  if MoveMouse.IsInMoveMouse then begin
   if MoveMouse.Left then begin
     haut := 70;
     position.x -= MoveMouse.Distance;
     alpha += position.x / 12;
     MoveMouse.Left := False;
     Exit;
   end;
   if MoveMouse.Rigth then begin
     haut := 70;
     position.x += MoveMouse.Distance;
     alpha -= position.x / 12;
     MoveMouse.Rigth := False;
     Exit;
   end;
   if MoveMouse.Top then begin
     milieu := 70;
     position.y += MoveMouse.Distance;
     beta -= position.y / 12;
     MoveMouse.Top := False;
     Exit;
   end;
   if MoveMouse.Bottom then begin
     milieu := 70;
     position.y -= MoveMouse.Distance;
     beta += position.y / 12;
     MoveMouse.Bottom := False;
     Exit;
   end;
  end;
end;

end.

