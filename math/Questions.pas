program Questions;
var
  prenom: string;
  age: Integer;
  nourriture:string;
begin
  WriteLn('Bonjour! Quel est on prénom?');
  ReadLn(prenom);
  WriteLn('Enchanté de te connaitre ', prenom, '!!!');
  WriteLn('Quel age a tu?');
  ReadLn(age);
  if age < 13 then begin
    WriteLn('Tu es plus jeune que je ne le pensait!');
  end else begin
    WriteLn('Tu es trop vieux!!!');
  end;
end.

