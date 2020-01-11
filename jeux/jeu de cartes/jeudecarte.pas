program jeudecarte;
uses
 ptcGraph, ptcCrt, sysutils;

const
  NombreCases = 4;


type
  TCarte = array [1..NombreCases,1..NombreCases] of Integer;

 const
   PathToDriver = '';
   GraphDriver:SmallInt = VESA;
   GraphMode:SmallInt = m640x480x64k;
   TailleCase = 90;

function Min(x, y: Byte): Byte;
begin
 if x < y then begin
   Min := x;
 end else begin
   Min := y;
 end;
end;

function Couleur(R, G, B: Byte): Word;
begin
 R := Min(R, (1 shl 5) - 1);
 G := Min(G, (1 shl 6) - 1);
 B := Min(B, (1 shl 5) - 1);
 Couleur := (R shl 11) + (G shl 5) + B;
end;

procedure AfficheCarte(carte: TCarte);
var
  i, j: Integer;
  x1, y1, x2, y2: Integer;
  Numero: string;
  a:Integer;
  b:Integer;
  c: Integer;
begin
  Randomize;
  a := Random(100);
  b := Random(100);
  c := Random(100);
 for i := 1 to NombreCases do begin
  for j := 1 to NombreCases do begin
    x1 := j * TailleCase;
    y1 := i * TailleCase;
    x2 := x1 + TailleCase;
    y2 := y1 + TailleCase;
    Bar(x1 + 2, y1 + 2, x2 - 2, y2 - 2);
    Str((i - 1) * NombreCases + j, Numero);
    SetColor(Couleur(12, 14, 12));
    OutTextXY(x2 - 20, y2 - 10, Numero);
    if Carte[i,j] > 0 then begin
      Str(Carte[i, j], Numero);
      SetColor(Couleur(12, 14, 12));
      OutTextXy((x1 + x2) div 2, (y1 + y2) div 2, Numero);
    end;
  end;
 end;
end;
var
i, j: Integer;
Carte: TCarte;
a, b, c: Integer;
Chaine: string;
superchaine: string;
hyperchaine: string;
megachaine: string;
t: TDateTime;
t0: TDateTime;
TempEcoule: Integer;
TempEcoulePrecedent: Integer;
Key:Char;
AfficheEncore: Boolean;
begin
  InitGraph(GraphDriver, GraphMode, PathToDriver);
  t0 := Now;
  for i := 1 to NombreCases do begin
    for j := 1 to NombreCases do begin
      Carte[i, j] := -Random(1000);
    end;
  end;
  repeat
    ClearViewPort;
    AfficheCarte(Carte);
    AfficheEncore := False;
    for i := 1 to NombreCases do begin
      for j := 1 to NombreCases do begin
        if Carte[i, j] > 0 then begin
          Carte[i, j] := -Carte[i, j];
          AfficheEncore := True;
        end;
      end;
    end;
    if AfficheEncore then begin
      Sleep(1000);
      AfficheCarte(Carte);
    end;
    SetTextStyle(DefaultFont, HorizDir, 1);
    repeat
     t := Now;
     TempEcoule := Round(24 * 3600 * (t - t0));
     if TempEcoule <> TempEcoulePrecedent then begin
       Bar(300, 0, 600, 20);
       Str(TempEcoule, Chaine);
       Chaine := DateTimeToStr(t) + ' Votre temps ' + Chaine + 's';
       OutTextXY(300, 10, Chaine);
       TempEcoulePrecedent := TempEcoule;
     end;
     Sleep(1);
    until KeyPressed;
    Key := ReadKey;
    if (Key >= '1') and (Key <= '9') then begin
      i := (Ord(Key) - Ord('1')) div NombreCases + 1;
      j := (Ord(Key) - Ord('1')) mod NombreCases + 1;
      Carte[i, j] := -Carte[i, j];
    end;
    if (Key >= 'A' ) and (Key <= 'G' ) then begin
      i := (Ord(Key) - Ord('A') + 9) div NombreCases + 1;
      j := (Ord(Key) - Ord('A') + 9) mod NombreCases + 1;
      Carte[i, j] := -Carte[i, j];
    end;
  until Key = #27;
  CloseGraph;
end.
