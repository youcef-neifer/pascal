program Reccord;

uses
  Personnage, Pouvoir, Monstres;

const
  NbPersonne = 3;

var
    Personne: array of TPersonne;
    i, j: Integer;
    SortMagieplayer: array of TSortMagie;
    Gobelin: array[1..10] of TGobelin;
//    Epee: TEpee;

begin
    Randomize;
//    BatonMagiquedebutant := TBatonMagiqueDebutant.Create;
    for i := Low(Gobelin) to High(Gobelin) do begin
      Gobelin[i] := TGobelin.Create;
    end;
    //Epee := TEpee.Create;
    //Epee.Force := 10;
    SortMagieplayer := nil;
    SetLength(SortMagieplayer, 2);
    SortMagieplayer[0].Name := 'Boule de feu';
    SortMagieplayer[0].Description := 'Une petite boule de feu lançé à l''adversaire. Peut Bruler l''adversaire.';
    SortMagieplayer[0].Effet := Brule;
    SortMagieplayer[0].ForceMagique := 5;
    SortMagieplayer[0].QuantiteMana := 4;
  Personne := nil;
    SetLength(Personne, NbPersonne);
    //for i := Low(Personne) to High(Personne) do begin
    //  Personne[i] := TPersonne.Create;
    //end;
    Personne[0] := TPersonne.Create('Youcef', 14, Homme);
    with Personne[0] do begin
      Pouvoir[2] := TEsquive.Create;
    end;
    Personne[1] := TPersonne.Create('Ismail', 13, Homme);
    Personne[2] := TPersonne.Create('Maryam', 11, Femme);
    Personne[0].Potion := 1;
    While Length(Personne) > 1 do begin
      i := Random(Length(Personne));
      repeat
        j := Random(Length(Personne));
      until j <> i;
          WriteLn(Personne[i].Name, ' attaque ', Personne[j].Name);
          Personne[i].Attaque(Personne[j]);
      if Personne[i] = Personne[0] then begin
        //if Personne[0].Vie <= 6 then begin
        //Personne[0] := utilisePotion(Personne[0]);
        end else begin
        end;
//      end;
      if (Personne[j].Vie <= 0) then begin
        WriteLn(Personne[j].Name, ' est mort!');
        Personne[j].Destroy;
        Delete(Personne, j, 1);
      end;
    end;
    if Personne[0].Vie > 0 then begin
      Personne[0].Battre;
      WriteLn('Niveau de ', Personne[0].Name, ' : ' ,Personne[0].Niveau);
      WriteLn('Experience de ', Personne[0].Name, ' : ' ,Personne[0].Experience);
      WriteLn(Personne[0].Name, ' a ', Personne[0].Vie, '/', Personne[0].VieMax);
      WriteLn(Gobelin[1].Name, ' débarque et vous attaque !');
      WriteLn('Générique du son de début pour entrer en phase de combat');
      while Gobelin[1].Vie > 0 do begin
        Personne[0].Attaque(Gobelin[1]);
      end;
      //Personne[0].Battre;
      //Personne[0].Objet := Epee;
      WriteLn('Niveau de ', Personne[0].Name, ' : ' ,Personne[0].Niveau);
    end;
end.
