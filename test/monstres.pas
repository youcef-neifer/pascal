unit Monstres;

{$mode objfpc}{$H+}

interface

uses
  Personnage, Pouvoir;

type
  TMonstre = class(TPersonne)
  end;

  { TGobelin }

  TGobelin = class(TMonstre)
    constructor Create;
  end;

implementation

{ TGobelin }

constructor TGobelin.Create;
begin
  Pouvoir[1] := TPhysique.Create;
  Name := 'Gobelin';
  Defense := 2;
  Vie := 10;
  Niveau := 3;
end;

end.

