program theoremedepythagore;
var
  b, c, d, e: Integer;
  a, f: Real;
begin
  ReadLn(b);
  ReadLn(c);
  d := c * c;
  e := b * b;
  f := e + d;
  a := sqrt(f);
  Write('Le théoreme de Pythagore ');
  Write('pour l''hypothénus est ', a:0:2);
end.

