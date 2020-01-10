program questions;
uses
  sysutils;
type
  TJour = (dimanche, lundi, mardi, mercredi, jeudi, vendredi, samedi);
const
  question1 = 'Quel age as tu ?';
  reponse1 = 'J''ai 23 ans';
  question2 = 'Qui t''a inventé ?';
  reponse2 = 'C''est mon maître, Youcef Neifer';
  question3 = 'Qui êtes vous ?';
  reponse3 = 'L''intelligence artificielle 0.0.3 créé sur Pascal par mon maître';
  question4 = 'Quel classe était ton maitre quand il t''a créé ?';
  reponse4 = 'Au collège Paul Fort plus précisément en 6e Mercure puis modifier en 5e Franquin.';
  question5 = 'Vous servez à quoi ?';
  reponse5 = 'Je sert à répondre à vos question.';
  question7 = 'Où il habitait ?';
  reponse7 = 'A courcourronne 18 Avenue René Descartes';
  question8 = 'Dans quelle pays et dans quelle continent ?';
  reponse8 = 'En France le pays et en Europe le continent !';
  question9 = 'Ca se passe bien avec tes frères ?';
  reponse9 = 'Oui sauf des fois avec mon grand frère Yassine Neifer';
  question10 = 'C''était qui tes amis ?';
  reponse10 = 'Mes amis sont Anas,Ilyess,Mourade,habib,Amine,Hamza.';
  question11 = 'Quel jour on est ?';
  reponse11 = 'Nous somme le ';
  question12 = 'Quel est ton film préféré ?';
  reponse12 = 'C''est Dragon Ball Super.';
  question13 = 'Quel est ton jeu de société préféré ?';
  reponse13 = 'C''est les échecs';
  question14 = 'Quel est ta matière préféré ?';
  reponse14 = 'C''est les maths,l''histoire,la géographie,l'' SVT,la phisique chimie et la tecnologie';
  question15 = 'Quel est ton sport préféré ?';
  reponse15 = 'Mon sport préféré est le karaté';
  question16 = 'Où habites-tu ?';
  reponse16 = 'Courcouronnes';
  question17 = 'On est le combien ?';
  reponse17 = 'On est le ';
  question18 = '';
  reponse18 = '';
function SupprimeEspaces(phrase: string): string;
var
  n, p: Integer;
begin
  p := Low(phrase);
  for n := Low(phrase) to High(phrase) do begin
    phrase[p] := phrase[n];
    if phrase[n] <> ' ' then begin
      p := p + 1;
    end;
  end;
  SetLength(phrase, p - 1);
  Result := LowerCase(phrase);
end;

function JourDeLaSemaine: string;
var
  jour: TJour;
  t: TDateTime;
begin
  t := Now;
  jour := TJour(DayOfWeek(t) - 1);
  WriteLn('D''après moi, nous somme le ', jour);
  repeat
    t := Now;
    Sleep(1000);
    Write(#13'La date est: ', DateTimeToStr(t));
  until False;
end;

var
  question: string;
  reponse: string;
begin
  WriteLn('Bonjour, pose moi une question');
  repeat
    Write(JourDeLaSemaine);
    ReadLn(question);
    reponse := 'Désolé, je ne sais pas répondre à cette question!';
    question := SupprimeEspaces(question);
    reponse := 'Désolé, je ne sais pas répondre à cette question!';
    if question = SupprimeEspaces(question1) then begin
       reponse := reponse1;
    end;
    if question = SupprimeEspaces(question2) then begin
       reponse := reponse2;
    end;
    if question = SupprimeEspaces(question3) then begin
       reponse := reponse3;
    end;
    if question = SupprimeEspaces(question4) then begin
       reponse := reponse4;
    end;
    if question = SupprimeEspaces(question5) then begin
       reponse := reponse5;
    end;
    if question = SupprimeEspaces(question7) then begin
       reponse := reponse7;
    end;
    if question = SupprimeEspaces(question8) then begin
       reponse := reponse8;
    end;
    if question = SupprimeEspaces(question9) then begin
       reponse := reponse9;
    end;
    if question = SupprimeEspaces(question10) then begin
       reponse := reponse10;
    end;
    if question = SupprimeEspaces(question11) then begin
       reponse := reponse11 + JourDeLaSemaine;
    end;
    if question = SupprimeEspaces(question12) then begin
       reponse := reponse12;
    end;
    if question = SupprimeEspaces(question13) then begin
       reponse := reponse13;
    end;
    if question = SupprimeEspaces(question14) then begin
       reponse := reponse14;
    end;
    if question = SupprimeEspaces(question15) then begin
       reponse := reponse15;
    end;
    if question = SupprimeEspaces(question16) then begin
       reponse := reponse16;
    end;
    if question = SupprimeEspaces(question17) then begin
       reponse := reponse17;
    end;
    if question = SupprimeEspaces(question18) then begin
       reponse := reponse18;
    end;        
      if question <> '#27!' then begin
      WriteLn(reponse);
    end;
  until question = #27;
end.
