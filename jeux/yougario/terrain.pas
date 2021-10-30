unit terrain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Player, TcpIpClient;

const
  MaxPlayersQty = 50;
  MaxMiettesQty = 300;

type

  { TForm1 }

  TForm1 = class(TForm)
    IdleTimer1: TIdleTimer;
    IdleTimer2: TIdleTimer;
    PaintBox1: TPaintBox;
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure IdleTimer2Timer(Sender: TObject);
    procedure MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure StartGame(Sender: TObject);
    procedure IdleTimer1Timer(Sender: TObject);
    procedure UpdatePlayer(Data: string; out n: Integer);
    procedure UpdatePlayer(Params: array of string; out n: Integer);
    procedure UpdateMiette(Data: string; out n: Integer);
    procedure UpdateMiette(Params: array of string; out n: Integer);
    procedure StopGame(Sender: TObject; var CloseAction: TCloseAction);
  private
    function GetMyPlayer: TPlayer;
  private
    Client: TTcpIpClientSocket;
    Data: String;
    DataSize: LongInt;
    Miettes: array[1..MaxMiettesQty] of TMiette;
    Players: array[1..MaxPlayersQty] of TPlayer;
    Mouse: TPoint;
    MyIndex: Integer;
    property MyPlayer:TPlayer read GetMyPlayer;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.IdleTimer1Timer(Sender: TObject);
var
  BrushColor: TColor;
  i, n: Integer;
  ARect: TRect;
  params, lines: array of String;
  alive: array[Low(Players)..High(Players)] of Boolean;
  alivemiette: array[Low(Miettes)..High(Miettes)] of Boolean;
begin
  Data := 'REFRESH';
  if Client.CanWrite(6000) then begin
    Client.Write(Data[1], Length(Data));
  end;
  for i := Low(alive) to High(alive) do begin
    alive[i] := False;
  end;
  for i := Low(alivemiette) to High(alivemiette) do begin
    alivemiette[i] := False;
  end;
  if Client.CanRead(6000) then begin
      DataSize := Client.Waiting;
      SetLength(Data, DataSize);
      DataSize := Client.Read(Data[1], DataSize);
      SetLength(Data, DataSize);
      lines := Data.Split(LineEnding);
      for i := Low(lines) to High(lines) do begin
        params := lines[i].Split(' ');
        case params[0] of
          'PLAYER':begin
            UpdatePlayer(Params, n);
            alive[n] := True;
          end;
          'MIETTE':begin
            UpdateMiette(Params, n);
            alivemiette[n] := True;
          end;
        end;
      end;
  end;
  for i := Low(alive) to High(alive) do begin
    if Assigned(Players[i]) and not alive[i] then begin
      Players[i].Free;
      Players[i] := nil;
      if i = MyIndex then begin
        IdleTimer1.Enabled := False;
        Application.Terminate;
        Exit;
      end;
    end;
  end;
  with MyPlayer, Mouse do begin
    if Position.X > X then move(-1 - (Position.X - X) div Taille, 0);
    if Position.X < X then move(1 + (X - Position.X) div Taille, 0);
    if Position.Y > Y then move(0, -1 - (Position.Y - Y) div Taille);
    if Position.Y < Y then move(0, 1 + (Y - Position.Y) div Taille);
  end;
  with PaintBox1, Canvas do begin
    Canvas.Clear;
    TextOut(PaintBox1.Width - 25, PaintBox1.Height - 30, IntToStr(MyPlayer.Taille));
    BrushColor := Brush.Color;
    Brush.Color := MyPlayer.Color;
    ARect := MyPlayer.Rect(MyPlayer.Position.X, MyPlayer.Position.Y, MyPlayer.Taille div 2);
    for i := 1 to MyPlayer.Boule.NB do begin
      Ellipse(ARect);
      ARect := MyPlayer.Rect(MyPlayer.Boule.X[i+1], MyPlayer.Boule.Y[i+1], Trunc(MyPlayer.Boule.ATaille[i+1]) div 2);
    end;
    for i := Low(Players) to High(Players) do begin
      if Assigned(Players[i]) and (i <> MyIndex) then begin
        if MyPlayer.Mange(Players[i]) then begin
          Players[i] := nil;
          Data := format('KILL PLAYER %d' + LineEnding, [i]);
          Client.Write(Data[1], Length(Data));
        end else with Players[i], Position do begin
          Brush.Color := Players[i].Color;
          Ellipse(Players[i].Rect);
        end;
      end;
    end;
    for i := Low(Miettes) to High(Miettes) do begin
      if Assigned(Miettes[i]) then begin
        if MyPlayer.Mange(Miettes[i]) then begin
            Miettes[i] := nil;
            Data := format('KILL MIETTE %d' + LineEnding, [i]);
            Client.Write(Data[1], Length(Data));
        end else begin
          Brush.Color := Miettes[i].Color;
          Ellipse(Miettes[i].Rect);
        end;
      end;
    end;
    Brush.Color := BrushColor;
  end;
  if Client.CanWrite(6000) then with MyPlayer, Position do begin
    Data := format('UPDATE %d %d %d %.15f' + LineEnding, [MyIndex, X, Y, FTaille]);
    Client.Write(Data[1], Length(Data));
  end;
end;

procedure TForm1.StartGame(Sender: TObject);
begin
  Randomize;
  Client := TTcpIpClientSocket.Create('lt-youcef', 4100);
  Data := 'JOIN';
  Client.Write(Data[1], Length(Data));
  if Client.CanRead(60000) then begin
    DataSize := Client.Waiting;
    SetLength(Data, DataSize);
    Client.Read(Data[1], DataSize);
    UpdatePlayer(Data, MyIndex);
  end;
end;

procedure TForm1.MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  Mouse.X := X;
  Mouse.Y := Y;
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: char);
begin
  case Key of
    #27: begin
      Application.Terminate;
    end;
    ' ': begin
      MyPlayer.Balance(Mouse.X, Mouse.Y);
      IdleTimer2.Enabled := True;
    end;
  end;
end;

procedure TForm1.IdleTimer2Timer(Sender: TObject);
begin
  if MyPlayer.Boule.NB > 1 then begin
      MyPlayer.Reconstitue;
      IdleTimer2.Enabled := False;
  end;
end;

procedure TForm1.UpdatePlayer(Data: string; out n: Integer);
var
  Params: array of string;
begin
  Params := Data.Split(' ');
  UpdatePlayer(Params, n);
end;

procedure TForm1.UpdatePlayer(Params: array of string; out n: Integer);
begin
  n := StrToInt(Params[1]);
  if not Assigned(Players[n]) then begin
    Players[n] := TPlayer.Create(PaintBox1, Point(0, 0));
  end;
  with Players[n] do begin
    Position := Point(StrToInt(params[2]), StrToInt(params[3]));
    FTaille := StrToFloat(params[4]);
    Color := StrToInt(params[5]);
  end;
end;

procedure TForm1.UpdateMiette(Data: string; out n: Integer);
var
  Params: array of string;
begin
  Params := Data.Split(' ');
  UpdateMiette(Params, n);
end;

procedure TForm1.UpdateMiette(Params: array of string; out n: Integer);
begin
  n := StrToInt(Params[1]);
  if not Assigned(Miettes[n]) then begin
    Miettes[n] := TMiette.Create(PaintBox1, Point(0, 0));
  end;
  with Miettes[n] do begin
    Position := Point(StrToInt(params[2]), StrToInt(params[3]));
    FTaille := StrToFloat(params[4]);
    Color := StrToInt(params[5]);
  end;
end;

procedure TForm1.StopGame(Sender: TObject; var CloseAction: TCloseAction);
begin
  Client.Free;
  IdleTimer1.Enabled := False;
  IdleTimer2.Enabled := False;
end;

function TForm1.GetMyPlayer: TPlayer;
begin
  Result := Players[MyIndex];
end;

end.

