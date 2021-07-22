unit Pouvoir;

{$mode objfpc}{$H+}

interface

type
  TEffet = (Null, Empoisonnement, Paralysie, Brule, Glace, Etourdie, Endormie, Soin);

  { TSortMagie }

  TSortMagie = record
    Name: String;
    ForceMagique: Integer;
    DefenseMagique: Integer;
    VitesseDeRecharge: Integer;
    Portee: Integer;
    QuantiteMana: Integer;
    Description: String;
    Effet: TEffet;
end;

  { TSort }

  TSort = record
    ForceSortSorcellerie: Integer;
    DefenseUtilisateurSort: Integer;
    Name: String;
    QuantiteMana: Integer;
    Description: String;
    Effet: TEffet;
    Vitessedepreparation: Integer;
    Portee: Integer;
  end;

  { TPouvoir }

  TPouvoir = class
    Force: Integer;
    Reserve: Integer;
    Distance: Integer;
    function Attaque: Boolean; virtual;
    function Contre(aForce: Integer): Boolean; virtual;
  end;

  { TPhysique }

  TPhysique = class(TPouvoir)
    constructor Create;
    function Attaque: Boolean; override;
  end;

  { TMagique }

  TMagique = class(TPouvoir)
    constructor Create;
    function Attaque: Boolean; override;
    procedure ProprieteSort(SortUtiliser: TSortMagie);
  end;

  { TSorcellerie }

  TSorcellerie = class(TPouvoir)
    constructor Create;
    function Attaque: Boolean; override;
    procedure ProprieteSort(SortUtiliser: TSort);
  end;

  { TEsquive }

  TEsquive = class(TPouvoir)
    constructor Create;
    function Attaque: Boolean; override;
    function Contre(aForce: Integer): Boolean; override;
  end;


implementation

{ TEsquive }

constructor TEsquive.Create;
begin
  inherited;
  Force := 5;
end;

function TEsquive.Attaque: Boolean;
begin
  Result := False;
end;

function TEsquive.Contre(aForce: Integer): Boolean;
begin
  result := aForce >= Force;
end;

{ TPouvoir }

function TPouvoir.Attaque: Boolean;
begin
  result := Reserve >= Force;
  if result then begin
    Reserve -= Force;
  end;
end;

function TPouvoir.Contre(aForce: Integer): Boolean;
begin
  result := False;
end;

{ TPhysique }

constructor TPhysique.Create;
begin
  inherited;
  Force := 5;
  Reserve := 100;
  Distance := 1;
end;

function TPhysique.Attaque: Boolean;
begin
  result := inherited;
end;

{ TSorcellerie }

constructor TSorcellerie.Create;
begin
  inherited;
  Distance := 25;
end;

function TSorcellerie.Attaque: Boolean;
begin
  result := inherited;
end;

procedure TSorcellerie.ProprieteSort(SortUtiliser: TSort);
begin
  //Sort.Portee := SortUtiliser.Portee;
  //Sort.ForceSortSorcellerie := SortUtiliser.ForceSortSorcellerie;
  //Sort.Description := SortUtiliser.Description;
  //Sort.Name := Sort.Name;
  //Sort.DefenseUtilisateurSort := SortUtiliser.DefenseUtilisateurSort;
  //Sort.Effet := SortUtiliser.Effet;
  //Sort.QuantiteMana := SortUtiliser.QuantiteMana;
  //Sort.Vitessedepreparation := SortUtiliser.Vitessedepreparation;
end;

{ TMagique }

constructor TMagique.Create;
begin
  inherited;
  Distance := 10;
end;

function TMagique.Attaque: Boolean;
begin
  result := inherited;
end;

procedure TMagique.ProprieteSort(SortUtiliser: TSortMagie);
begin
  //SortMagie.Name := '';
  //SortMagie.DefenseMagique := 0;
  //SortMagie.ForceMagique := 0;
  //SortMagie.Description := '';
  //SortMagie.Effet := Null;
  //SortMagie.Portee := 0;
  //SortMagie.QuantiteMana := 0;
  //SortMagie.VitesseDeRecharge := 0;
  //SortMagie.Portee := SortUtiliser.Portee;
  //SortMagie.ForceMagique := SortUtiliser.ForceMagique;
  //SortMagie.Description := SortUtiliser.Description;
  //SortMagie.Name := SortUtiliser.Name;
  //SortMagie.DefenseMagique := SortUtiliser.DefenseMagique;
  //SortMagie.Effet := SortUtiliser.Effet;
  //SortMagie.QuantiteMana := SortUtiliser.QuantiteMana;
  //SortMagie.VitesseDeRecharge := SortUtiliser.VitesseDeRecharge;
end;

{ TPhysique }


end.
