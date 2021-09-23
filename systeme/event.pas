unit Event;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

    TEvent = procedure;

    { TEventListener }

    TEventListener = class
    public
      procedure GetAction(Event: TEvent);
      procedure ReceiveRequest(const Name: String);
    private
      IsForm: Boolean;
      IsComponent: Boolean;
      FAction: TEvent;
      procedure SetAction(Event: TEvent);
      procedure Error;
    public
      property Action: TEvent read FAction write SetAction;
    end;

implementation


{ TEventListener }

procedure TEventListener.GetAction(Event: TEvent);
begin
  FAction := Event;
end;

procedure TEventListener.ReceiveRequest(const Name: String);
begin
  if Name.Contains('TBaseWindow') then begin
    Self.IsForm := True;
    Self.IsComponent := False;
  end;
  if Name.Contains('TComponent') then begin
    Self.IsComponent := True;
    Self.IsForm := False;
  end;
  if Name.Contains('TButton') then begin
    Self.IsComponent := True;
    Self.IsForm := False;
  end;
end;

procedure TEventListener.SetAction(Event: TEvent);
begin
    try
      Self.Error;
      Event;
    except
    on E: Exception do begin
      WriteLn(E.Message);
    end;
  end;
end;

procedure TEventListener.Error;
begin
   if (Self.IsForm = True) and (Self.IsComponent = True) then begin
     raise Exception.Create('Error, this action cannot execute action with Component and Form.');
   end;
  if (Self.IsForm = False) and (Self.IsComponent = False) then begin
    raise Exception.Create('Error, you cannot execute action without Component or Form.');
  end;
end;

end.

