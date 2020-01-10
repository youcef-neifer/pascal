PROGRAM remplir (output);
   {entête du prog principal}

VAR i : integer;
   {déclarations prog princ.}

   {dont déclaration LIGNE}
PROCEDURE ligne(n:integer);
   {entête de la procédure}
var j : integer;
   {déclarations procédure}
BEGIN
  {corps de la procédure}
  for j := 1 to n do write('*');
  writeln
END;

BEGIN
  {instructions du prog princ}
  for i := 1 to 25 do ligne(70)
END.
