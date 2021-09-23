unit Load3DObject;

{$mode objfpc}{$H+}

interface

uses
  cthreads, Sysutils, Classes, MathDeYoucef, Unit1, gl, glu;

const
  DiffuseLight: array[0..3] of GLfloat = (0.2, 0.4, 0.8, 0.1);

type
  TList = (
  LIST_SKY,
  LIST_LIQUIDE,
  LIST_OBJECT);

var
  normal_out, vertice_out: TArrayVector3DV;
  coordonneTexture_out: TArrayVector2DV;
  contientNormal, estdefinie: Boolean;
  NomCompletFichier: String;
  Repertoire: String;


procedure FaireTriangleOpenGl(nbvertice, nbnormal,
  nbtexture, nbvertice2, nbnormal2, nbtexture2, nbvertice3, nbnormal3, nbtexture3: Integer);
procedure Init;
procedure GetNameFile;
function LoadObject3DFile(NomFichier: String): GLenum;
procedure Destroy3DObject(List: LongWord; rang: Integer);
implementation

procedure FaireTriangleOpenGl(nbvertice, nbnormal,
  nbtexture, nbvertice2, nbnormal2, nbtexture2, nbvertice3, nbnormal3, nbtexture3: Integer);
begin
    glEnable(GL_COLOR_MATERIAL);
    glColorMaterial(GL_FRONT, GL_AMBIENT_AND_DIFFUSE);
      glBegin(GL_TRIANGLES);
        glVertex3f(vertice_out[nbvertice].x, vertice_out[nbvertice].y, (vertice_out[nbvertice].z - 5));
        glNormal3f(normal_out[nbnormal].x, normal_out[nbnormal].y, normal_out[nbnormal].z);
        glTexCoord2f(coordonneTexture_out[nbtexture].x, coordonneTexture_out[nbtexture].y);
        glVertex3f(vertice_out[nbvertice2].x, vertice_out[nbvertice2].y, (vertice_out[nbvertice2].z - 5));
        glNormal3f(normal_out[nbnormal2].x, normal_out[nbnormal2].y, normal_out[nbnormal2].z);
        glTexCoord2f(coordonneTexture_out[nbtexture2].x, coordonneTexture_out[nbtexture2].y);
        glVertex3f(vertice_out[nbvertice3].x, vertice_out[nbvertice3].y, (vertice_out[nbvertice3].z - 5));
        glNormal3f(normal_out[nbnormal3].x, normal_out[nbnormal3].y, normal_out[nbnormal3].z);
        glTexCoord2f(coordonneTexture_out[nbtexture3].x, coordonneTexture_out[nbtexture3].y);
        contientNormal := True;
      glEnd;
end;

procedure Init;
begin
  {Récupérer le nom du programme}
  Repertoire := ParamStr(0);
  {Extraire le répertoire du programme}
  while Repertoire[length(Repertoire)] <> DirectorySeparator do begin
    Delete(Repertoire, Length(Repertoire), 1);
  end;
  {Changer le répertoire courant pour être dans le répertoire du programme}
  ChDir(Repertoire);
end;

procedure GetNameFile;
begin
    WriteLn(NomCompletFichier);
end;

function LoadObject3DFile(NomFichier: String): GLuint;
var
  line: TStringArray;
  Fichier: Text;
  buf: String;
  coord, coord2, coord3: TStringArray;
  compteurtexture, compteurnormal, compteurvertex, compteurface: Integer;
begin
  compteurtexture := 0;
  compteurnormal := 0;
  compteurvertex := 0;
  compteurface := 0;
  estdefinie := False;
  contientNormal := False;
  NomCompletFichier := NomFichier + '.obj';
  Init;
  Assign(Fichier, NomCompletFichier);
  {$IOChecks off}Reset(Fichier);{$IOChecks on}
  if IOResult <> 0 then begin
    WriteLn('Error: the File not found or inexist');
    Exit;
  end;
  glNewList(Ord(List_Object), GL_COMPILE);
    while not EOF(Fichier) do begin
      ReadLn(Fichier, buf);
      line := Split(buf, ' ');
      if Lireligne(buf, 'v ') then begin
        compteurvertex += 1;
        vertice_out[compteurvertex].x := StrToFloat(line[2]);
        vertice_out[compteurvertex].y := StrToFloat(line[3]);
        vertice_out[compteurvertex].z := StrToFloat(line[4]);
      end;
      if Lireligne(buf, 'vt ') then begin
        compteurtexture += 1;
        coordonneTexture_out[compteurtexture].x := StrToFloat(line[2]);
        coordonneTexture_out[compteurtexture].y := StrToFloat(line[3]);
      end;
      if Lireligne(buf, 'vn ') then begin
        compteurnormal += 1;
        normal_out[compteurnormal].x := StrToFloat(line[2]);
        normal_out[compteurnormal].y := StrToFloat(line[3]);
        normal_out[compteurnormal].z := StrToFloat(line[4]);
      end;
      if Lireligne(buf, 'f ') then begin
        compteurface += 1;
        coord := Split(line[2], '/');
        coord2 := Split(line[3], '/');
        coord3 := Split(line[4], '/');
        FaireTriangleOpenGl(StrToInt(coord[1]), StrToInt(coord[2]), StrToInt(coord[3]), StrToInt(coord2[1]), StrToInt(coord2[2]), StrToInt(coord2[3]), StrToInt(coord3[1]), StrToInt(coord3[2]), StrToInt(coord3[3]));
      end;
    end;
    glEndList;
    estdefinie := True;
    Close(Fichier);
    Result := Ord(LIST_OBJECT);
end;

procedure Destroy3DObject(List: LongWord; rang: Integer);
begin
    glDeleteLists(List, rang);
end;

end.

