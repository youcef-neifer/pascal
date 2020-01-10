program Rjour;
uses
  sysutils;
type
  TJour = (dimanche, lundi, mardi, mercredi, jeudi, vendredi, samedi);
var
  jour: TJour;
  t: TDateTime;

begin
  t := Now;
  jour := TJour(DayOfWeek(t) - 1);
  WriteLn('D''après moi, nous somme le ', jour);
  repeat
    t := Now;
    Write(#13'La date est: ', DateTimeToStr(t));
    Sleep(1000);
  until False;
end.
