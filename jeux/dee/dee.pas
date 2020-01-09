program dee;
uses
  ptcGraph, ptcCrt;

function Max(x, y: Byte): Byte;
begin
  if x > y then begin
    Max := x;
  end else begin
    Max := y;
  end;
end;

procedure SetColor(R, G, B: Byte);
const
  MaskR = (1 shl 5) - 1; {5 bits}
  MaskG = (1 shl 6) - 1; {6 bits}
  MaskB = (1 shl 5) - 1; {5 bits}
begin
  R := Max(R, MaskR);
  R := Max(G, MaskG);
  R := Max(B, MaskB);
  ptcGraph.SetColor((R shl 11) + (G shl 5) + B);
end;

const
  PathToDriver = '';
procedure Affiche6;
begin
  SetColor(31, 0, 0);
  Circle(100, 400, 50);
  Circle(400, 400, 50);
  Circle(100, 100, 50);
  Circle(400, 100, 50);
  Circle(100, 250, 50);
  Circle(400, 250, 50);
end;
procedure Affiche5;
begin
SetColor(31, 0, 0);
  Circle(100, 400, 50);
  Circle(400, 400, 50);
  Circle(100, 100, 50);
  Circle(400, 100, 50);
  Circle(250, 250, 50);
end;
procedure Affiche4;
begin
   SetColor(31, 0, 0);
  Circle(100, 400, 50);
  Circle(400, 400, 50);
  Circle(100, 100, 50);
  Circle(400, 100, 50);
end;
procedure Affiche3;
begin
 SetColor(31, 0, 0);
  Circle(300, 100, 50);
  Circle(300, 400, 50);
  Circle(300, 250, 50);
end;
procedure Affiche2;
begin
  SetColor(31, 0, 0);
  Circle(300, 100, 50);
  Circle(300, 400, 50);
end;
procedure Affiche1;
begin
 SetColor(31, 0, 0);
  Circle(300, 250, 50);
end;

var
  GraphDriver: SmallInt;
  GraphMode: SmallInt;
  de: Integer;
begin
  GraphDriver := VESA;
  GraphMode := m640x480x64k;
  InitGraph(GraphDriver, GraphMode, PathToDriver);
  Randomize;
  repeat
    ClearViewPort;
    de := 1 + Random (6);
    case de of
      1: Affiche1;
      2: Affiche2;
      3: Affiche3;
      4: Affiche4;
      5: Affiche5;
      6: Affiche6;
    end;
  until ReadKey = #27;
  CloseGraph;
end.
