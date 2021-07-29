{$MACRO ON}
{$MODE Delphi}
{$IFDEF Windows}
  {$DEFINE extdecl := stdcall}
{$ELSE}
  {$DEFINE extdecl := cdecl}
{$ENDIF}

{$IFDEF MORPHOS}
{$INLINE ON}
{$DEFINE GLUT_UNIT}
{$ENDIF}

unit Unit1;

interface

uses
  Classes, SysUtils, gl,  {$IFDEF Windows}
  Windows, dynlibs,
  {$ELSE}
  {$IFDEF MORPHOS}
  TinyGL,
  {$ELSE}
  dynlibs,
  {$ENDIF}
  {$ENDIF}
 glut;

const
    GLUT_RGB                        = 0;
    GLUT_DOUBLE                     = 2;
    GLUT_DEPTH                      = 16;
    GLUT_SINGLE                     = 0;

      // Mouse buttons.
    GLUT_LEFT_BUTTON                = 0;
    GLUT_MIDDLE_BUTTON              = 1;
    GLUT_RIGHT_BUTTON               = 2;

      // Mouse button state.
    GLUT_DOWN                       = 0;
    GLUT_UP                         = 1;

    // function keys
    GLUT_KEY_F1                     = 1;
    GLUT_KEY_F2                     = 2;
    GLUT_KEY_F3                     = 3;
    GLUT_KEY_F4                     = 4;
    GLUT_KEY_F5                     = 5;
    GLUT_KEY_F6                     = 6;
    GLUT_KEY_F7                     = 7;
    GLUT_KEY_F8                     = 8;
    GLUT_KEY_F9                     = 9;
    GLUT_KEY_F10                    = 10;
    GLUT_KEY_F11                    = 11;
    GLUT_KEY_F12                    = 12;

    // Menu usage state.
    GLUT_MENU_NOT_IN_USE            = 0;
    GLUT_MENU_IN_USE                = 1;

    // directional keys
    GLUT_KEY_LEFT                   = 100;
    GLUT_KEY_UP                     = 101;
    GLUT_KEY_RIGHT                  = 102;
    GLUT_KEY_DOWN                   = 103;
    GLUT_KEY_PAGE_UP                = 104;
    GLUT_KEY_PAGE_DOWN              = 105;
    GLUT_KEY_HOME                   = 106;
    GLUT_KEY_END                    = 107;
    GLUT_KEY_INSERT                 = 108;

    // glutGet parameters.
    GLUT_WINDOW_X                   = 100;
    GLUT_WINDOW_Y                   = 101;
    GLUT_WINDOW_WIDTH               = 102;
    GLUT_WINDOW_HEIGHT              = 103;
    GLUT_WINDOW_BUFFER_SIZE         = 104;
    GLUT_WINDOW_STENCIL_SIZE        = 105;
    GLUT_WINDOW_DEPTH_SIZE          = 106;
    GLUT_WINDOW_RED_SIZE            = 107;
    GLUT_WINDOW_GREEN_SIZE          = 108;
    GLUT_WINDOW_BLUE_SIZE           = 109;
    GLUT_WINDOW_ALPHA_SIZE          = 110;
    GLUT_WINDOW_ACCUM_RED_SIZE      = 111;
    GLUT_WINDOW_ACCUM_GREEN_SIZE    = 112;
    GLUT_WINDOW_ACCUM_BLUE_SIZE     = 113;
    GLUT_WINDOW_ACCUM_ALPHA_SIZE    = 114;
    GLUT_WINDOW_DOUBLEBUFFER        = 115;
    GLUT_WINDOW_RGBA                = 116;
    GLUT_WINDOW_PARENT              = 117;
    GLUT_WINDOW_NUM_CHILDREN        = 118;
    GLUT_WINDOW_COLORMAP_SIZE       = 119;
    GLUT_WINDOW_NUM_SAMPLES         = 120;
    GLUT_WINDOW_STEREO              = 121;
    GLUT_WINDOW_CURSOR              = 122;
    GLUT_SCREEN_WIDTH               = 200;
    GLUT_SCREEN_HEIGHT              = 201;
    GLUT_SCREEN_WIDTH_MM            = 202;
    GLUT_SCREEN_HEIGHT_MM           = 203;
    GLUT_FULL_SCREEN = $01FF;
    GLUT_MENU_NUM_ITEMS             = 300;
    GLUT_DISPLAY_MODE_POSSIBLE      = 400;
    GLUT_INIT_WINDOW_X              = 500;
    GLUT_INIT_WINDOW_Y              = 501;
    GLUT_INIT_WINDOW_WIDTH          = 502;
    GLUT_INIT_WINDOW_HEIGHT         = 503;
    GLUT_INIT_DISPLAY_MODE          = 504;
    GLUT_ELAPSED_TIME               = 700;
    GLUT_WINDOW_FORMAT_ID		  = 123;

    // glutDeviceGet parameters.
    GLUT_HAS_KEYBOARD               = 600;
    GLUT_HAS_MOUSE                  = 601;
    GLUT_HAS_SPACEBALL              = 602;
    GLUT_HAS_DIAL_AND_BUTTON_BOX    = 603;
    GLUT_HAS_TABLET                 = 604;
    GLUT_NUM_MOUSE_BUTTONS          = 605;
    GLUT_NUM_SPACEBALL_BUTTONS      = 606;
    GLUT_NUM_BUTTON_BOX_BUTTONS     = 607;
    GLUT_NUM_DIALS                  = 608;
    GLUT_NUM_TABLET_BUTTONS         = 609;
    GLUT_DEVICE_IGNORE_KEY_REPEAT   = 610;
    GLUT_DEVICE_KEY_REPEAT          = 611;
    GLUT_HAS_JOYSTICK               = 612;
    GLUT_OWNS_JOYSTICK              = 613;
    GLUT_JOYSTICK_BUTTONS           = 614;
    GLUT_JOYSTICK_AXES              = 615;
    GLUT_JOYSTICK_POLL_RATE         = 616;

    // glutSetCursor parameters.
    // Basic arrows.
    GLUT_CURSOR_RIGHT_ARROW          = 0;
    GLUT_CURSOR_LEFT_ARROW           = 1;
    // Symbolic cursor shapes.
    GLUT_CURSOR_INFO                 = 2;
    GLUT_CURSOR_DESTROY              = 3;
    GLUT_CURSOR_HELP                 = 4;
    GLUT_CURSOR_CYCLE                = 5;
    GLUT_CURSOR_SPRAY                = 6;
    GLUT_CURSOR_WAIT                 = 7;
    GLUT_CURSOR_TEXT                 = 8;
    GLUT_CURSOR_CROSSHAIR            = 9;
    // Directional cursors.
    GLUT_CURSOR_UP_DOWN              = 10;
    GLUT_CURSOR_LEFT_RIGHT           = 11;
    // Sizing cursors.
    GLUT_CURSOR_TOP_SIDE             = 12;
    GLUT_CURSOR_BOTTOM_SIDE          = 13;
    GLUT_CURSOR_LEFT_SIDE            = 14;
    GLUT_CURSOR_RIGHT_SIDE           = 15;
    GLUT_CURSOR_TOP_LEFT_CORNER      = 16;
    GLUT_CURSOR_TOP_RIGHT_CORNER     = 17;
    GLUT_CURSOR_BOTTOM_RIGHT_CORNER  = 18;
    GLUT_CURSOR_BOTTOM_LEFT_CORNER   = 19;
    // Inherit from parent window.
    GLUT_CURSOR_INHERIT              = 100;
    // Blank cursor.
    GLUT_CURSOR_NONE                 = 101;
    // Fullscreen crosshair (if available).
    GLUT_CURSOR_FULL_CROSSHAIR       = 102;

    {$IFDEF MORPHOS}

  { MorphOS GL works differently due to different dynamic-library handling on Amiga-like }
  { systems, so its headers are included here. }
  {$INCLUDE tinyglh.inc}

  {$ELSE MORPHOS}

var
    glutInit: procedure(argcp: PInteger; argv: PPChar); extdecl;
    glutInitDisplayMode: procedure(mode: Cardinal); extdecl;
    glutInitWindowPosition: procedure(x, y: Integer); extdecl;
    glutInitWindowSize: procedure(width, height: Integer); extdecl;
    glutIdleFunc: procedure(f: TGlutVoidCallback); extdecl;
    glutReshapeFunc: procedure(f: TGlut2IntCallback); extdecl;
    glutSwapBuffers: procedure; extdecl;
    glutKeyboardFunc: procedure(f: TGlut1Char2IntCallback); extdecl;
    glutMouseFunc: procedure(f: TGlut4IntCallback); extdecl;
    glutSetCursor: procedure(cursor: Integer); extdecl;
    glutLeaveGameMode : procedure; extdecl;
    glutPostRedisplay: procedure; extdecl;
    glutFullScreen: procedure; extdecl;
    glutCreateMenu: function(callback: TGlut1IntCallback): Integer; extdecl;
    glutDestroyMenu: procedure(menu: Integer); extdecl;
    glutGetMenu: function: Integer; extdecl;
    glutSetMenu: procedure(menu: Integer); extdecl;
    glutAddMenuEntry: procedure(const caption: PChar; value: Integer); extdecl;
    glutAddSubMenu: procedure(const caption: PChar; submenu: Integer); extdecl;
    glutChangeToMenuEntry: procedure(item: Integer; const caption: PChar; value: Integer); extdecl;
    glutChangeToSubMenu: procedure(item: Integer; const caption: PChar; submenu: Integer); extdecl;
    glutRemoveMenuItem: procedure(item: Integer); extdecl;
    glutAttachMenu: procedure(button: Integer); extdecl;
    glutDetachMenu: procedure(button: Integer); extdecl;
    glutMenuStateFunc: procedure(f: TGlut1IntCallback); extdecl;
    glutMenuStatusFunc: procedure(f: TGlut3IntCallback); extdecl;
    glutEnterGameMode : function : integer; extdecl;
    glutWireTeapot: procedure(size: GLdouble); extdecl;
    glutDisplayFunc: procedure(f: TGlutVoidCallback); extdecl;
    glutMainLoop: procedure; extdecl;
    glutCreateWindow: function(const title: PChar): Integer; extdecl;
    glutPopWindow: procedure; extdecl;
    glutPushWindow: procedure; extdecl;
    glutIconifyWindow: procedure; extdecl;
    glutShowWindow: procedure; extdecl;
    glutHideWindow: procedure; extdecl;
    glutDestroyWindow: procedure(win: Integer); extdecl;
    {$ENDIF MORPHOS}

implementation


{$IFDEF MORPHOS}

{ MorphOS GL works differently due to different dynamic-library handling on Amiga-like }
{ systems, so its functions are included here. }
{$INCLUDE tinygl.inc}

{$ELSE MORPHOS}
uses FreeGlut;

var
  hDLL: TLibHandle;
{$ENDIF MORPHOS}

procedure UnloadFunction;
begin
    @glutInit := nil;
    @glutInitDisplayMode := nil;
    @glutKeyboardFunc := nil;
    @glutMouseFunc := nil;
    @glutSetCursor := nil;
    @glutLeaveGameMode := nil;
    @glutInitWindowPosition := nil;
    @glutInitWindowSize := nil;
    @glutWireTeapot := nil;
    @glutReshapeFunc := nil;
    @glutSwapBuffers := nil;
    @glutIdleFunc := nil;
    @glutEnterGameMode := nil;
    @glutDisplayFunc := nil;
    @glutPostRedisplay := nil;
    @glutFullScreen := nil;
    @glutCreateMenu := nil;
    @glutDestroyMenu := nil;
    @glutGetMenu := nil;
    @glutSetMenu := nil;
    @glutAddMenuEntry := nil;
    @glutAddSubMenu := nil;
    @glutChangeToMenuEntry := nil;
    @glutChangeToSubMenu := nil;
    @glutRemoveMenuItem := nil;
    @glutAttachMenu := nil;
    @glutDetachMenu := nil;
    @glutMenuStateFunc := nil;
    @glutMenuStatusFunc := nil;
    @glutMainLoop := nil;
    @glutCreateWindow := nil;
    @glutPopWindow := nil;
    @glutPushWindow := nil;
    @glutIconifyWindow := nil;
    @glutShowWindow := nil;
    @glutHideWindow := nil;
    @glutDestroyWindow := nil;
end;

procedure LoadGlut(const dll: String);
{$IFDEF MORPHOS}
begin
  // MorphOS's GL has own initialization in TinyGL unit, nothing is needed here.
end;
{$ELSE MORPHOS}
var
  MethodName: string = '';

  function GetGLutProcAddress(Lib: PtrInt; ProcName: PChar): Pointer;
  begin
    MethodName:=ProcName;
    Result:=GetProcAddress(Lib, ProcName);
  end;

begin
    UnloadGlut;

  hDLL := LoadLibrary(PChar(dll));
  if hDLL = 0 then raise Exception.Create('Could not load Glut from ' + dll);
  try
      @glutInit := GetGLutProcAddress(hDLL, 'glutInit');
      @glutInitDisplayMode := GetGLutProcAddress(hDLL, 'glutInitDisplayMode');
      @glutInitWindowPosition := GetGLutProcAddress(hDLL, 'glutInitWindowPosition');
      @glutInitWindowSize := GetGLutProcAddress(hDLL, 'glutInitWindowSize');
      @glutIdleFunc := GetGLutProcAddress(hDLL, 'glutIdleFunc');
      @glutSwapBuffers := GetGLutProcAddress(hDLL, 'glutSwapBuffers');
      @glutReshapeFunc := GetGLutProcAddress(hDLL, 'glutReshapeFunc');
      @glutKeyboardFunc := GetGLutProcAddress(hDLL, 'glutKeyboardFunc');
      @glutMouseFunc := GetGLutProcAddress(hDLL, 'glutMouseFunc');
      @glutSetCursor := GetGLutProcAddress(hDLL, 'glutSetCursor');
      @glutLeaveGameMode := GetGLutProcAddress(hDLL, 'glutLeaveGameMode');
      @glutEnterGameMode := GetGLutProcAddress(hDLL, 'glutEnterGameMode');
      @glutWireTeapot := GetGLutProcAddress(hDLL, 'glutWireTeapot');
      @glutDisplayFunc := GetGLutProcAddress(hDLL, 'glutDisplayFunc');
      @glutPostRedisplay := GetGLutProcAddress(hDLL, 'glutPostRedisplay');
      @glutFullScreen := GetGLutProcAddress(hDLL, 'glutFullScreen');
      @glutCreateMenu := GetGLutProcAddress(hDLL, 'glutCreateMenu');
      @glutDestroyMenu := GetGLutProcAddress(hDLL, 'glutDestroyMenu');
      @glutGetMenu := GetGLutProcAddress(hDLL, 'glutGetMenu');
      @glutSetMenu := GetGLutProcAddress(hDLL, 'glutSetMenu');
      @glutAddMenuEntry := GetGLutProcAddress(hDLL, 'glutAddMenuEntry');
      @glutAddSubMenu := GetGLutProcAddress(hDLL, 'glutAddSubMenu');
      @glutChangeToMenuEntry := GetGLutProcAddress(hDLL, 'glutChangeToMenuEntry');
      @glutChangeToSubMenu := GetGLutProcAddress(hDLL, 'glutChangeToSubMenu');
      @glutRemoveMenuItem := GetGLutProcAddress(hDLL, 'glutRemoveMenuItem');
      @glutAttachMenu := GetGLutProcAddress(hDLL, 'glutAttachMenu');
      @glutDetachMenu := GetGLutProcAddress(hDLL, 'glutDetachMenu');
      @glutMenuStateFunc := GetGLutProcAddress(hDLL, 'glutMenuStateFunc');
      @glutMenuStatusFunc := GetGLutProcAddress(hDLL, 'glutMenuStatusFunc');
      @glutMainLoop := GetGLutProcAddress(hDLL, 'glutMainLoop');
      @glutCreateWindow := GetGLutProcAddress(hDLL, 'glutCreateWindow');
      @glutPopWindow := GetGLutProcAddress(hDLL, 'glutPopWindow');
      @glutPushWindow := GetGLutProcAddress(hDLL, 'glutPushWindow');
      @glutIconifyWindow := GetGLutProcAddress(hDLL, 'glutIconifyWindow');
      @glutShowWindow := GetGLutProcAddress(hDLL, 'glutShowWindow');
      @glutHideWindow := GetGLutProcAddress(hDLL, 'glutHideWindow');
      @glutDestroyWindow := GetGLutProcAddress(hDLL, 'glutDestroyWindow');

       except
    raise Exception.Create('Could not load ' + MethodName + ' from ' + dll);
  end;
  LoadFreeGlut(hDLL);
end;
{$ENDIF MORPHOS}

initialization

  {$if defined(Windows)}
  LoadGlut('glut32.dll');
  {$elseif defined(OS2)}
  LoadGlut('glut.dll');
  {$elseif defined(darwin)}
  LoadGlut('/System/Library/Frameworks/GLUT.framework/GLUT');
  {$elseif defined(haiku) or defined(OpenBSD)}
  LoadGlut('libglut.so');
  {$elseif defined(MORPHOS)}
  {nothing}
  {$else}
  LoadGlut('libglut.so.3');
  {$endif}

finalization

  UnloadGlut;

end.

