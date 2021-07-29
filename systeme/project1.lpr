program project1;

uses gl, glu, Unit1, Unit2;//, ImagingDeVampireYoucef;

procedure GLMousePressed(button, state, X, Y: LongInt); cdecl;
begin
   if button = GLUT_LEFT_BUTTON then begin
      r += 0.1;
      glClearColor(r, g, b, 1.0);
      WriteLn('Rouge : ', r);
      WriteLn('Bleu : ', b);
      WriteLn('Vert : ', g);
      WriteLn('---------------');
   end;
   if button = GLUT_MIDDLE_BUTTON then begin
      g += 0.1;
      glClearColor(r, g, b, 1.0);
      WriteLn('Rouge : ', r);
      WriteLn('Bleu : ', b);
      WriteLn('Vert : ', g);
      WriteLn('---------------');
   end;
   if button = GLUT_RIGHT_BUTTON then begin
      b += 0.1;
      glClearColor(r, g, b, 1.0);
      WriteLn('Rouge : ', r);
      WriteLn('Bleu : ', b);
      WriteLn('Vert : ', g);
      WriteLn('---------------');
   end;
end;

procedure GlKeyBoard(Key: Byte; X, Y: LongInt); cdecl;
var
  i: Integer;
begin
   i := 0;
    case Key of
    27:begin
      if Form.GamingMode = True then begin
        glutLeaveGameMode;
      end else begin
        glutDestroyWindow(win);
      end;
    end;
  end;
    if Form.Create_Triangle = True then begin
      if Key = Ord('x') then dx += 0.2;
      if Key = Ord('X') then dx -= 0.2;
      if Key = Ord('y') then dy += 0.2;
      if Key = Ord('Y') then dy -= 0.2;
      if Key = Ord('z') then dz += 0.2;
      if Key = Ord('Z') then dz -= 0.2;
      if Key = 9 then dx += 0.5;
      if key = Ord('f') then begin
        if i = 1 then begin
          glutIconifyWindow;
          i := 0;
          Exit;
        end;
        glutFullScreen;
        i := 1;
      end;
    end;
end;

begin
  r := 1.0;
  g := 1.0;
  b := 1.0;
  Form := TBaseWindow.Create;
  Form.Name := 'My new Window';
  Form.Window_Size_Height := 600;
  Form.Window_Size_Width := 800;
  Form.GamingMode := False;
  Form.Create_Triangle := True;
  Form.Visible := True;
  Form.CreateWindow;
  Form.affiche;
  glutSetCursor(GLUT_CURSOR_CROSSHAIR);
  glutKeyboardFunc(@GlKeyBoard);
//  glutMouseFunc(@GLMousePressed);
  glutMainLoop;
end.
