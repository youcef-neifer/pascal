unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Unit1, gl, glu; //Dialogs; // ImagingDeVampireYoucef;

type
    { TBaseWindow }

  TBaseWindow = class
    Name: PChar;
    Window_Size_Height: Integer;
    Window_Size_Width: Integer;
    GamingMode: Boolean;
    glutMainLoop_Active_Automatique: Boolean;
    Create_Triangle: Boolean;
    Visible: Boolean;
    procedure CreateList;
    procedure CreateWindow;
    procedure affiche;
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
  Form: TBaseWindow;
  alpha: Real = 0;
  dx: Real = -2;
  dy: Real = 0;
  dz: Real = -5;
  Texture:array[TEX_SKY..TEX_BACKGROUND] of GLuint;
  sub1: Integer;
  sub2: Integer;
  r, g, b: GLclampf;

var
  win: Integer;


procedure RenderSceneCB; cdecl;
procedure ReSizeGLScene(Widht, Height: Integer); cdecl;
procedure GlMenuColor(OptionColor: LongInt = 2); cdecl;
procedure display; cdecl;
procedure InitializeGL;
procedure GlMenuImage(Option: Integer); cdecl;
implementation


{ TBaseWindow }

procedure TBaseWindow.CreateWindow;
var
  argc: Integer = 0;
  argv: PPChar = nil;
begin
  glutInit(@argc, argv);
  glutInitDisplayMode(GLUT_SINGLE or GLUT_RGB);
  glutInitWindowSize(Self.Window_Size_Width, Self.Window_Size_Height);
  glutInitWindowPosition(100, 100);
    if Self.GamingMode = False then win := glutCreateWindow(Self.Name) else glutEnterGameMode;
  sub1 := glutCreateMenu(@GlMenuColor);

  glutAddMenuEntry('Rouge', 1);
  glutAddMenuEntry('Orange', 5);
  glutAddMenuEntry('Bleu', 2);
  glutAddMenuEntry('Bleu Clair', 4);
  glutAddMenuEntry('Vert', 3);
  glutAddMenuEntry('Tres bleu', 6);
  glutCreateMenu(@GlMenuColor);
  glutAddSubMenu('Color', sub1);
  glutAttachMenu(GLUT_RIGHT_BUTTON);

  Self.CreateList;
  glutDisplayFunc(@RenderSceneCB);
  glutIdleFunc(@RenderSceneCB);
  glutReshapeFunc(@ReSizeGLScene);
end;

procedure TBaseWindow.affiche;
begin
    if Self.glutMainLoop_Active_Automatique = True then glutMainLoop;
end;

procedure display;  cdecl;
begin
  glClearColor(0.0,0.0,0.0,0.0);
  glutWireTeapot(0.5);
  glFlush;
end;

procedure RenderSceneCB; cdecl;
begin
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
  glClearColor(r,g,b, 1.0);

  glLoadIdentity;
  glEnable(GL_LIGHTING);
  glLightfv(GL_LIGHT0, GL_SPOT_CUTOFF, DiffuseLight);
  glEnable(GL_LIGHT0);

  InitializeGL;

  glLoadIdentity;
  glBindTexture(GL_TEXTURE_2D, GL_NONE);
  glTranslatef(dx, dy, dz);
  glRotatef(alpha, 1, 0, 1);
  glCallList(Ord(TEX_OBJECT));

  glutSwapBuffers;
end;
procedure TBaseWindow.CreateList;
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
  glEndList;

end;

procedure ReSizeGLScene(Widht, Height: Integer); cdecl;
begin
  glViewport(0, 0, Widht, Height);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity;
  gluPerspective(45, Widht / Height, 0.1, 1000);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;
end;

procedure InitializeGL;
begin
//  Texture[TEX_BACKGROUND] := LoadGLTextureFromFile('ashwood.bmp');
  glLoadIdentity;
  glEnable(GL_BLEND);
  glBlendFunc(GL_ZERO, GL_SRC_COLOR);
  glTranslatef(0, 0, -100);
  glDisable(GL_BLEND);
end;

procedure GlMenuImage(Option: Integer); cdecl;
//var
//  OpenPicture: TOpenDialog;
begin
  case Option of
    1:begin
      end;
  end;
//   if OpenPicture.Execute then begin
//    Texture[TEX_BACKGROUND] := LoadGLTextureFromFile(OpenPicture.FileName);
//    glBindTexture(GL_TEXTURE_2D, Texture[TEX_BACKGROUND]);
//   end;
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

end.

