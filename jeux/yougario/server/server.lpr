program server;

{$mode objfpc}{$H+}

uses
  cthreads, TcpIpServer, TcpIpClient, sysutils, Graphics, Classes;

const
  MaxPlayersQty = 50;
  MaxMiettesQty = 300;
  WindowWidth = 1280;
  WindowHight = 1024;

type
  PThreadParameters = ^TThreadParameters;
  TThreadParameters = record
    Socket: LongInt;
  end;

  TBoule = record
    Alive: Boolean;
    X, Y, Color: Integer;
    Taille: Real;
  end;

  TMiette = TBoule;

  TPlayer = record
    Alive: Boolean;
    Boules: array[1..16] of TBoule;
  end;
  TPlayers = array[1..MaxPlayersQty] of TPlayer;
  TMiettes = array[1..MaxMiettesQty] of TMiette;

const
  CONNECTION_PORT = 4100;

threadvar
  threadParameters: TThreadParameters;

var
  PlayersQty: Integer;
  MiettesQTY: Integer;
  Players: TPlayers;
  Miettes: TMiettes;

function ThreadFunction(parameter: pointer): ptrint;
var
  p: PThreadParameters absolute parameter;
  VData: string;
  VSocket,VDataSize: LongInt;
  VClient: TTcpIpClientSocket;
  params: array of string;
  n, i: Integer;
  Data: string;
  lines: array of string;
  PlayerIndex: Integer;
  paramsIndex, BouleIndex: Integer;
begin

  WriteLn('Start server ', p^.Socket);
  VSocket := p^.Socket;
  if VSocket = -1 then
    WriteLn('ERROR');
  VClient := TTcpIpClientSocket.Create(VSocket);
  MiettesQTY := Length(Miettes);
  repeat
    for n := Low(Miettes) to High(Miettes) do begin
      if not Miettes[n].Alive then with Miettes[n] do begin
        Alive := True;
        X := Random(WindowWidth);
        Y := Random(WindowHight);
        Taille := 9;
        Color := Random(MaxLongint);
      end;
    end;
    try
      if VClient.CanRead(60000) then
      begin
        VDataSize := VClient.Waiting;
        if VDataSize = 0 then begin
          break;
        end;
        SetLength(VData, VDataSize);
        VClient.Read(VData[1], VDataSize);
        WriteLn('Client says: "', VData, '"');
        WriteLn('len = ', Length(VData));
        lines := Trim(VData).Split(LineEnding);
        for Data in lines do try
          params := Trim(Data).Split(' ');
          VDATA := '';
          case params[0] of
            'JOIN': begin
              PlayersQty += 1;
              PlayerIndex := PlayersQty;
              with Players[PlayersQty].Boules[1] do begin
                Players[PlayersQty].Alive := True;
                X := Random(200);
                Y := Random(200);
                Taille := 27;
                Color := Random(MaxLongint);
                VDATA := format('PLAYER %d %d %d %.15f %d', [PlayersQty, X, Y, Taille, Color]);
              end;
            end;
            'REFRESH':begin
              for n := 1 to PlayersQty do with Players[n].Boules[1] do if Players[n].Alive then begin
                VDATA += format('PLAYER %d %d %d %.15f %d', [n, X, Y, Taille, Color]) + LineEnding;
              end;
              for n := 1 to MiettesQty do with Miettes[n] do if Alive then begin
                VDATA += format('MIETTE %d %d %d %.0f %d', [n, X, Y, Taille, Color]) + LineEnding;
              end;
            end;
            'UPDATE': begin
              n := StrToInt(params[1]);
              with Players[n].Boules[1] do begin
                X := StrToInt(params[2]);
                Y := StrToInt(params[3]);
                Taille := StrToFloat(params[4]);
                paramsIndex := 5;
                for i := 2 to High(Players[n].Boules) do with Players[n], Boules[i] do begin
                  if params[paramsIndex] <> '' then begin
                     BouleIndex := StrToInt(params[paramsIndex]);
                     X := StrToInt(params[paramsIndex + 1]);
                     Y := StrToInt(params[paramsIndex + 2]);
                     Taille := StrToFloat(params[paramsIndex + 3]);
                     paramsIndex += 4;
                  end;
                end;
              end;
            end;
            'KILL': begin
              case params[1] of
                'PLAYER':begin
                  n := StrToInt(params[2]);
                  with Players[n] do begin
                    WriteLn('Killing player ', n);
                    Alive := False;
                  end;
                end;
                'MIETTE':begin
                  n := StrToInt(params[2]);
                  with Miettes[n] do begin
                    Alive := False;
                  end;
                end;
              end;
            end;
          end;
        except
          VData := 'INVALID:' + VData;
        end;
        if Length(VData) > 0 then begin
          VDATA += ' END';
          WriteLn('Server answers: "', VDATA, '"');
          VClient.Write(VData[1], Length(VData));
        end;
      end;
    finally
      WriteLn('--Try Next');
    end;
  until false;
  VClient.Free;
  with Players[PlayerIndex] do begin
    WriteLn('Killing disconnected player ', PlayerIndex);
    Alive := False;
  end;
  Result := 0;
end;

procedure ServeClient(Socket: LongInt);
begin
  WriteLn('Open port ', Socket);
  threadParameters.Socket := Socket;
  BeginThread(@ThreadFunction, @threadParameters);
end;

var
  VSocket: LongInt;
  VServer: TTcpIpServerSocket;
begin
  PlayersQty := 0;
  VServer := TTcpIpServerSocket.Create(CONNECTION_PORT);
  repeat
    VServer.Listen;
    VSocket := VServer.Accept;
    if VSocket = -1 then
      continue;
    ServeClient(VSocket);
    WriteLn('Wait for next client');
  until false;
end.

