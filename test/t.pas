program t;

uses
  cthreads, Sysutils, Classes, Unit2, MathDeYoucef, Unit1;

var
  Form: TBaseWindow;
  //textarea: TTextArea;
  button1: TButton;
  MainMenu: TMainMenu;
  Menu: TMenu;

procedure KeyBoard(Key: Byte; X, Y: LongInt); cdecl;
begin
  //textarea.Text(Key);
  if Key = 27 then Form.Destroy();
end;

procedure Test;
begin
  Form.Destroy();
end;

procedure Test2;
begin
  Form.Color := Color_Orange;
end;

procedure Test3;
begin
  Form.Name := 'Huuhu';
end;

var
  PosMouseX, PosMouseY: LongInt;
  compt: Integer = 2;
  compt2: Integer = 2;

procedure Mouse(button, state: LongInt; X, Y: LongInt); cdecl;
begin
  if (button = GLUT_LEFT_BUTTON) then begin
        if Menu.PosMenu(PosMouseX, PosMouseY, 1) then begin
          if compt = 2 then begin
            Menu.AddItem(1, 1);
            Menu.AddItem(1, 2);
            compt += 1;
            Exit;
          end;
          if (compt >= 5) then begin
            compt := 1;
            Menu.RemoveItem(1, 1);
            Menu.RemoveItem(1, 2);
         end;
          compt += 1;
        end else if Menu.PosItem(PosMouseX, PosMouseY, 1, 1) then begin
         if Menu.IsDrawItem(1, 1) then begin
         Menu.EnvoiEvent;
         Menu.Event.Action := @Test2;
         Menu.RemoveItem(1, 1);
         Menu.RemoveItem(1, 2);
         compt := 2;
         end;
         end else if Menu.PosItem(PosMouseX, PosMouseY, 1, 2) then begin
         if Menu.IsDrawItem(1, 1) then begin
         Menu.EnvoiEvent;
         Menu.Event.Action := @Test;
         Menu.RemoveItem(1, 1);
         Menu.RemoveItem(1, 2);
         compt := 2;
         end;
       end else begin
         Menu.RemoveItem(1, 1);
         Menu.RemoveItem(1, 2);
         compt := 2;
       end;
       if Menu.PosMenu(PosMouseX, PosMouseY, 2) then begin
            if compt2 = 2 then begin
              Menu.AddItem(2, 1);
              Menu.AddItem(2, 2);
              compt2 += 1;
              Exit;
            end;
            if (compt2 >= 5) then begin
              compt2 := 1;
              Menu.RemoveItem(2, 1);
              Menu.RemoveItem(2, 2);
           end;
            compt2 += 1;
       end else if Menu.PosItem(PosMouseX, PosMouseY, 2, 1) then begin
         Menu.EnvoiEvent;
         Menu.Event.Action := @Test3;
         Menu.RemoveItem(2, 1);
         Menu.RemoveItem(2, 2);
         compt2 := 2;
       end else begin
         Menu.RemoveItem(2, 1);
         Menu.RemoveItem(2, 2);
         compt2 := 2;
       end;
  end;
end;


procedure MousePos(x, y: LongInt); cdecl;
begin
  PosMouseX := x;
  PosMouseY := y;
end;

begin
  Form := TBaseWindow.Create();
  Form.Create_Point := False;
  Form.Create_Triangle := False;
  Form.WINDOW_SIZE_HEIGHT := 600;
  Form.WINDOW_SIZE_WIDTH := 800;
  Form.Color := Color_GrayForm;
  //textarea := TTextArea.Create(200, 200, 200, 240);
  //button1 := TButton.Create(300, 500, 150, 70);
  //button1.Visible := True;
  //button1.Caption := 'Button1';
  MainMenu := TMainMenu.Create;
  MainMenu.Visible := True;
  Menu := TMenu.Create;
  Menu.Visible := True;
  Menu.AddMenu;
  Form.CreateWindow();
  glutMouseFunc(@Mouse);
  glutKeyboardFunc(@KeyBoard);
  glutPassiveMotionFunc(@MousePos);
  Form.affiche();
end.

