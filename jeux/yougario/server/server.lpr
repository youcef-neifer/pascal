program server;

{$mode objfpc}{$H+}

uses
  cthreads, TcpIpServer, TcpIpClient, sysutils, Graphics, Classes;

type
  PThreadParameters = ^TThreadParameters;
  TThreadParameters = record
    Socket: LongInt;
  end;
  TPlayer = record
    Alive: Boolean;
    X, Y, Color: Integer;
    Taille: Real;
  end;
  TPlayers = array[1..50] of TPlayer;

const
  CONNECTION_PORT = 4100;

var
  PlayersQty: Integer;
  Players: TPlayers;

function ThreadFunction(parameter: pointer): ptrint;
var
  p: PThreadParameters absolute parameter;
  VData: String = '';
  VSocket,VDataSize: LongInt;
  VClient: TTcpIpClientSocket;
  X, Y, Taille, Color: Integer;
  params: array of string;
  n: Integer;
begin
  WriteLn('Start server ', p^.Socket);
  VSocket := p^.Socket;
  if VSocket = -1 then
    WriteLn('ERROR');
  VClient := TTcpIpClientSocket.Create(VSocket);
  repeat
    try
      if VClient.CanRead(60000) then
      begin
        VDataSize := VClient.Waiting;
        SetLength(VData, VDataSize);
        VClient.Read(VData[1], VDataSize);
        WriteLn('Client says: "', VData, '"');
        WriteLn('len = ', Length(VData));
        if Length(VData) = 0 then begin
          Write(4);
          break;
        end;
        try
          params := Trim(VData).Split(' ');
          VDATA := '';
          case params[0] of
            'JOIN': begin
              PlayersQty += 1;
              with Players[PlayersQty] do begin
                Alive := True;
                X := Random(200);
                Y := Random(200);
                Taille := 27;
                Color := Random(MaxLongint);
                VDATA := format('PLAYER %d %d %d %.15f %d', [PlayersQty, X, Y, Taille, Color]);
              end;
            end;
            'REFRESH':begin
              for n := 1 to PlayersQty do with Players[n] do if Alive then begin
                VDATA += format('PLAYER %d %d %d %.15f %d', [n, X, Y, Taille, Color]) + LineEnding;
              end;
            end;
            'UPDATE': begin
              n := StrToInt(params[1]);
              with Players[n] do begin
                X := StrToInt(params[2]);
                Y := StrToInt(params[3]);
                Taille := StrToFloat(params[4]);
              end;
            end;
            'KILL': begin
              n := StrToInt(params[1]);
              with Players[n] do begin
                WriteLn('Killing player ', n);
                Alive := False;
              end;
            end;
          end;
        except
          VData := 'INVALID:' + VData;
        end;
        if Length(VData) > 0 then begin
          WriteLn('Server answers: "', VDATA, '"');
          VClient.Write(VData[1], Length(VData));
        end;
      end;
    finally
      WriteLn('--Try Next');
    end;
  until false;
  VClient.Free;
  Result := 0;
end;

procedure ServeClient(Socket: LongInt);
var
  parameters: PThreadParameters;
begin
  WriteLn('Open port ', Socket);
  New(parameters);
  parameters^.Socket := Socket;
  BeginThread(@ThreadFunction, parameters);
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

