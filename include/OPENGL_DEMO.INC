format  PE GUI 5.0
entry   WinMain

        include         "win32a.inc"

        include         "api\kernel32.inc"
        include         "api\user32.inc"
        include         "api\gdi32.inc"
        include         "api\opengl.inc"
        include         "api\winmm.inc"

        include         "Mesh.inc"
        include         "Vector.inc"
        include         "Color.inc"
        include         "Matrix.inc"
        include         "Spline.inc"
        include         "GLext.inc"
        include         "String.inc"
        include         "Utils.inc"
        include         "Logger.inc"
        include         "VBO.inc"
        include         "VAO.inc"
        include         "Texture.inc"
        include         "BMP.inc"
        include         "OBJ.inc"
        include         "Shader.inc"
        include         "Object.inc"
        include         "Controller.inc"

macro switch value
{
        mov     eax, value
}

macro case label, [value]
{
        cmp     eax, value
        je      label
}

macro memset address, value, count
{
        mov     edi, address
        mov     eax, value
        mov     ecx, count
        rep     stosb
}

macro memcpy dest, src, count
{
        mov     esi, src
        mov     edi, dest
        mov     ecx, count
        rep     movsb
}

macro malloc [arg]
{
  argc = 0
forward
  if ~arg eq
    argc = argc+1
  end if
common
  if argc = 1
    invoke  HeapAlloc, [hHeap], ebx, arg
  else if argc = 2
    match count, size, arg
    \{
        invoke HeapAlloc, [hHeap], 8, count * size
      \}
  end if
}  
        include         "Plane.inc"
         include         "Cube.inc"
         include         "zhiguli.inc"


        true            =       1
        false           =       0

        COLOR_DEPTH     =       24
        PFD_FLAGS       =       PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER or PFD_DRAW_TO_WINDOW
        POP_IT          =       WS_VISIBLE or WS_MAXIMIZE or WS_POPUP

        wndClass        WNDCLASS                0, WindowProc, 0, 0, 0, 0, 0, 0, 0, className
        pfd             PIXELFORMATDESCRIPTOR   sizeof.PIXELFORMATDESCRIPTOR, 1, PFD_FLAGS, PFD_TYPE_RGBA, COLOR_DEPTH,\
                                                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,\
                                                COLOR_DEPTH, 0, 0, PFD_MAIN_PLANE, 0, PFD_MAIN_PLANE

data import

        library kernel32,       "KERNEL32.DLL",\
                user32,         "USER32.DLL",\
                gdi32,          "GDI32.DLL",\
                opengl32,       "OPENGL32.DLL",\
                winmm,          "WINMM.DLL"


end data