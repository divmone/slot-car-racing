format  PE GUI 5.0
entry   WinMain

        include         "win32a.inc"

        include         "api\kernel32.inc"
        include         "api\user32.inc"
        include         "api\gdi32.inc"
        include         "api\opengl.inc"

        include         "Mesh.inc"
        include         "Vector.inc"
        include         "Color.inc"
        include         "Matrix.inc"
        include         "Spline.inc"
        include         "GLext.inc"
    

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
        mov     edi, adress
        mov     eax, value
        mov     ecx, count
        rep     stosb
}

macro memcpy dest, src, count
{
        mov     esim src
        mov     edi, dest
        mov     ecx, count
        rep     movsb
}

macro malloc size
{
        invoke  HeapAlloc, [hHeap], ebx, size
}

macro malloc count, size
{
        invoke  HeapAlloc, [hHeap], 8, count * size
}


        include         "Plane.inc"
         include         "Cube.inc"
         include         "zhiguli.inc"


        true            =       1
        false           =       0

        COLOR_DEPTH     =       24
        PFD_FLAGS       =       PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER or PFD_DRAW_TO_WINDOW
        WINDOW_STYLE    =       WS_VISIBLE or WS_MAXIMIZE or WS_POPUP

        wndClass        WNDCLASS                0, WindowProc, 0, 0, 0, 0, 0, 0, 0, className
        pfd             PIXELFORMATDESCRIPTOR   sizeof.PIXELFORMATDESCRIPTOR, 1, PFD_FLAGS, PFD_TYPE_RGBA, COLOR_DEPTH,\
                                                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,\
                                                COLOR_DEPTH, 0, 0, PFD_MAIN_PLANE, 0, PFD_MAIN_PLANE

data import

        library kernel32,       "KERNEL32.DLL",\
                user32,         "USER32.DLL",\
                gdi32,          "GDI32.DLL",\
                opengl32,       "OPENGL32.DLL"

end data