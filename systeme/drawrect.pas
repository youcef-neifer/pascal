unit DrawRect;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, glut, glu, gl, GLext;

procedure Point(x, y: Double);
procedure LineHorizental(x, y: Double; longueur: Double);
procedure LineVertical(x, y: Double; longueur: Double);
procedure DrawRectangle(posX, posY: Double; longueur1, longueur2: Double);
implementation

var
  positionx, positiony: Double;

procedure Point(x, y: Double);
begin
  glBegin($0000);
  glVertex3f(x, y, -1.41421);
  glEnd;
end;

procedure LineHorizental(x, y: Double; longueur: Double);
var
  i: Integer;
begin
  i := 0;
  repeat
    Point(x, y);
    x += 0.0005;
    i += 1;
  until i = longueur;
  positionx:= x;
end;

procedure LineVertical(x, y: Double; longueur: Double);
var
  i: Integer;
begin
  i := 0;
  repeat
    Point(x, y);
    y -= 0.0005;
    i += 1;
  until i = longueur;
  positiony := y;
end;

procedure DrawRectangle(posX, posY: Double; longueur1, longueur2: Double);
var
  i, x2, y2: Double;
begin
  i := 1;
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
  glEnable(GL_TEXTURE_2D);
  repeat
    if i = 1 then LineVertical(posX, posY, longueur1) else begin
      x2 := positionx;
      y2 := posY;
      LineVertical(x2, y2, longueur1);
    end;
    if i = 1 then LineHorizental(posX, posY, longueur2) else begin
      x2 := posX;
      y2 := positiony;
      LineHorizental(x2, y2, longueur2);
    end;
    i += 1;
  until i = 3;
  glFlush;
  glDisable(GL_TEXTURE_2D);
end;

end.

