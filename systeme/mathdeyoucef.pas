unit MathDeYoucef;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, gl, glut;

type
  TVector2DV = Record
    x, y: Single;
  end;

  TVector3DV = Record
    x, y, z: Single;
  end;

  TVector2D = Record
    x, y: LongInt;
  end;

  TVector3D = Record
    x, y, z: LongInt;
  end;

  TVector4D = Record
    x, y, z, alpha: Double;
  end;

  TVector4DV = Record
    x, y, z, alpha: Double;
  end;

  TArrayVector4DV = array[1..200000] of TVector4DV;
  TArrayVector3DV = array[1..200000] of TVector3DV;
  TArrayVector2DV = array[1..200000] of TVector2DV;

  TTArrayVector4DV = array[1..200000] of TArrayVector4DV;
  TTArrayVector3DV = array[1..200000] of TArrayVector3DV;
  TTArrayVector2DV = array[1..200000] of TArrayVector2DV;

  mat4 = array[1..4,1..4] of LongInt;

  TLongInt = array[1..2000] of LongInt;

  TTLongInt = array[1..20000] of TLongInt;

  TFloat = array[1..2000] of Double;

  TTFloat = array[1..20000] of TFloat;

  TStringArray = array[1..10000] of String;

  TTStringArray = array[1..10000] of TStringArray;

  TColor = array[1..3] of Double;

function Split(mot: String; motaseparer: String): TStringArray;
function Lireligne(mot: String; motvoulant: String; Position: Integer = 1): Boolean;
function ContainsString(mot: String; motvoulant: String): Boolean;
function Search(mot: String; motvoulant: String; positiondebutmot: Integer = 1): Integer;
procedure LireEntreCrochetDebut(ligne: String);
procedure LireEntreCrochetFin(ligne: String);
procedure LireEntreAccoladeDebut(ligne: String);
procedure LireEntreAccoladeFin(ligne: String);
function Transform2Den3D(x, y: LongInt): TVector3D;
function Transform3Den2D(x, y, z: LongInt): TVector2D;
function TransformDouble2Den3D(x, y: Double): TVector3DV;
function TransformDouble3Den2D(x, y, z: Double): TVector2DV;
function IsNotNull(nombre: LongInt): Boolean;
function IsNotNull(nombre: Double): Boolean;
function transformationVecteur3DrotationZ(vecteur: TVector3DV; alpha: double): TVector3DV;
function Multiply(nombre: array of LongInt; Vector: TVector4DV): TVector4DV;
procedure glWrite(X, Y: GLfloat; Font: Pointer; Text: String);
function IsEmpty(mot: String): Boolean;
function Empty(mot: String): String;
function NbLigne(mot: TStringArray): Integer;
function TransformglRasPos2DtoglVector2D(X, Y: Integer): TVector2DV;
function PosCursor(ligne: String): LongInt;

implementation

{ TTransform2Den3D }

function Split(mot: String; motaseparer: String): TStringArray;
var
  i, j,
    k, nblettre: Integer;
  IsSeparate: Boolean;
  vartemp, vartemp2: String;
begin
  nblettre := 1;
  for i := 1 to 100 do begin
    vartemp2 := '';
    IsSeparate := False;
    for j := nblettre to Length(mot) do begin
      if not IsSeparate then begin
        if nblettre < Length(mot) then nblettre += 1;
        vartemp := mot[j];
        if Lireligne(vartemp, motaseparer) then IsSeparate := True else begin
          vartemp2 += String(mot[j]);
          Result[i] := vartemp2;
        end;
        if (IsSeparate = False) and (j = Length(mot)) then begin
          Result[i] := vartemp2;
          for k := i + 1 to 100 do Result[k] := '';
          Exit;
        end;
      end;
    end;
  end;
end;

function Lireligne(mot: String; motvoulant: String; Position: Integer): Boolean;
var
  i: Integer;
begin
  for i := 1 to High(motVoulant) do begin
    if mot[position] = motvoulant[i] then Result := True;
    if mot[position] <> motvoulant[i] then begin
      Result := False;
      Exit;
    end;
    position += 1;
  end;
end;

function ContainsString(mot: String; motvoulant: String): Boolean;
begin
  if mot.Contains(motvoulant) then Result := True else Result := False;
end;

function Search(mot: String; motvoulant: String;
  positiondebutmot: Integer): Integer;
var
  i: Integer;
begin
  if mot.Contains(motvoulant) then begin
    for i := 0 to Length(mot) do begin
      if mot[i] = motvoulant[positiondebutmot] then begin
        Result := i;
        Exit;
      end else Result := -2;
    end;
  end else begin
    Result := -1;
  end;
end;

procedure LireEntreCrochetDebut(ligne: String);
var
  position, position2, i: Integer;
  IsNotInTheLigne: Boolean;
begin
  position := Search(ligne, '[', 1);
  position2 := Search(ligne, ']', 1);
  if position = -1 then Exit;
  if position2 = -1 then IsNotInTheLigne := True else IsNotInTheLigne := False;
  if IsNotInTheLigne then begin
    for i := position + 1 to Length(ligne) do Write(ligne[i]);
  end else begin
    for i := position + 1 to position2 - 1 do Write(ligne[i]);
    WriteLn;
  end;
end;

procedure LireEntreCrochetFin(ligne: String);
var
  position2, i: Integer;
  IsNotInTheLigne: Boolean;
begin
  position2 := Search(ligne, ']', 1);
  if position2 = -1 then IsNotInTheLigne := True else IsNotInTheLigne := False;
  if IsNotInTheLigne then begin
    for i := 0 to Length(ligne) do Write(ligne[i]);
  end else begin
    for i := 0 to position2 - 1 do Write(ligne[i]);
    WriteLn;
  end;
end;

procedure LireEntreAccoladeDebut(ligne: String);
var
  position, position2, i: Integer;
  IsNotInTheLigne: Boolean;
begin
  position := Search(ligne, '{', 1);
  position2 := Search(ligne, '}', 1);
  if position = -1 then Exit;
  if position2 = -1 then IsNotInTheLigne := True else IsNotInTheLigne := False;
  if IsNotInTheLigne then begin
    for i := position + 1 to Length(ligne) do Write(ligne[i]);
  end else begin
    for i := position + 1 to position2 - 1 do Write(ligne[i]);
    WriteLn;
  end;
end;

procedure LireEntreAccoladeFin(ligne: String);
var
  position2, i: Integer;
  IsNotInTheLigne: Boolean;
begin
  position2 := Search(ligne, '}', 1);
  if position2 = -1 then IsNotInTheLigne := True else IsNotInTheLigne := False;
  if IsNotInTheLigne then begin
    for i := 0 to Length(ligne) do Write(ligne[i]);
  end else begin
    for i := 0 to position2 - 1 do Write(ligne[i]);
  end;
  WriteLn;
end;

function Transform2Den3D(x, y: LongInt): TVector3D;
begin
    Result.x := x;
    Result.y := y;
    Result.z := x div y;
end;

function Transform3Den2D(x, y, z: LongInt): TVector2D;
begin
  Result.x := x;
  Result.y := y;
  z := 0;
end;

function TransformDouble2Den3D(x, y: Double): TVector3DV;
begin
    Result.x := x;
    Result.y := y;
    Result.z := x / y;
end;

function TransformDouble3Den2D(x, y, z: Double): TVector2DV;
begin
  Result.x := x;
  Result.y := y;
  z := 0;
end;

function IsNotNull(nombre: LongInt): Boolean;
begin
  Result := nombre <> 0;
end;

function IsNotNull(nombre: Double): Boolean;
begin
  Result := nombre <> 0;
end;

type
  TVector = array[1..3] of double;
  TMatrix = array[1..3, 1..3] of double;

operator *(M: TMatrix; X: TVector) Y: TVector;
var
  i, j: Integer;
begin
  for i := 1 to 3 do begin
    Y[i] := 0;
    for j := 1 to 3 do begin
      Y[i] += M[i, j] * X[j];
    end;
  end;
end;

operator :=(X: TVector) Y: TVector3DV;
begin
  Y.X := X[1];
  Y.Y := X[2];
  Y.Z := X[3];
end;

operator :=(X: TVector3DV) Y: TVector;
begin
  Y[1] := X.X;
  Y[2] := X.Y;
  Y[3] := X.Z;
end;

operator := (X: array of const) Y: TVector;
var
  i: Integer;
begin
  for i := 1 to 3 do begin
    Y[i] := X[i].VExtended^;
  end;
end;

operator := (X: array of double) Y: TMatrix;
var
  i, j: Integer;
begin
  for i := 1 to 3 do begin
    for j := 1 to 3 do begin
      WriteLn('i = ', i, ', j = ', j, ', V = ', X[(i - 1) * 3 + j - 1]);
      Y[i, j] := X[(i - 1) * 3 + j - 1];
    end;
  end;
end;

function transformationVecteur3DrotationZ(vecteur: TVector3DV; alpha: double): TVector3DV;
var
  M: TMatrix;
  X: TVector;
begin
  M := [cos(alpha), -sin(alpha), 0,
        sin(alpha), cos(alpha), 0,
        0, 0, 1];
  with vecteur do WriteLn(X, Y, Z);
  X := vecteur;
  Result := M * vecteur;
  with Result do WriteLn(X, Y, Z);
end;

function Multiply(nombre: array of LongInt; Vector: TVector4DV): TVector4DV;
var
  i, y: LongInt;
begin
  i := nombre[1];
  for y := 2 to 4 do i += nombre[y];
  Result.x := i * Vector.x;
  Result.y := i * Vector.y;
  Result.z := i * Vector.z;
  Result.alpha := i * Vector.alpha;
end;

procedure glWrite(X, Y: GLfloat; Font: Pointer; Text: String);
var
  I: Integer;
begin
  glRasterPos2f(X, Y);
  for I := 1 to Length(Text) do
    glutBitmapCharacter(Font, Integer(Text[I]));
end;

function IsEmpty(mot: String): Boolean;
begin
  if mot.IsEmpty then Result := True else Result := False;
end;

function Empty(mot: String): String;
var
  i: Integer;
begin
  for i := 0 to High(mot) do begin
   if i = Length(mot) then begin
     Delete(mot, i, 1);
     Result := mot;
     Exit;
   end;
  end;
end;

function NbLigne(mot: TStringArray): Integer;
var
  i: Integer;
begin
  for i := 1 to Length(mot) do begin
    if mot[i + 1] = '' then begin
      Result := i;
      Exit;
    end;
  end;
end;

function TransformglRasPos2DtoglVector2D(X, Y: Integer): TVector2DV;
var
  Resultat: TVector2DV;
begin
  Resultat.x := X;
  Resultat.y := Y;
  Result := Resultat;
end;

function PosCursor(ligne: String): LongInt;
var
  i: LongInt;
  acc: LongInt = 0;
begin
  for i := Low(ligne) to High(ligne) do begin
    if ligne[i] = 'a' then acc += 9;
    if ligne[i] = 'b' then acc += 20;
    if ligne[i] = 'c' then acc += 20;
    if ligne[i] = 'd' then acc += 20;
    if ligne[i] = 'e' then acc += 20;
    if ligne[i] = 'f' then acc += 10;
    if ligne[i] = 'g' then acc += 20;
    if ligne[i] = 'h' then acc += 20;
    if ligne[i] = 'i' then acc += 20;
    if ligne[i] = 'j' then acc += 20;
    if ligne[i] = 'k' then acc += 20;
    if ligne[i] = 'l' then acc += 10;
    if ligne[i] = 'm' then acc += 30;
    if ligne[i] = 'n' then acc += 20;
    if ligne[i] = 'o' then acc += 20;
    if ligne[i] = 'p' then acc += 20;
    if ligne[i] = 'q' then acc += 20;
    if ligne[i] = 'r' then acc += 20;
    if ligne[i] = 's' then acc += 20;
    if ligne[i] = 't' then acc += 10;
    if ligne[i] = 'u' then acc += 20;

    if ligne[i] = 'w' then acc += 30;
    if ligne[i] = 'x' then acc += 20;
    if ligne[i] = 'y' then acc += 20;
    if ligne[i] = 'z' then acc += 20;
  end;
  Result := acc;
end;

end.

