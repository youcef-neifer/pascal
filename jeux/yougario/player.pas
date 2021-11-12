unit player;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, ExtCtrls;

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
      constructor Create(AOwner: TComponent; APosition: TPoint); virtual; overload;
      function Rect: TRect; overload;
      procedure Paint; virtual;
      property Color: TColor read FColor write FColor;
      property Position: TPoint read FPosition write FPosition;
      property Taille: Integer read GetTaille write SetTaille;
  end;

  TBoule = record
    X, Y: Integer;
    ATaille: Real;
  end;

  TBoules = array[2..16] of TBoule;

  { TPlayer }

  TPlayer = class(TMiette)
    private
      FBoule: TBoules;
      alpha: Real;
      function GetTaille: Integer;
      procedure SetTaille(AValue: Integer);
    public
      numberboule: Integer;
      propulsion: Integer;
      constructor Create(AOwner: TComponent; APosition: TPoint); override;
      function distance(X, Y: Integer; Player: TMiette): Integer;
      function distance(Miette: TMiette): Integer;
      function distance(A, B: TPoint): Integer;
      function move(dx, dy: Integer): Boolean;
      function Rect(PosX: Integer; PosY, rayon: Integer): TRect; overload;
      function Mange(Player: TMiette): Boolean;
      procedure Balance(PosMouseX, PosMouseY: Integer);
      procedure Paint; override;
      procedure Reconstitue;
      property Boule: TBoules read FBoule;
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

procedure TMiette.Paint;
begin
  with Owner as TPaintBox, Canvas do begin
    Brush.Color := Self.Color;
    Ellipse(Rect);
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
  numberboule := 1;
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
    FBoule[2].X := Position.X + Trunc((rayon + Boule[2].ATaille / 2 + propulsion) * cos(alpha));
    FBoule[2].Y := Position.Y + Trunc((rayon + Boule[2].ATaille / 2 + propulsion) * sin(alpha));
    if numberboule > 3 then begin
      for i := 3 to 16 do begin
        rayon := Trunc(FBoule[i - 1].ATaille) div 2;
        FBoule[i].X := Trunc(FBoule[i - 1].X) + Trunc((rayon + Boule[i].ATaille / 2) * cos(alpha));
        FBoule[i].Y := Trunc(FBoule[i - 1].Y) + Trunc((rayon + Boule[i].ATaille / 2) * sin(alpha));
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
  end else if numberboule > 1 then begin
     for i := 2 to numberboule do begin
       if distance(Boule[i].X, Boule[i].Y, Player) < (Taille + Player.Taille) div 2 then begin
          FBoule[i].ATaille := Sqrt(Boule[i].ATaille ** 2 + Player.FTaille ** 2);
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
  for j := 1 to numberboule do begin
    if j = 1 then begin
      TailleCondition[j] := FTaille;
      nbBoule[j] := FTaille;
    end else begin
      TailleCondition[j] := FBoule[j].ATaille;
      nbBoule[j] := FBoule[j].ATaille;
    end;
  end;
  for j := 1 to numberboule do begin
    WriteLn((numberboule < 16) and (Trunc(TailleCondition[j]) >= 36));
    if (numberboule < 16) and (Trunc(TailleCondition[j]) >= 36) then begin
      numberboule := numberboule + 1;
      if j = 1 then TailleBoule := FTaille else TailleBoule := FBoule[j].ATaille;
      TailleBoule /= 2;
      nbBoule[j] := TailleBoule;
      nbBoule[numberboule] := TailleBoule;
      FTaille := nbBoule[1];
      WriteLn('Taille = ', nbBoule[1], ' and J = ', j);
      FBoule[2].ATaille := nbBoule[2];
      rayon := Trunc(nbBoule[1]) div 2;
      FBoule[2].X := Position.X + Trunc((rayon + FBoule[2].ATaille / 2) * cos(alpha));
      FBoule[2].Y := Position.Y + Trunc((rayon + FBoule[2].ATaille / 2) * sin(alpha));
      if numberboule >= 3 then begin
        for i := 3 to 16 do begin
          rayon := Trunc(nbBoule[i - 1]) div 2;
          FBoule[i].ATaille := nbBoule[i];
          FBoule[i].X := Trunc(FBoule[i - 1].X) + Trunc((rayon + FBoule[i].ATaille / 2) * cos(alpha));
          FBoule[i].Y := Trunc(FBoule[i - 1].Y) + Trunc((rayon + FBoule[i].ATaille / 2) * sin(alpha));
        end;
      end;
    end;
  end;
end;

procedure TPlayer.Paint;
var
  ARect : TRect;
  i: Integer;
begin
  with Owner as TPaintBox, Canvas do begin
    Brush.Color := Self.Color;
    ARect := Rect(Position.X, Position.Y, Taille div 2);
    for i := 1 to numberboule do begin
      Ellipse(ARect);
      ARect := Rect(Boule[i+1].X, Boule[i+1].Y, Trunc(Boule[i+1].ATaille) div 2);
    end;
  end;
end;

procedure TPlayer.Reconstitue;
var
  i: Integer;
begin
  if numberboule > 1 then begin
    for i := 2 to numberboule do begin
      FTaille += Boule[i].ATaille;
      numberboule := 1;
    end;
  end;
end;

end.

