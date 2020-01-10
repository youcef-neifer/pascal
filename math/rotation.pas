PROGRAM rotation (input,output);
VAR
  index, n : integer;
  prem : real;
  tableau : array [1..100] of real;
BEGIN
  repeat
    writeln('Nb valeurs (100 maxi) ?');
    readln(n)
  until (n > 0) and (n <= 100);
  { entrée des valeurs }
  for index := 1 to n do
    begin
      writeln(index,'ième valeur ?');
      readln(tableau[index]);
    end;
  writeln('On décale vers le haut');
  prem := tableau[1]; { ne pas écraser ! }
  for index := 2 to n do
    tableau[index - 1] := tableau[index];
  tableau[n] := prem;
  for index := 1 to n do
    writeln(tableau[index]);
  writeln('on re-décale vers le bas');
  prem := tableau[n];
  for index := n downto 2 do
    tableau[index] := tableau[index - 1];
  tableau[1] := prem;
  for index := 1 to n do
    writeln(tableau[index])
END.
