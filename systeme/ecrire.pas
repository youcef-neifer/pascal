program ecrire;
var
  phrase:string;
  Fichier:Text;
  NomFichier:String;
begin
  WriteLn('Bonjour, entrez le nom du fichier');
  ReadLn(NomFichier);
  Assign(Fichier, NomFichier);
  ReWrite(Fichier);
  WriteLn('Vous pouvez écrire ce que vous voulez. Tapez aurevoir! pour finir.');
  repeat
    ReadLn(phrase);
    if phrase <> 'aurevoir!' then begin
      WriteLn(Fichier, phrase);
    end;
  until phrase = 'aurevoir!';
  Close(Fichier);
 end.
