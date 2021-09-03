unit Animation;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Load3DObject;

type

  TNbMaxAnimation = array[1..50] of string;

  { TAnimation }

  TAnimation = class
  private
    FAnimation: TNbMaxAnimation;
    i: Integer;
    function LengthAnimation: Integer;
    function NotNull(ArrayString: TNbMaxAnimation): Boolean;
  public
    Constructor Create(const NbAnimation: Integer);
    procedure ImplementeAnimation(NameAnimation: TNbMaxAnimation);
    procedure DownAnimation;
    procedure UpAnimation;
  end;

implementation

{ TAnimation }

function TAnimation.LengthAnimation: Integer;
var
  nbMax: Integer;
begin
  for nbMax := Low(FAnimation) to High(FAnimation) do begin
    if FAnimation[nbMax] = '' then begin
      Result := nbMax - 1;
      Continue;
    end;
  end;
end;

function TAnimation.NotNull(ArrayString: TNbMaxAnimation): Boolean;
begin
  if ArrayString[i] = '' then Result := false else Result := true;
end;

constructor TAnimation.Create(const NbAnimation: Integer);
begin
  i := 0;
end;

procedure TAnimation.ImplementeAnimation(NameAnimation: TNbMaxAnimation);
begin
  FAnimation := NameAnimation;
end;

procedure TAnimation.DownAnimation;
begin
  i -= 1;
  if NotNull(FAnimation) then LoadObject3DFile(FAnimation[i]) else begin
    i := 0;
    Exit;
  end;
  if i = 0 then i := LengthAnimation;
end;

procedure TAnimation.UpAnimation;
begin
  i += 1;
  if NotNull(FAnimation) then LoadObject3DFile(FAnimation[i]) else begin
    i := 0;
    Exit;
  end;
  if i = 50 then i := 0;
end;

end.

