unit MathDeYoucef;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

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

  TArrayVector3DV = array[1..200000] of TVector3DV;
  TArrayVector2DV = array[1..200000] of TVector2DV;

  TTArrayVector3DV = array[1..200000] of TArrayVector3DV;
  TTArrayVector2DV = array[1..200000] of TArrayVector2DV;

  TLongInt = array[1..200000] of LongInt;

  TStringArray = array[1..100] of String;

function Split(mot: String; motaseparer: String): TStringArray;
function Lireligne(mot: String; motvoulant: String; Position: Integer = 1): Boolean;
function Transform2Den3D(x, y: LongInt): TVector3D;
function Transform3Den2D(x, y, z: LongInt): TVector2D;
function TransformDouble2Den3D(x, y: Double): TVector3DV;
function TransformDouble3Den2D(x, y, z: Double): TVector2DV;
function IsNotNull(nombre: LongInt): Boolean;
function IsNotNull(nombre: Double): Boolean;

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

function Lireligne(mot: String; motvoulant: String; position: Integer): Boolean;
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

end.

