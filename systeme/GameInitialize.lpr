program GameInitialize;

{$mode objfpc}{$H+}

uses
  cthreads, Sysutils, Classes,
  gl, glu,
  Unit1, Unit2, Event, DrawRect, MathDeYoucef, TestCamera, Load3DObject, Animation;

type
  TProc = procedure; cdecl;

  TProcedure = class
  end;

var
  Form: TBaseWindow;
  FString: array of PChar = ('Rouge', 'Bleu', 'Vert', 'Bleu Clair', 'Orange', 'Tres Bleu');
  Finished: Boolean;
  posMouseX, posMouseY: Integer;

procedure GlKeyBoard(Key: Byte; X, Y: LongInt); cdecl;
begin
    case Key of
    27:begin
      if Form.GamingMode = True then begin
        Form.Destroy;
        Finished := True;
      end else begin
        Form.Destroy;
        Finished := True;
      end;
    end;
  end;
    if Form.Create_Triangle = True then begin
      case Chr(Key) of
        'x': Position[0] += 0.5;
        'X': Position[0] -= 0.5;
        'y': Position[1] += 0.5;
        'Y': Position[1] -= 1;
        'z': Position[2] += 1;
        'Z': Position[2] -= 1;
        'r': gamma += 1;
        'R': gamma -= 1;
      end;
    end;
end;

procedure GlMenuColor(OptionColor: LongInt); cdecl;
begin
  case OptionColor of
    1:begin
      r := 1.0;
      g := 0.0;
      b := 0.0;
      glClearColor(r,g,b, 1.0)
    end;
    2:begin
      r := 0.0;
      g := 0.0;
      b := 1.0;
      glClearColor(r,g,b, 1.0);
    end;
    3:begin
      r := 0.0;
      g := 1.0;
      b := 0.0;
      glClearColor(r,g,b, 1.0);
    end;
    4:begin
      r := 0.0;
      g := 0.5;
      b := 1.0
    end;
    5:begin
      r := 0.9;
      g := 0.5;
      b := 0.2;
    end;
    6:begin
      r := 0.2;
      g := 0.2;
      b := 0.5;
    end;
  end;
    glutPostRedisplay;
end;

procedure Lancement();
begin
  WriteLn('Action Réussi !');
end;

procedure GLMousePressed(button, state, X, Y: LongInt); cdecl;
begin
   if button = GLUT_LEFT_BUTTON then begin
     Form.EnvoiEvent;
     Form.Event.Action := @Lancement;
   end;
end;

procedure MyRender; cdecl;
begin
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
  glClearColor(r,g,b, 1.0);

  glLoadIdentity;
  glEnable(GL_LIGHTING);
  glLightfv(GL_LIGHT0, GL_SPOT_CUTOFF, DiffuseLight);
  glEnable(GL_LIGHT0);

//  Form.Component := TMenu.Create;

  glLoadIdentity;
  glBindTexture(GL_TEXTURE_2D, GL_NONE);
//  glTranslatef(dx, dy, dz);
  glRotatef(alpha, 1, 0, 1);
  glCallList(Ord(TEX_OBJECT));
end;

function MoveCamera(P: Pointer): ptrInt;
var
  X, Y, AvantX, AvantY: Double;
begin
  EnterCriticalSection(cs);
  AvantX := Double(posMouseX);
  AvantY := Double(posMouseY);
  LeaveCriticalSection(cs);
  repeat
    EnterCriticalSection(cs);
    X := Double(posMouseX);
    Y := Double(posMouseY);
    if AvantX > X then Form.Camera.MoveMouse.Distance := AvantX - X;
    if AvantX < X then Form.Camera.MoveMouse.Distance := X - AvantX;
    if AvantY > Y then Form.Camera.MoveMouse.Distance := AvantY - Y;
    if AvantY < Y then Form.Camera.MoveMouse.Distance := Y - AvantY;
    if (AvantX <> X) or (AvantY <> Y) then begin
      Form.Camera.MoveMouse.IsInMoveMouse := True;
      if AvantX > X then Form.Camera.MoveMouse.Left := True;
      if AvantX < X then Form.Camera.MoveMouse.Rigth := True;
      if AvantY > Y then Form.Camera.MoveMouse.Bottom := True;
      if AvantY < Y then Form.Camera.MoveMouse.Top := True;
      Form.Camera.Move;
    end;
    AvantX := Double(posMouseX);
    AvantY := Double(posMouseY);
    LeaveCriticalSection(cs);
    Sleep(100);
  until Finished;
    EnterCriticalSection(cs);
    DoneCriticalSection(cs);
end;

procedure Test(v1, v2, v3: Integer); cdecl;
begin
  //if v1 = GLUT_KEY_DOWN then dz += 0.1;
  //if v1 = GLUT_KEY_UP then dz -= 0.1;
  //if v1 = GLUT_KEY_LEFT then dx -= 0.1;
  //if v1 = GLUT_KEY_RIGHT then dx += 0.1;
end;

procedure MousePosition(v1, v2: Integer); cdecl;
begin
  posMouseX := v1;
  posMouseY := v2;
end;

var
  Object3D: TVaisseau;
begin
  InitCriticalSection(cs);
  r := 0.0;
  g := 0.0;
  b := 0.0;
  Form := TBaseWindow.Create();
  Form.NameFenetre := 'My new Window';
  Form.GamingMode := False;
  Form.WINDOW_SIZE_HEIGHT := 600;
  Form.WINDOW_SIZE_WIDTH := 800;
  Form.Create_Triangle := True;
  Form.CreateWindow();
  BeginThread(@MoveCamera, nil);
  Object3D := TVaisseau.Create;
  glutDisplayFunc(@RenderSceneCB);
  glutIdleFunc(@RenderSceneCB);
  glutReshapeFunc(@ReSizeGLScene);
  Form.Component := TPopMenu.Create;
  if Form.Component is TPopMenu then with Form.Component as TPopMenu do begin
    AddNewMenu(@GlMenuColor, FString, 'Color');
  end;
  glutMouseFunc(@GLMousePressed);
  glutSetCursor(GLUT_CURSOR_CROSSHAIR);
  glutKeyboardFunc(@GlKeyBoard);
  glutSpecialFunc(@Test);
  glutPassiveMotionFunc(@Mouseposition);

  Form.affiche();
end.
