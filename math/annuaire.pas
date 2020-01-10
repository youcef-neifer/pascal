PROGRAM annuaire (input,output);
{ version simplifiée }
TYPE
  ligne = string [40];
  typepersonne = record
                   nom : ligne;
                   num_tel : ligne
                   { integer malheureusement < 32635 }
                 end;
VAR
  pers : array [1..100] of typepersonne;
  nb, i : 1..100;
  rep : char;
  imprimer : boolean;
  texte : ligne;
BEGIN
  { on suppose avoir ici les instructions permettant de lire sur fichier disque NB et le tableau PERS }
  repeat
    writeln('Recherche suivant : ');
    writeln(' N : nom');
    writeln(' T : numéro téléphone');
    writeln(' Q : quitter le prog');
    writeln('Quel est votre choix ?');
    readln(rep);
    if rep <> 'Q' then begin
      writeln('Texte à chercher ? ');
      readln(texte);
      for i := 1 to nb do with pers[i] do
        begin
          case rep of
            'N' : imprimer := nom = texte;
            'T' : imprimer := num_tel = texte;
          end;
          if imprimer then begin
            writeln('Nom  : ',nom);
            writeln('Tel  : ',num_tel)
          end
        end
    end
  until rep = 'Q'
END.
