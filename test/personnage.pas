unit Personnage;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Pouvoir;

const
  NombrePouvoirMax = 3;

type
  TEffetUtilisateur = (PVenMoins, PVenPlus);

  { TObjet }
    TObjet = class
      Force: Integer;
      Vitessedepreparation: Integer;
      Vitesse: Integer;
      Durabilite: Integer;
      Description: String;
      Nombre: Integer;
    end;

  { TEpee }

  TEpee = class(TObjet)
  end;


{ TBatonMagique }

  TBatonMagique = class(TObjet)
  end;

{ TBatonMagiueDebutant }

  TBatonMagiqueDebutant = class(TBatonMagique)
    constructor Create;
  end;

  TSousClass = record

  end;


  TTypeClass = record
    sousClass: TSousClass;
    NomClass: String;
  end;

  TSexe = (Null, Homme, Femme);
  TEvolution = record
    TypeClass: TTypeClass;
  end;

  { TPersonne }

  TPersonne = class
    x, y, z: Integer;
    Name: String;
    Genre: TSexe;
    Age: Integer;
    Vie: Integer;
    VieMax: Integer;
    Mana: Integer;
    Mort: Integer;
    Defense: Integer;
    Experience: Integer;
    Niveau: Integer;
    Potion: Integer;
    identifiepersonne: String;
    Objet: TObjet;
    Evolution: TEvolution;
    Pouvoir: array[1..NombrePouvoirMax] of TPouvoir;
    constructor Create(aName: string; aAge: Integer; aGenre: TSexe);
    function Distance(Personne: TPersonne): Integer;
    procedure monteniveau;
    procedure Attaque(Personne: TPersonne);
    procedure Encaisse(aForce: Integer);
    procedure Battre;
    procedure Choisir(NameClass: String);
  end;


var
ChoisirList: array of String = ('Sorcier', 'Guerrier', 'Magicien');

implementation

procedure TPersonne.Choisir(NameClass: String);
var
    i: Integer;
begin
  for i := Low(ChoisirList) to High(ChoisirList) do begin
    if ChoisirList[i] = NameClass then begin
    Self.Evolution.TypeClass.NomClass := NameClass;
    end;
  end;
    if Self.Evolution.TypeClass.NomClass <> '' then begin
      for i := Low(ChoisirList) to High(ChoisirList) do begin
        Delete(ChoisirList, i, 3);
//        Insert('you', ChoisirList, i);
      end;
    end;
  if Self.Evolution.TypeClass.NomClass = '' then WriteLn('Error: The Class not exist');
end;


constructor TPersonne.Create(aName: string; aAge: Integer; aGenre: TSexe);
begin
  Name := aName;
  Age := aAge;
  Genre := aGenre;
  Vie := 12;
  Defense := 0;
  Niveau := 1;
  Experience := 0;
  VieMax := 12;
  Pouvoir[1] := TPhysique.Create;
  with Pouvoir[1] as TPhysique do begin
    if Genre = Homme then begin
      Force += 2;
    end;
  end;
  WriteLn(Name, ' a ', Vie, ' vie.');
end;

function TPersonne.Distance(Personne: TPersonne): Integer;
begin
  Result := Round(sqrt(sqr(x - Personne.x) + sqr(y - Personne.y) + sqr(z - Personne.z)));
end;

procedure TPersonne.monteniveau;
begin
  if Vie <> 0 then begin
    WriteLn('Vie : ', '+2');
    Vie  += 2;
  end;
  WriteLn('Esquive : ', '+2');
//    Esquive += 2;
  WriteLn('Defense :', ' +2');
  Defense += 2;
  WriteLn('Force :', ' +2');
//    Force += 2;
  VieMax += 2;
  WriteLn('Niveau : ', '+1');
  Niveau += 1;
end;

procedure TPersonne.Attaque(Personne: TPersonne);
var
  i: Integer;
begin
  if Vie > 0 then begin
    for i := Low(Pouvoir) to High(Pouvoir) do begin
      WriteLn(Name, ' tente d''attaquer ', Personne.Name, ' Force = ', Pouvoir[i].Force, ', Reserve = ', Pouvoir[i].Reserve);
      if Assigned(Pouvoir[i]) and Pouvoir[i].Attaque then begin
        if Distance(Personne) > Pouvoir[i].Distance then begin
          WriteLn('Attaque perdue car la cible est trop loin!')
        end else begin
          WriteLn(Personne.Name, ' tente d''esquiver ', Pouvoir[i].Force);
          Personne.Encaisse(Pouvoir[i].Force);
        end;
        break;
      end;
    end;
    WriteLn(Personne.Name ,' : ' ,Personne.Vie,'/10');
  end;
end;

procedure TPersonne.Encaisse(aForce: Integer);
var
  i: Integer;
begin
  for i := Low(Pouvoir) to High(Pouvoir) do begin
//    WriteLn(i, ' / ', Low(Pouvoir), ' , ', High(Pouvoir));
    if Assigned(Pouvoir[i]) and Pouvoir[i].Contre(aForce) then begin
      WriteLn(Name, ' a contré l''attaque de ', aForce);
      Exit;
    end;
  end;
  Vie -= aForce;
  if Vie < 0 then begin
    Vie := 0;
  end;
  WriteLn(Name, ' a perdu ', aForce, ' vie.');
end;

function estVivant(const Personne:TPersonne): Boolean;
begin
    Result := Personne.Vie > 0;
end;

procedure TPersonne.Battre;
var
    exprequis: Integer;
    estvie: Boolean;
begin
     estvie := estVivant(Self);
    if estvie = True then begin
        exprequis := 20;
        Experience += 20;
        WriteLn('Experience de ', Name, ' : ' , Experience);
        if Niveau > 1 then exprequis := exprequis * Niveau;
        if Experience = exprequis then begin
        WriteLn('Exprequis : ', exprequis, ' et Experience : ', Experience, ' donc niveau supérieur.');
        monteniveau;
        Experience := 0;
        end;
      end;
end;

  { TBatonMagiqueDebutant }

  constructor TBatonMagiqueDebutant.Create;
  begin
    Vitessedepreparation := 4;
  end;

initialization
end.

