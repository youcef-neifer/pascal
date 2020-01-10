program Labirinthe;

uses
 ptcGraph, ptcCrt, ptc, sysutils;

const
  NombreCases = 20;
  NombreCartes = 9;

type
  TCarte = array [1..NombreCases,1..NombreCases] of Byte;

 const
   PathToDriver = '';
   GraphDriver:SmallInt = VESA;
   GraphMode:SmallInt = m640x480x64k;
   TailleCase = 23;

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

procedure ChangeCouleur(R, G, B: Byte);
begin
 SetColor(Couleur(R, G, B));
end;

procedure AfficheCarte(carte: TCarte);
var
  i, j: Integer;
  x1, y1, x2, y2: Integer;

begin
 for i := 1 to NombreCases do begin
  for j := 1 to NombreCases do begin
   if Carte[i,j] > 0 then begin
    x1 := j * TailleCase;
    y1 := i * TailleCase;
    x2 := x1 + TailleCase;
    y2 := y1 + TailleCase;
    Bar(x1, y1, x2, y2);
   end;
  end;
 end;
end;

procedure LitCarte(out Carte: TCarte; var Fichier: Text);
var
  i, j: Integer;
begin
  for i := 1 to NombreCases do begin
    for j := 1 to NombreCases do begin
      Read(Fichier, Carte[i, j]);
    end;
    ReadLn(Fichier);
  end;
end;

procedure Niveau(n: Integer);
var
  Key: Char;
  X, Y: Integer;
  i, j: Integer;
  Carte: TCarte;
  Compteur: Integer;
  Chaine: string;
  NumCarte: string;
  NomCarte: string;
  Fichier: Text;
  t: TDateTime;
  t0: TDateTime;
  TempEcoule: Integer;
  TempEcoulePrecedent: Integer;
begin
  Str(n, NumCarte);
  NomCarte := 'cartes/carte' + NumCarte + '.txt';
  Assign(Fichier, NomCarte);
  {$IOChecks off}Reset(Fichier);{$IOChecks on}
  if IOResult <> 0 then begin
    Exit;
  end;
  LitCarte(Carte, Fichier);
  Close(Fichier);
  SetColor(GetMaxColor);
  i := 1;
  j := 1;
  compteur:= 0;
  Str(Compteur, Chaine);
  t0 := Now;
  TempEcoulePrecedent := 0;
  repeat
   ClearViewPort;
   SetTextStyle(DefaultFont, HorizDir, 2);
   OutTextXY(500, 25, 'Niveau ' + NumCarte);
   SetTextStyle(DefaultFont, HorizDir, 1);
   OutTextXY(500, 50, 'Nombre de pas ' + Chaine);
   AfficheCarte(carte);
   X := j * TailleCase + TailleCase div 2;
   Y := i * TailleCase + TailleCase div 2;
   Circle(X, Y, 10);
   if (i = NombreCases) and (j = NombreCases) then begin
      Break;
   end;
   SetFillStyle(EmptyFill, Couleur(0, 0, 0));
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
   SetFillStyle(SolidFill, Couleur(127, 127, 127));
   Key := ReadKey;
   if Key = #0 then begin
     Key := ReadKey;
     compteur := compteur + 1;
     Str(Compteur, Chaine);
     case Key of
     #75: begin
      if (j > 1) and (Carte[i, j - 1] = 0) then begin
        j := j - 1;
      end;
     end;
     #77: begin
      if (j < NombreCases) and (Carte[i, j + 1] = 0) then begin
        j := j + 1;
      end;
     end;
     #72: begin
      if (i > 1) and (Carte[i - 1, j] = 0) then begin
        i := i - 1;
      end;
     end;
     #80: begin
      if (i < NombreCases) and (Carte[i + 1, j] = 0) then begin
        i := i + 1;
      end;
     end;
    end;
   end;
  until Key = #27;
  ChangeCouleur(127, 0, 0);
  Circle(200, 200, 150);
  ChangeCouleur(0, 127, 0);
  SetTextStyle(DefaultFont, HorizDir, 10);
  OutText('Bravo');
  ReadKey;
end;

var
  n: Integer;
  Repertoire: string;

begin
  {Récupérer le nom du programme}
  Repertoire := ParamStr(0);
  {Extraire le répertoire du programme}
  while Repertoire[length(Repertoire)] <> DirectorySeparator do begin
    Delete(Repertoire, Length(Repertoire), 1);
  end;
  {Changer le répertoire courant pour être dans le répertoire du programme}
  ChDir(Repertoire);
  {Afficher la fenêtre graphique}
  InitGraph(GraphDriver, GraphMode, PathToDriver);
  {Pour chaque niveau lancer le jeux}
  for n := 1 to NombreCartes do begin
    Niveau(n);
  end;
  {Attendre que l'utilisateur appuie sur la touche Esc}
  while (ReadKey <> #27) do begin
  end;
  {Fermer la fenêtre graphique}
  CloseGraph;
  {Quitter le programme}
end.
