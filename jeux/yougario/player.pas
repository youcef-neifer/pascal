unit player;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics;

type

  { TMiette }

  TMiette = class(TComponent)
    private
      FPosition: TPoint;
      FColor: TColor;
      function GetTaille: Integer;
      procedure SetTaille(AValue: Integer);
    public
      FTaille: Real;
      constructor Create(AOwner: TComponent; APosition: TPoint); virtual;
      function Rect: TRect; overload;
      property Color: TColor read FColor write FColor;
      property Position: TPoint read FPosition write FPosition;
      property Taille: Integer read GetTaille write SetTaille;
  end;

  ATMiette = array[1..100] of TMiette;


  Boules = record
    NB: Integer;
    X, Y: array[2..16] of Integer;
    ATaille: array[2..16] of Real;
  end;

  { TPlayer }

  TPlayer = class(TMiette)
    private
      FBoule: Boules;
      alpha: Real;
      function GetTaille: Integer;
      procedure SetTaille(AValue: Integer);
    public
      propulsion: Integer;
      constructor Create(AOwner: TComponent; APosition: TPoint); override;
      function distance(X, Y: Integer; Player: TMiette): Integer;
      function distance(Miette: TMiette): Integer;
      function distance(A, B: TPoint): Integer;
      function move(dx, dy: Integer): Boolean;
      function Rect(PosX: Integer; PosY, rayon: Integer): TRect; overload;
      function Mange(Player: TMiette): Boolean;
      procedure Balance(PosMouseX, PosMouseY: Integer);
      procedure Reconstitue;
      property Boule: Boules read FBoule;
  end;

implementation
uses
  Math;

{ TMiette }

function TMiette.GetTaille: Integer;
begin
  Result := Trunc(FTaille);
end;

procedure TMiette.SetTaille(AValue: Integer);
begin
  FTaille := AValue;
end;

constructor TMiette.Create(AOwner: TComponent; APosition: TPoint);
begin
  inherited Create(AOwner);
  FPosition := APosition;
  FTaille := 9;
  Color := Graphics.RGBToColor(Random(255), Random(255), Random(255));
end;

function TMiette.Rect: TRect;
var
  rayon: Integer;
begin
  rayon := Taille div 2;
  with Result do begin
    Left := FPosition.X - rayon;
    Top := FPosition.Y - rayon;
    Right := FPosition.X + rayon;
    Bottom := FPosition.Y + rayon;
  end;
end;

{ TPlayer }

function TPlayer.GetTaille: Integer;
begin
  Result := Trunc(FTaille);
end;

procedure TPlayer.SetTaille(AValue: Integer);
begin
  FTaille := AValue;
end;

constructor TPlayer.Create(AOwner: TComponent; APosition: TPoint);
begin
  inherited Create(AOwner, APosition);
  FPosition := APosition;
  FTaille := 27;
  Color := Graphics.RGBToColor(Random(255), Random(255), Random(255));
  FBoule.Nb := 1;
  propulsion := 0;
end;

function TPlayer.distance(X, Y: Integer; Player: TMiette): Integer;
begin
  Result := distance(Point(X, Y), Player.Position);
end;

function TPlayer.distance(Miette: TMiette): Integer;
begin
  Result := distance(Position, Miette.Position);
end;

function TPlayer.distance(A, B: TPoint): Integer;
begin
  Result := Round(sqrt((A.X - B.X) ** 2 + (A.Y - B.Y) ** 2));
end;

function TPlayer.move(dx, dy: Integer): Boolean;
var
  i, rayon:Integer;
begin
  rayon := Taille div 2;
  with FPosition do begin
    X += dx;
    Y += dy;
    FBoule.X[2] := Position.X + Trunc((rayon + Boule.ATaille[2] / 2 + propulsion) * cos(alpha));
    FBoule.Y[2] := Position.Y + Trunc((rayon + Boule.ATaille[2] / 2 + propulsion) * sin(alpha));
    if Boule.NB > 3 then begin
      for i := 3 to 16 do begin
        rayon := Trunc(FBoule.ATaille[i - 1]) div 2;
        FBoule.X[i] := Trunc(FBoule.X[i - 1]) + Trunc((rayon + Boule.ATaille[i] / 2) * cos(alpha));
        FBoule.Y[i] := Trunc(FBoule.Y[i - 1]) + Trunc((rayon + Boule.ATaille[i] / 2) * sin(alpha));
      end;
    end;
  end;
  Result := True;
end;

function TPlayer.Rect(PosX: Integer; PosY, rayon: Integer): TRect;
begin
  //rayon := Taille div 2;
  with Result do begin
    Left := PosX - rayon;
    Top := PosY - rayon;
    Right := PosX + rayon;
    Bottom := PosY + rayon;
  end;
end;

function TPlayer.Mange(Player: TMiette): Boolean;
var
  i: Integer;
begin
  Result := False;
  if not Assigned(Player) or (Player = Self) then begin
    Exit;
  end;
  if FTaille < Player.FTaille then begin
    Exit;
  end;
  if distance(Player) < (Taille + Player.Taille) div 2 then begin
    FTaille := Sqrt(FTaille ** 2 + Player.FTaille ** 2);
    Player.Free;
    Result := True;
  end else if Boule.NB > 1 then begin
     for i := 2 to Boule.NB do begin
       if distance(Boule.X[i], Boule.Y[i], Player) < (Taille + Player.Taille) div 2 then begin
          FBoule.ATaille[i] := Sqrt(Boule.ATaille[i] ** 2 + Player.FTaille ** 2);
          Player.Free;
          Result := True;
          Exit;
       end;
    end;
  end;
end;

procedure TPlayer.Balance(PosMouseX, PosMouseY: Integer);
var
  i, j, rayon: Integer;
  TailleBoule: Real;
  nbBoule: array[1..16] of Real;
  TailleCondition: array[1..16] of Real;
begin
  alpha := ArcTan2(PosMouseX - Position.X, PosMouseY - Position.Y);
  for j := 1 to FBoule.NB do begin
    if j = 1 then begin
      TailleCondition[j] := FTaille;
      nbBoule[j] := FTaille;
    end else begin
      TailleCondition[j] := FBoule.ATaille[j];
      nbBoule[j] := FBoule.ATaille[j];
    end;
  end;
  for j := 1 to FBoule.NB do begin
    WriteLn((FBoule.NB < 16) and (Trunc(TailleCondition[j]) >= 36));
    if (FBoule.NB < 16) and (Trunc(TailleCondition[j]) >= 36) then begin
      FBoule.NB := FBoule.NB + 1;
      if j = 1 then TailleBoule := FTaille else TailleBoule := FBoule.ATaille[j];
      TailleBoule /= 2;
      nbBoule[j] := TailleBoule;
      nbBoule[FBoule.NB] := TailleBoule;
      FTaille := nbBoule[1];
      WriteLn('Taille = ', nbBoule[1], ' and J = ', j);
      FBoule.ATaille[2] := nbBoule[2];
      rayon := Trunc(nbBoule[1]) div 2;
      FBoule.X[2] := Position.X + Trunc((rayon + FBoule.ATaille[2] / 2) * cos(alpha));
      FBoule.Y[2] := Position.Y + Trunc((rayon + FBoule.ATaille[2] / 2) * sin(alpha));
      if Boule.NB >= 3 then begin
        for i := 3 to 16 do begin
          rayon := Trunc(nbBoule[i - 1]) div 2;
          FBoule.ATaille[i] := nbBoule[i];
          FBoule.X[i] := Trunc(FBoule.X[i - 1]) + Trunc((rayon + FBoule.ATaille[i] / 2) * cos(alpha));
          FBoule.Y[i] := Trunc(FBoule.Y[i - 1]) + Trunc((rayon + FBoule.ATaille[i] / 2) * sin(alpha));
        end;
      end;
    end;
  end;
end;

procedure TPlayer.Reconstitue;
var
  i: Integer;
begin
  if FBoule.NB > 1 then begin
    for i := 2 to Boule.NB do begin
      FTaille += Boule.ATaille[i];
      FBoule.NB := 1;
    end;
  end;
end;

end.

