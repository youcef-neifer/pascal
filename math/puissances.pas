PROGRAM puissances (input, output);
VAR
  n, max : integer;
BEGIN
  writeln('Nombre maxi ? ');
  readln(max);
  n := 2;
  while n <= max do begin
    writeln(n);
    n := n * 2
  end;
  writeln('C''est fini')
END.
