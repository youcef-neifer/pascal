program OpenGlProgram;
{$LINKLIB m}
uses
  Gl, Glut, Glu, ImagingOpenGL;

type
  TTextures = (
    TEX_NONE,
    TEX_SKY,
    TEX_LIGHT,
    TEX_BACKGROUND,
    TEX_OBJECT
  );

const
  GAMING_MODE = false;
  DiffuseLight: array[0..3] of GLfloat = (0.2, 0.4, 0.8, 0.1);
var
  win: Integer;
  alpha: Real = 0;
  dx: Real = -2;
  dy: Real = 0;
  dz: Real = -5;
  Texture:array[TEX_SKY..TEX_BACKGROUND] of GLuint;

procedure CreateList;
const
  Width = 75;
  Height = 45;
begin
  glNewList(Ord(TEX_OBJECT), GL_COMPILE);
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
  glEndList;

  glNewList(Ord(TEX_LIGHT), GL_COMPILE);
    glColor3f(1, 1, 1);
    glBegin(GL_QUADS);
      glTexCoord2f(1, 0);
      glVertex3f( 2, 2, 0);
      glTexCoord2f(0, 0);
      glVertex3f(-2, 2, 0);
      glTexCoord2f(0, 1);
      glVertex3f(-2,-2, 0);
      glTexCoord2f(1, 1);
      glVertex3f( 2,-2, 0);
    glEnd;
  glEndList;

  glNewList(Ord(TEX_SKY), GL_COMPILE);
    glColor3f(1, 1, 1);
    glBegin(GL_QUADS);
      glTexCoord2f(1, 0);
      glVertex3f(Width, Height, 0);
      glTexCoord2f(0, 0);
      glVertex3f(-Width, Height, 0);
      glTexCoord2f(0, 1);
      glVertex3f(-Width, 0, 0);
      glTexCoord2f(1, 1);
      glVertex3f(Width, 0, 0);
    glEnd;
  glEndList;

    glNewList(Ord(TEX_BACKGROUND), GL_COMPILE);
      glColor3f(1, 1, 1);
      glBegin(GL_QUADS);
        glTexCoord2f(1, 0);
        glVertex3f(Width / 2, 0, 0);
        glTexCoord2f(0, 0);
        glVertex3f(-Width / 2, 0, 0);
        glTexCoord2f(0, 1);
        glVertex3f(-Width, -Height, 0);
        glTexCoord2f(1, 1);
        glVertex3f(Width, -Height, 0);
      glEnd;
      glColor3f(0, 0, 0);
      glBegin(GL_QUADS);
        glTexCoord2f(1, 0);
        glVertex3f(Width, 0, 0);
        glTexCoord2f(0, 0);
        glVertex3f(-Width, 0, 0);
        glTexCoord2f(0, 1);
        glVertex3f(-Width, -Height, 0);
        glTexCoord2f(1, 1);
        glVertex3f(Width, -Height, 0);
      glEnd;
    glEndList;
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

procedure glEnter2D;
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

procedure glLeave2D;
begin
  glMatrixMode(GL_PROJECTION);
  glPopMatrix;
  glMatrixMode(GL_MODELVIEW);
  glPopMatrix;

  glEnable(GL_DEPTH_TEST);
end;

procedure glWrite(X, Y: GLfloat; Font: Pointer; Text: String);
var
  I: Integer;
begin
  glRasterPos2f(X, Y);
  for I := 1 to Length(Text) do
    glutBitmapCharacter(Font, Integer(Text[I]));
end;

procedure InitializeGL;
begin
  glClearColor(0.18, 0.20, 0.66, 0);
  Texture[TEX_BACKGROUND] := LoadGLTextureFromFile('ashwood.bmp');
  Texture[TEX_SKY] := LoadGLTextureFromFile('lumiere.png');
  Texture[TEX_LIGHT] := loadGLTextureFromFile('Flare.bmp');
  glEnable(GL_TEXTURE_2D);
end;

procedure RenderSceneCB; cdecl;
begin
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);

  glLoadIdentity;
  glEnter2D;
    glColor3f(0.2, 0.8 + 0.2, 0);
    glWrite(100, glGetViewportHeight - 60, GLUT_BITMAP_TIMES_ROMAN_24, 'Salut tout le monde, c''est Youcef !');
  glLeave2D;

  glLoadIdentity;
  glEnable(GL_BLEND);
  glBlendFunc(GL_ZERO, GL_SRC_COLOR);
  glTranslatef(0, 0, -100);
  glBindTexture(GL_TEXTURE_2D, Texture[TEX_SKY]);
  glCallList(Ord(TEX_SKY));
  glDisable(GL_BLEND);
  glBindTexture(GL_TEXTURE_2D, Texture[TEX_BACKGROUND]);
  glCallList(Ord(TEX_BACKGROUND));

  glLoadIdentity;
  glEnable(GL_LIGHTING);
  glLightfv(GL_LIGHT0, GL_SPOT_CUTOFF, DiffuseLight);
  glEnable(GL_LIGHT0);

  glLoadIdentity;
  glBindTexture(GL_TEXTURE_2D, GL_NONE);
  glTranslatef(dx, dy, dz);
  glRotatef(alpha, 1, 0, 1);
  glCallList(Ord(TEX_OBJECT));

  glTranslatef(-5, 0, -15);
  glBindTexture(GL_TEXTURE_2D, Texture[TEX_BACKGROUND]);
  glCallList(Ord(TEX_LIGHT));

  glTranslatef(0, 0, -15);
  glBindTexture(GL_TEXTURE_2D, Texture[TEX_LIGHT]);
  glCallList(Ord(TEX_LIGHT));

  glTranslatef(5, 0, -15);
  glBindTexture(GL_TEXTURE_2D, Texture[TEX_BACKGROUND]);
  glCallList(Ord(TEX_LIGHT));

  glutSwapBuffers;
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

procedure GLMousePressed(button, state, X, Y: LongInt); cdecl;
begin
  case button of
    GLUT_LEFT_BUTTON: begin
    dy += 0.1;
    end;
    GLUT_MIDDLE_BUTTON: begin

    end;
    GLUT_RIGHT_BUTTON: begin
    dy -= 0.1;
    end;
  end;
end;

procedure GlKeyBoard(Key: Byte; X, Y: Longint); cdecl;
begin
  case Key of
    27:begin
      if GAMING_MODE then begin
        glutLeaveGameMode;
      end else begin
        glutDestroyWindow(win);
      end;
    end;
    Ord('d'):begin
      glDeleteLists(Ord(TEX_OBJECT), 1);
    end;
    Ord('r'):begin
      alpha += 5;
    end;
    Ord('R'):begin
      alpha -= 5;
    end;
    Ord('x'):begin
      if dx < 2.73 then begin
         dx += 0.1;
      end;
    end;
    Ord('y'):begin
      if dy < 1 then begin
        dy += 0.1;
      end;
    end;
    Ord('z'):begin
      if dz < -4 then begin
         dz += 0.1;
      end;
    end;
    Ord('X'):begin
      dx -= 0.1;
    end;
    Ord('Y'):begin
      dy -= 0.1;
    end;
    Ord('Z'):begin
      dz -= 0.1;
    end;
  end;
end;

var
  argc: Integer = 0;
  argv: PPChar = nil;
begin
  glutInit(@argc, argv);
  glutInitDisplayMode(GLUT_DOUBLE or GLUT_RGB or GLUT_DEPTH);
  glutInitWindowSize(800, 600);
  glutInitWindowPosition(100, 100);
  if GAMING_MODE then begin
    //glutGameModeString(FSMode);
    glutEnterGameMode;
  end else begin
    win := glutCreateWindow('My Window');
  end;
  glutSetCursor(GLUT_CURSOR_CROSSHAIR);
  InitializeGL;
  CreateList;
  glutDisplayFunc(@RenderSceneCB);
  glutIdleFunc(@RenderSceneCB);
  glutReshapeFunc(@ReSizeGLScene);
  glutKeyboardFunc(@GlKeyBoard);
  glutMouseFunc(@GLMousePressed);
  glutMainLoop;
end.


