{$MACRO ON}
{$MODE Delphi}
{$IFDEF Windows}
  {$DEFINE extdecl := stdcall}
{$ELSE}
  {$DEFINE extdecl := cdecl}
{$ENDIF}

unit Unit2;

interface

uses
  Classes, SysUtils, glut, gl, glu, Event, DrawRect, MathDeYoucef, TestCamera, Load3DObject;

const
  Color_Black: TColor = (0.0, 0.0, 0.0);
  Color_White: TColor = (1.0, 1.0, 1.0);
  Color_Red: TColor = (1.0, 0.0, 0.0);
  Color_Green: TColor = (0.0, 1.0, 0.0);
  Color_Blue: TColor = (0.0, 0.0, 1.0);
  Color_Yellow: TColor = (1.0, 1.0, 0.0);
  Color_Orange: TColor = (1.0, 0.5, 0.0);
  Color_Cyan: TColor = (0.0, 1.0, 1.0);
  Color_Magenta: TColor = (1.0, 0.0, 1.0);
  Color_OldGold: TColor = (0.81, 0.71, 0.23);
  Color_Bronze: TColor = (0.55, 0.47, 0.14);
  Color_GrayForm: TColor = (1.0 * 0.7, 1.0 * 0.7, 1.0 * 0.7);

type

    TAddMenuProc = procedure(Option: LongInt); extdecl;

    OptionItem = record
      Event: TEventListener;
      Nb: Integer;
      IsNotNull: Boolean;
      X: LongInt;
      Y: LongInt;
    end;

    OptionMenu = record
      Item: array[1..100] of OptionItem;
      IsNotNull: Boolean;
      X: LongInt;
      Y: LongInt;
    end;
  { TComponent }

  TComponentMe = class
      Name: String;
      Event: TEventListener;
      procedure EnvoiEvent;
      Constructor Create;
    private
      FVisible: Boolean;
      const UnitName = 'TComponent';
    public
      property Visible: Boolean read FVisible write FVisible;
  end;


  { TMainMenu }

  TMainMenu = class(TComponentMe)
    public
      constructor Create;
    private
      procedure Draw;
  end;

  { TMenu }

  TMenu = class(TMainMenu)
        MainMenu: TMainMenu;
        Constructor Create;
        Destructor Destroy;
        procedure AddMenu;
        function PosMenu(PosMouseX, PosMouseY: LongInt; nbMenu: LongInt): Boolean;
        function PosItem(PosMouseX, PosMouseY: LongInt; nbMenu, nbItem: LongInt): Boolean;
        procedure AddItem(NbMenu, NbItem: Integer);
        procedure RemoveItem(NbMenu, NBItem: Integer);
      private
        nbMenu: array[1..100] of OptionMenu;
        i: Integer;
        x: LongInt;
        procedure Draw;
        procedure DrawItem(X, Y: LongInt);
      public
        function IsDrawItem(nbMenu: LongInt; nbItem: LongInt): Boolean;
   end;

  { TPopMenu }

  TPopMenu = class(TComponentMe)
    public
      procedure AddNewMenu(proc: TAddMenuProc; SubMenu: array of PChar; Menu: PChar);
      constructor Create;
  end;

  { TButton }

  TButton = class(TComponentMe)
    Constructor Create(PosX, PosY: LongInt; Width, Heigth: LongInt);
    function IsPositionButton(PosMouseX, PosMouseY: LongInt): Boolean;
  private
    Coord: record
      X: LongInt;
      Y: LongInt;
      Width: Integer;
      Heigth: Integer;
    end;
    FCaption: String;
    const UnitName = 'TButton';
    procedure Draw(PosX, PosY: LongInt; Width, Heigth: LongInt);
    procedure DrawCaption(args: String);
  public
    property Caption: String read FCaption write FCaption;
  end;

  { TTextArea }

  TTextArea = class(TComponentMe)
  N: Integer;
  procedure Text(Key: Byte);
  procedure Execute;
  procedure Move(touche: LongInt);
  Constructor Create(PosX, PosY: LongInt; cologne, lignes: LongInt);
  private
    Coord: record
      X: LongInt;
      Y: LongInt;
      Width: Integer;
      Heigth: Integer;
    end;
    CursorWrite: record
      Position: TVector2D;
      cc: Integer;
      Form: Char;
    end;
    IsCreate: Boolean;
    Mot: TStringArray;
    ligne: Integer;
    col: Integer;
    IsWrite: Boolean;
    procedure Write(args: String);
    procedure DeleteMot(PosMot: Integer);
    procedure Draw(PosX, PosY: LongInt; Width, Heigth: LongInt);
    function LimiteX(PosX: LongInt): Boolean;
    function LimiteY(PosY: LongInt): Boolean;
  public
    procedure LireTextInArea;
    property TextinArea: TStringArray read Mot;
  end;

    { TBaseWindow }

  TBaseWindow = class(TComponent)
  public
  WINDOW_SIZE_HEIGHT: LongInt;
  WINDOW_SIZE_WIDTH: LongInt;
  GamingMode: Boolean;
  Create_Triangle: Boolean;
  Create_Point: Boolean;
  Event: TEventListener;
  Component: TComponentMe;
  Camera: TCamera;
  PositionPoint: Record
    X: Double;
    Y: Double;
    Z: Double;
  end;
  procedure EnvoiEvent();
  procedure ChangePoint();
  private
  FName: String;
  FVisible: Boolean;
  FVersion: String;
  FColor: TColor;
  HaveglutInit: Boolean;
  const UnitName = 'TBaseWindow';
  procedure SetColor(AValue: TColor);
  procedure SetTheName(Name: String);
  procedure SetVisible(Visible: Boolean);
  procedure CreateList;
  public
  procedure CreateWindow();
  procedure affiche();
  constructor Create();
  Destructor Destroy();
  public
  property Color: TColor read FColor write SetColor;
  property Name: String read FName write SetTheName;
  property Visible: Boolean read FVisible write SetVisible default False;
  property Version : String read FVersion;
  end;

  TTBaseWindow = class of TBaseWindow;

  { TObject }

  TVaisseau = class
    constructor Create;
  end;

  TTextures = (
    TEX_NONE,
    TEX_SKY,
    TEX_LIGHT,
    TEX_BACKGROUND,
    TEX_OBJECT
  );

const
  DiffuseLight: array[0..3] of GLfloat = (0.2, 0.4, 0.8, 0.1);
var
  alpha: Real = 0;
  beta: Real = 0;
  gamma: Real = 0;
  Texture:array[TEX_SKY..TEX_BACKGROUND] of GLuint;
  milieu, haut: Integer;
  win: Integer;
  instensity: GLfloat = 100;
const
    position: array[0..3] of GLfloat = (0, 0, 20, 0.0);
    coloroflight: array[0..3] of GLfloat = (255, 255, 255, 0.0);

var
  EventListener: TEventListener;

procedure glEnter2D;
procedure glLeave2D;
procedure RenderSceneCB; cdecl;
procedure ReSizeGLScene(Width, Height: Integer); cdecl;
procedure display; cdecl;
procedure Register;
function glGetViewportHeight: Integer;
function glGetViewportWidth: Integer;
implementation

var
  TextArea: array of TTextArea;
  Button: array of TButton;
  MainMenu: array of TMainMenu;
  Menu: array of TMenu;
  ColorForm: TColor;

procedure Register;
begin
  RegisterComponents('Window',[TBaseWindow]);
end;

{ TMainMenu }

constructor TMainMenu.Create;
begin
  Self.Event := TEventListener.Create;
  Insert(Self, MainMenu, 0);
end;


procedure TMainMenu.Draw;
begin
  glColor3f (0.0, 0.0, 0.0);
  glBegin(GL_POLYGON);
  glVertex2i (800, 600);
  glVertex2i (0, 600);
  glVertex2i (0, 560);
  glVertex2i (800, 560);
  glEnd();
end;

{ TButton }

constructor TButton.Create(PosX, PosY: LongInt; Width, Heigth: LongInt);
begin
  Self.Coord.X := PosX;
  Self.Coord.Y := PosY;
  Self.Coord.Width := Width;
  Self.Coord.Heigth := Heigth;
  Insert(Self, Button, 0);
  Self.Event := TEventListener.Create;
end;

function TButton.IsPositionButton(PosMouseX, PosMouseY: LongInt): Boolean;
begin
  if (PosMouseX < Self.Coord.X + Self.Coord.Width div 2) and (PosMouseX > Self.Coord.X - Self.Coord.Width div 2) and (PosMouseY < 600 - Self.Coord.Y + Self.Coord.Heigth div 2) and (PosMouseY > 600 - Self.Coord.Y - Self.Coord.Heigth div 2) then begin
    Result := True;
    Exit;
  end;
  Result := False;
end;

procedure TButton.Draw(PosX, PosY: LongInt; Width, Heigth: LongInt);
begin
  glColor3f (0.4, 0.4, 1.0);
  glBegin(GL_POLYGON);
  glVertex2i (PosX - Width div 2, PosY + Heigth div 2);
  glVertex2i (PosX + Width div 2, PosY + Heigth div 2);
  glVertex2i (PosX + Width div 2, PosY - Heigth div 2);
  glVertex2i (PosX - Width div 2, PosY - Heigth div 2);
  glEnd();
end;

procedure TButton.DrawCaption(args: String);
var
  S: String;
begin
  S := args;
  glColor3f(0.0, 0.0, 0.0);
  glWrite(Self.Coord.X - Length(S) * 4 - 5, Self.Coord.Y - 5, GLUT_BITMAP_HELVETICA_18, S);
end;

{ TTextArea }

procedure TTextArea.Text(Key: Byte);
var
  i, j, u, lenght: Integer;
  c: Char;
begin
  c := Chr(key);
    case c of
      #27: begin
        glutDestroyWindow(win);
      end;
      #13: begin
        ligne += 1;
        u := col;
        col := 1;
        lenght := Length(Self.Mot[N]);
        for j := u to lenght do begin
          Self.Write(Mot[N][j]);
          col += 1;
        end;
        for j := u to lenght do begin
          WriteLn(u);
          WriteLn(Mot[N][j]);
          Delete(Mot[N], u, 1);
        end;
        N += 1;
      end;
      #8: begin
        if (IsEmpty(Self.Mot[N])) and (N > 1) then begin
          N -= 1;
          ligne -= 1;
          col := length(Mot[N]) + 1;
        end else begin
          Self.DeleteMot(col - 1);
          col -= 1;
        end;
      end;
      #127: begin
      end;
      #32, #34,   '0'..'9', 'A'..'Z', 'a'..'z', #44, #39, #46, #232, #224, #233, #64, #33, #63, #59, #58, #231, #40, #41, #123, #125, #91, #93, #176, #43, #61, #45, #42, #47, #37, #249: begin
        IsWrite := True;
        Self.Write(c);
        col += 1;
      end;
      #9: begin
        IsWrite := True;
        Self.Write('   ');
        col += 3;
      end else begin
        Self.Write('#' + inttostr(key));
        IsWrite := True;
      end;
  end;
end;

procedure TTextArea.Execute;
var
  i, t, comp: LongInt;
  Nb: LongInt = 0;
  acc: LongInt = 0;
  Z, S: String;
begin
  if Self.LimiteY(Self.CursorWrite.Position.y) then begin
    Self.DeleteMot(1);
    Self.Text(8);
    WriteLn('Impossible Write');
  end;
  if Self.LimiteX(Self.CursorWrite.Position.x) then begin
    i := Self.N;
    t := Length(Self.Mot[i]);
    Z := Self.Mot[i][t];
    Self.Text(13);
    Delete(Self.Mot[i], t, 1);
    Self.Write(Z);
    Self.col += 1;
    Self.IsWrite := False;
  end else begin
    Self.CursorWrite.cc += 1;
    if (Self.CursorWrite.cc >= 500) and (Self.IsWrite = False) then begin
      Self.CursorWrite.cc := 0;
      if Self.CursorWrite.Form = ' ' then begin
        Self.CursorWrite.Form := '|';
      end else begin
        Self.CursorWrite.Form := ' ';
      end;
    end else if Self.IsWrite = True then Self.CursorWrite.Form := '|';
      with Self do begin
        for i := 1 to N do begin
          glColor3f(0.0, 0.0, 0.0);
          S := Mot[i];
          if i = ligne then begin
            Insert(Self.CursorWrite.Form, S, col);
          end;
           glWrite(Coord.X - Coord.Width div 2, Coord.Y + Coord.Heigth div 2 - 20 - Nb, GLUT_BITMAP_TIMES_ROMAN_24, S);
           Nb += 20;
        end;
        Self.IsWrite := False;
        for comp := Low(S) to High(S) do acc += glutBitmapWidth(GLUT_BITMAP_TIMES_ROMAN_24, Integer(S[comp]));
        Self.CursorWrite.Position.x := acc;
        Self.CursorWrite.Position.y := Coord.Y + Coord.Heigth div 2 - 20 - Nb + 20;
      end;
  end;
end;

procedure TTextArea.Move(touche: LongInt);
begin
  if Self.FVisible then begin
    if touche = GLUT_KEY_DOWN then begin
      if ligne <> N then begin
        ligne += 1;
        if col > Length(Mot[ligne]) then col := Length(Mot[ligne]) + 1;
      end;
    end;
    if touche = GLUT_KEY_UP then begin
      if ligne <> 1 then begin
        ligne -= 1;
        if col > Length(Mot[ligne]) then col := Length(Mot[ligne]) + 1;
      end;
    end;
    if touche = GLUT_KEY_LEFT then begin
      if col <> 1 then col -= 1;
    end;
    if touche = GLUT_KEY_RIGHT then begin
      if col < Length(Self.Mot[ligne]) + 1 then col += 1;
    end;
  end;
end;

procedure TTextArea.Write(args: String);
begin
  Insert(args, Mot[ligne], col);
end;

procedure TTextArea.DeleteMot(PosMot: Integer);
begin
  Delete(Mot[ligne], PosMot, 1);
end;

procedure TTextArea.Draw(PosX, PosY: LongInt; Width, Heigth: LongInt);
begin
  glColor3f (1.0, 1.0, 1.0);
  glBegin(GL_POLYGON);
  glVertex2i (PosX - Width div 2, PosY + Heigth div 2);
  glVertex2i (PosX + Width div 2, PosY + Heigth div 2);
  glVertex2i (PosX + Width div 2, PosY - Heigth div 2);
  glVertex2i (PosX - Width div 2, PosY - Heigth div 2);
  glEnd();
end;

function TTextArea.LimiteX(PosX: LongInt): Boolean;
begin
  if (PosX >= Self.Coord.Width - 10) and (Self.IsWrite = True) then begin
    Result := True;
    Exit;
  end;
  Result := False;
end;

function TTextArea.LimiteY(PosY: LongInt): Boolean;
begin
  Self.CursorWrite.Position.y := PosY;
  if Self.CursorWrite.Position.y = Self.Coord.Y + Self.Coord.Heigth div 2 - 20 - Self.Coord.Heigth then begin
    Result := True;
    Exit;
  end;
  Result := False;
end;

procedure TTextArea.LireTextInArea;
var
  i, j: LongInt;
begin
  for i := 0 to High(Self.Mot) do begin
    for j := 0 to High(Self.Mot[i]) do begin
      WriteLn(Self.Mot[i][j]);
    end;
  end;
end;

constructor TTextArea.Create(PosX, PosY: LongInt; cologne, lignes: LongInt);
begin
  Self.CursorWrite.Form := '|';
  Self.CursorWrite.cc := 0;
  Self.CursorWrite.Position.x := 0;
  Self.CursorWrite.Position.y := 0;
  Self.Coord.Heigth := lignes;
  Self.Coord.Width := cologne;
  Self.Coord.X := PosX;
  Self.Coord.Y := PosY;
  Self.IsCreate := True;
  N := 1;
  col := 1;
  ligne := 1;
  Insert(Self, TextArea, 0);
  Self.Visible := True;
end;

{ TObject }

constructor TVaisseau.Create;
begin
  LoadObject3DFile('animation2_000001');
end;

{ TMenu }

constructor TMenu.Create;
begin
  Self.Event := TEventListener.Create;
  Self.nbMenu[1].IsNotNull := True;
  x := 20;
  Insert(Self, Menu, 0);
  i := 1;
  Self.nbMenu[1].Item[1].X := Self.x;
  Self.nbMenu[1].Item[1].Y := 570;
end;

destructor TMenu.Destroy;
begin
  inherited;
end;

procedure TMenu.AddMenu;
begin
  i += 1;
  Self.NbMenu[i].IsNotNull := True;
end;

function TMenu.PosMenu(PosMouseX, PosMouseY: LongInt; nbMenu: LongInt): Boolean;
begin
  if (PosMouseX < Self.nbMenu[nbMenu].X + 30) and (PosMouseX > Self.nbMenu[nbMenu].X) and (PosMouseY > 10) and (PosMouseY < 30) then begin
    Result := True;
    Exit;
  end;
  Result := False;
end;

function TMenu.PosItem(PosMouseX, PosMouseY: LongInt; nbMenu, nbItem: LongInt
  ): Boolean;
begin
  if (PosMouseX < Self.nbMenu[nbMenu].Item[nbItem].X + 50) and (PosMouseX > Self.nbMenu[nbMenu].Item[nbItem].X) and (PosMouseY < 600 - (Self.nbMenu[nbMenu].Item[nbItem].Y - 20)) and (PosMouseY > 30) then begin
    Result := True;
    Exit;
  end;
  Result := False;
end;

procedure TMenu.AddItem(NbMenu, NbItem: Integer);
begin
  Self.nbMenu[NbMenu].Item[NbItem].IsNotNull := True;
end;

procedure TMenu.RemoveItem(NbMenu, NBItem: Integer);
begin
  Self.nbMenu[NbMenu].Item[NBItem].IsNotNull := False;
end;

procedure TMenu.Draw;
begin
  glColor3f (1.0, 1.0, 1.0);
  glBegin(GL_POLYGON);
  glVertex2i (Self.x, 590);
  glVertex2i (Self.x + 30, 590);
  glVertex2i (Self.x + 30, 570);
  glVertex2i (Self.x, 570);
  glEnd();
end;

procedure TMenu.DrawItem(X, Y: LongInt);
begin
  glColor3f (1.0, 1.0, 1.0);
  glBegin(GL_POLYGON);
  glVertex2i (X, Y);
  glVertex2i (X + 50, Y);
  glVertex2i (X + 50, Y - 20);
  glVertex2i (X, Y - 20);
  glEnd();
end;

function TMenu.IsDrawItem(nbMenu: LongInt; nbItem: LongInt): Boolean;
begin
  if Self.nbMenu[nbMenu].Item[nbItem].IsNotNull then begin
    Result := True;
    Exit;
  end;
  Result := False;
end;

{ TComponent }

procedure TComponentMe.EnvoiEvent;
begin
  Self.Event.ReceiveRequest(Self.UnitName);
end;

constructor TComponentMe.Create;
begin
  Self := TPopMenu.Create;
end;

{ TBaseWindow }

procedure TBaseWindow.CreateWindow();
var
  argc: Integer = 0;
  argv: PPChar = nil;
begin
  if Self.Name = '' then Self.Name := 'untitled';
  Self.HaveglutInit := True;
  Self.PositionPoint.X := 0;
  Self.PositionPoint.Y := 0.5;
  Self.PositionPoint.Z := 0;
  glutInit(@argc, argv);
  glutInitDisplayMode(GLUT_SINGLE or GLUT_RGB);
  glutInitWindowSize(Self.Window_Size_Width, Self.Window_Size_Height);
  glutInitWindowPosition(100, 100);
  if Self.GamingMode = False then win := glutCreateWindow(PChar(Self.Name)) else glutEnterGameMode;

  Self.CreateList;

  glutDisplayFunc(@RenderSceneCB);
  glutIdleFunc(@RenderSceneCB);
  glutReshapeFunc(@ReSizeGLScene);
end;

procedure TBaseWindow.affiche();
begin
  glutMainLoop;
end;

procedure TPopMenu.AddNewMenu(proc: TAddMenuProc; SubMenu: array of PChar;
  Menu: PChar); {The array of PChar is for the caption of the subMenu}
var
  sub1 : LongInt;
  i, g: Integer;
  c: PChar;
begin
  g := -1;
  sub1 := glutCreateMenu(@proc);
  for i := 1 to Length(SubMenu) do begin
    g += 1;
    c := SubMenu[0 + g];
    glutAddMenuEntry(c, i);
  end;
  glutCreateMenu(@proc);
  glutAddSubMenu(Menu, sub1);
  glutAttachMenu(GLUT_RIGHT_BUTTON);
end;

constructor TPopMenu.Create;
begin
end;

constructor TBaseWindow.Create(); {When the class create}
begin
  inherited;
  Self.FVersion := '0.0.0.3';
  Self.Event := TEventListener.Create;
  Self.Camera := TCamera.Create(Self.Window_Size_Width, Self.Window_Size_Height);
  WriteLn('Version : ', Self.Version);
end;


destructor TBaseWindow.Destroy(); {the destructor destroy the load object and the window}
begin
  inherited;
  //Self.Component.Destroy;
  Destroy3DObject(LongWord(LIST_OBJECT), 2);
  if win = 0 then glutLeaveGameMode else glutDestroyWindow(win);
end;

procedure display;  cdecl;
begin
  glClearColor(0.0,0.0,0.0,0.0);
  glutWireTeapot(0.5);
  glFlush;
end;

function glGetViewportWidth: Integer;
var
  Rect: array[0..3] of Integer;
begin
  glGetIntegerv(GL_VIEWPORT, @Rect);
  Result := Rect[2] - Rect[0];
end;

function glGetViewportHeight: Integer;
var
  Rect: array[0..3] of Integer;
begin
  glGetIntegerv(GL_VIEWPORT, @Rect);
  Result := Rect[3] - Rect[1];
end;

procedure glEnter2D; {This procedure is for enter in 2D for write word for the Component TextArea or Edit}
begin
  glMatrixMode(GL_PROJECTION);
  glPushMatrix;
  glLoadIdentity;
  gluOrtho2D(0, glGetViewportWidth, 0, glGetViewportHeight);

  glMatrixMode(GL_MODELVIEW);
  glPushMatrix;
  glLoadIdentity;

  glDisable(GL_DEPTH_TEST);
end;

procedure glLeave2D; {This procedure is for leave the 2D for can load object}
begin
  glMatrixMode(GL_PROJECTION);
  glPopMatrix;
  glMatrixMode(GL_MODELVIEW);
  glPopMatrix;

  glEnable(GL_DEPTH_TEST);
end;

var
  y: LongInt = 570;
procedure RenderSceneCB; cdecl;  {this procedure is the load to the scene the object or word}
var
  direction: GLfloat = 15;
  i, j: Integer;
begin
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
  glClearColor(ColorForm[1], ColorForm[2], ColorForm[3], 1.0);

  glLoadIdentity;
  glLightfv(GL_LIGHT0, GL_POSITION, position);
  glLightfv(GL_LIGHT0, GL_SPOT_CUTOFF, @direction);
  glLightfv(GL_LIGHT0, GL_DIFFUSE, coloroflight);
  glLightf(GL_LIGHT0, GL_SPOT_EXPONENT, instensity);

  glEnable(GL_LIGHT0);
  glEnable(GL_LIGHTING);
  glLoadIdentity;
  glBindTexture(GL_TEXTURE_2D, GL_NONE);
  glTranslatef(0, 0, -1);
  glRotatef(gamma, 70, 0, 0);
  glCallList(Ord(LIST_OBJECT));

  glLoadIdentity;
  glBindTexture(GL_TEXTURE_2D, GL_NONE);
  glCallList(Ord(TEX_OBJECT));

  glDisable(GL_LIGHT0);
  glDisable(GL_LIGHTING);

  glOrtho(0.0, 800.0, 0.0, 600.0, -1.0, 1.0);
  if Length(TextArea) > 0 then begin
    if TextArea[0].FVisible then begin
      TextArea[0].Draw(TextArea[0].Coord.X, TextArea[0].Coord.Y, TextArea[0].Coord.Width, TextArea[0].Coord.Heigth);

      glLoadIdentity;
      glEnter2D;

      TextArea[0].Execute;

      glLeave2D;
    end;
  end;

  if Length(Button) > 0 then begin
    if Button[0].FVisible = True then begin
      Button[0].Draw(Button[0].Coord.X, Button[0].Coord.Y, Button[0].Coord.Width, Button[0].Coord.Heigth);

      glLoadIdentity;
      glEnter2D;

      Button[0].DrawCaption(Button[0].FCaption);

      glLeave2D;

    end;
  end;

  if Length(MainMenu) > 0 then begin
    if MainMenu[0].FVisible = True then begin
      MainMenu[0].Draw;
    end;
  end;

  if Length(Menu) > 0 then begin
    if Menu[0].Visible then begin
      for j := 1 to High(Menu[0].nbMenu) do begin
        if Menu[0].NbMenu[j].IsNotNull then begin
          Menu[0].Draw;
          Menu[0].nbMenu[j].X := Menu[0].x;
          for i := 1 to High(Menu[0].nbMenu[j].Item) do begin
            Menu[0].nbMenu[j].Item[i].X := Menu[0].nbMenu[j].X;
            if Menu[0].nbMenu[j].Item[i].IsNotNull = True then begin
              Menu[0].DrawItem(Menu[0].nbMenu[j].X, y);
              Menu[0].nbMenu[j].Item[i].Y := y;
              y -= 20;
            end;
          end;
          y := 570;
          Menu[0].x += 50;
        end;
      end;
      Menu[0].x := 20;
    end;
  end;

  glutSwapBuffers;
end;

procedure TBaseWindow.SetVisible(Visible: Boolean);
begin
  if Visible = True then glutShowWindow else glutHideWindow;
end;


procedure TBaseWindow.CreateList;   {it is the list of Component Create or draw object}
begin
    glNewList(Ord(TEX_OBJECT), GL_COMPILE);
    if Self.Create_Triangle = True then begin
      glEnable(GL_COLOR_MATERIAL);
      glColorMaterial(GL_FRONT, GL_AMBIENT_AND_DIFFUSE);
      glBegin(GL_TRIANGLE_STRIP);
        glColor3f(1, 0, 0);
        glVertex3f(0, 0.5, 0);

        glColor3f(1, 1, 0);
        glVertex3f(-0.5, -0.5, 0.5);

        glColor3f(1, 1, 1);
        glVertex3f(0.5, -0.5, 0.5);

        glColor3f(0, 1, 1);
        glVertex3f(0.5, -0.5, -0.5);

        glColor3f(0, 0, 1);
        glVertex3f(-0.5, -0.5, -0.5);

        glColor3f(0.4, 0.1, 0.8);
        glVertex3f(-0.5, -0.5, 0.5);
      glEnd;
  end;
  if Self.Create_Point then begin
    Point3D(Self.PositionPoint.X, Self.PositionPoint.Y, Self.PositionPoint.Z);
  end;
glEndList;

end;

procedure TBaseWindow.EnvoiEvent(); {for the event it is procedure for send event in a procedure}
begin
  Self.Event.ReceiveRequest(Self.UnitName);
end;

procedure TBaseWindow.ChangePoint();
begin
  if Self.Create_Point then Self.CreateList;
end;

procedure TBaseWindow.SetTheName(Name: String);
begin
  FName := Name;
  if HaveglutInit = True then glutSetWindowTitle(PChar(Self.FName));
end;

procedure TBaseWindow.SetColor(AValue: TColor);
begin
  FColor:=AValue;
  ColorForm[1] := FColor[1];
  ColorForm[2] := FColor[2];
  ColorForm[3] := FColor[3];
end;

procedure ReSizeGLScene(Width, Height: Integer); cdecl;  {This procedure resize the Scene}
begin
  glViewport(0, 0, Width, Height);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  gluPerspective(45, Width / Height, 1, 1);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;
end;

end.

