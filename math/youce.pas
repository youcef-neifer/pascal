program youce;
var
  prenom: string;
  rayon: real;
begin
  WriteLn('Bonjour! Comment tu t''appelle?');
  ReadLn(prenom);
  WriteLn('Enchanté de te connaitre ', prenom, '!');
  WriteLn('Donne moi le rayon d''une sphère');
  ReadLn(rayon);
  WriteLn('Le périmètre du cercle est: ', 2 * pi * rayon:0:3);
  WriteLn('La surface du disque est: ', pi * rayon * rayon:0:3);
  WriteLn('Le volume de la sphère est: ', 4 * pi / 3 * rayon * rayon * rayon:0:2);
  {Empécher la fenêtre de se fermer trop tôt}
  ReadLn;
end.
