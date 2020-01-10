PROGRAM classer (input,output);
VAR
  n, i, index, petit, indexpetit : integer;
  avant, apres : array [1..100] of integer;
  pris : array [1..100] of boolean;
     { pour noter ceux déjà pris }
begin
  repeat
    writeln('Nb valeurs (100 maxi) ?');
    readln(n)
  until (n > 0) and (n <= 100);
  { entrée valeurs - initialisation de pris }
  for index := 1 to n do
    begin
      writeln(index,'ième valeur ? ');
      readln(avant[index]);
      pris[index] := false
    end;
  { ordre croissant,on cherche N valeurs }
  for i := 1 to n do
    begin
      petit := maxint; { plus grand possible }
      { recherche du plus petit non pris }
      for index := 1 to n do
        if (not pris[index]) and (avant[index] <= petit) then
          begin
            petit := avant[index];
            indexpetit := index
          end;
      { sauvegarde dans le tableau APRES et mise à jour de PRIS }
      apres[i] := petit;
      pris[indexpetit] := true
    end; { passage au prochain i }
  { affichage du tableau APRES }
  writeln('Par ordre croissant : ');
  for i := 1 to N do writeln(apres[i]);
  { classement par ordre décroissant }
  writeln('Par ordre décroissant : ');
  for i := n downto 1 do writeln(apres[i]);
  { n'auriez-vous pas tout refait ? }
END.
