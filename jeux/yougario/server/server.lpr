program server;

{$mode objfpc}{$H+}

uses
  cthreads, BaseUnix, lCommon, lNet, lnetbase, sysutils, Graphics, Classes;

const
  MaxPlayersQty = 50;
  MaxMiettesQty = 300;
  WindowWidth = 1280;
  WindowHight = 1024;

type
  TBoule = record
    Alive: Boolean;
    X, Y, Color: Integer;
    Taille: Real;
  end;

  TMiette = TBoule;

  TPlayer = record
    SocketPtr: Pointer;
    Boules: array[1..16] of TBoule;
  end;
  TPlayers = array[1..MaxPlayersQty] of TPlayer;
  TMiettes = array[1..MaxMiettesQty] of TMiette;

  { TConnectionSocket }

  TConnectionSocket = class(TLTcp)
    procedure HandleAccept(Socket: TLSocket);
    procedure HandleDisconnect(Socket: TLSocket);
    procedure HandleReceive(Socket: TLSocket);
  end;

const
  CONNECTION_PORT = 4100;

var
  PlayersQty: Integer;
  MiettesQTY: Integer;
  Players: TPlayers;
  Miettes: TMiettes;
  Quit: Boolean;

{ TConnectionSocket }

procedure TConnectionSocket.HandleAccept(Socket: TLSocket);
begin
  WriteLn('Accepted connection for ', Socket.Handle);
end;

procedure TConnectionSocket.HandleDisconnect(Socket: TLSocket);
var
  n: Integer;
begin
  for n := Low(Players) to High(Players) do with Players[n] do begin
    if SocketPtr = Pointer(Socket) then begin
      SocketPtr := nil;
      WriteLn('Killed player ', n);
      Break;
    end;
  end;
end;

procedure TConnectionSocket.HandleReceive(Socket: TLSocket);
var
  VData: string;
  VDataSize: LongInt;
  params: array of string;
  n, i: Integer;
  Data: string;
  lines: array of string;
  paramsIndex, BouleIndex: Integer;
begin
  MiettesQTY := Length(Miettes);
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
      VDataSize := 0;
      VDataSize := Socket.GetMessage(VData);
      WriteLn('Data size = ', VDataSize);
      if VDataSize > 0 then begin
        WriteLn('Client says: "', VData, '"');
        WriteLn('len = ', Length(VData));
        lines := Trim(VData).Split(LineEnding);
        for Data in lines do try
          params := Trim(Data).Split(' ');
          VDATA := '';
          case params[0] of
            'JOIN': begin
              PlayersQty += 1;
              with Players[PlayersQty], Boules[1] do begin
                SocketPtr := Socket;
                X := Random(200);
                Y := Random(200);
                Taille := 27;
                Color := Random(MaxLongint);
                VDATA := format('PLAYER %d %d %d %.15f %d', [PlayersQty, X, Y, Taille, Color]);
              end;
            end;
            'REFRESH':begin
              for n := 1 to PlayersQty do with Players[n].Boules[1] do if Assigned(Players[n].SocketPtr) then begin
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
                    SocketPtr := nil;
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
          Socket.SendMessage(VData);
        end;
      end;
    finally
      WriteLn('--Try Next');
    end;
end;

procedure QuitCleanly(sig : cint);cdecl;
begin
  Quit := True;
  WriteLn('Received signal = ', sig);
end;

var
  ServerSocket: TConnectionSocket;

begin
  PlayersQty := 0;
  Quit := False;
  fpSignal(SIGINT, @QuitCleanly);
  ServerSocket := TConnectionSocket.Create(nil);
  with ServerSocket do begin
    SocketNet := LAF_INET6;
    Timeout := -1;
    OnAccept := @HandleAccept;
    OnDisconnect := @HandleDisconnect;
    OnReceive := @HandleReceive;
  end;
  if ServerSocket.Listen(CONNECTION_PORT, LADDR6_ANY) then begin
    WriteLn('Listen detected a connection handle = ', ServerSocket.Socks[0].Handle);
    try
      repeat
        ServerSocket.CallAction;
        WriteLn('Wait for next client');
      until Quit;
    except
      WriteLn('Some Error!!!!!');
    end;
  end else begin
    WriteLn('Some error ocurred!');
  end;
  ServerSocket.Free;
  WriteLn('Bye');
end.

