proc Init uses esi

        locals
                hMainWindow     dd              ?
                aspect          dd              ?
        endl

        invoke  GetProcessHeap
        mov     [hHeap], eax

        invoke  RegisterClass, wndClass
        invoke  CreateWindowEx, ebx, className, className, WINDOW_STYLE,\
                        ebx, ebx, ebx, ebx, ebx, ebx, ebx, ebx
        mov     [hMainWindow], eax

        invoke  GetClientRect, eax, clientRect
        invoke  ShowCursor, ebx
        invoke  GetTickCount
        mov     [time], eax

        invoke  GetDC, [hMainWindow]
        mov     [hdc], eax

        invoke  ChoosePixelFormat, [hdc], pfd
        invoke  SetPixelFormat, [hdc], eax, pfd

        invoke  wglCreateContext, [hdc]
        invoke  wglMakeCurrent, [hdc], eax

        invoke  glViewport, ebx, ebx, [clientRect.right], [clientRect.bottom]

        fild    [clientRect.right]      ; width
        fidiv   [clientRect.bottom]     ; width / height
        fstp    [aspect]                ;

        invoke  glMatrixMode, GL_PROJECTION
        invoke  glLoadIdentity

        stdcall Matrix.Projection, [aspect], [fovY], [zNear], [zFar]

        invoke  glShadeModel, GL_SMOOTH
        invoke  glHint, GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST
        invoke  glEnable, GL_DEPTH_TEST
        invoke  glEnable, GL_COLOR_MATERIAL

      ;  invoke  HeapAlloc, [hHeap], 8, sizeof.Vertex * 8
      ;  mov     [cubeMesh.colors], eax

        invoke  HeapAlloc, [hHeap], ebx, sizeof.Vertex * 6
        mov     [plane.normals], eax

        stdcall Mesh.Generate, cubeMesh, cube, true
        stdcall Mesh.Generate, zhMesh, zh, true

        stdcall Mesh.CalculateNormals, zh
        stdcall Mesh.CalculateNormals, cube
        stdcall Mesh.CalculateNormals, plane

        invoke  glEnable, GL_LIGHTING
        invoke  glEnable, GL_LIGHT0
        invoke  glEnable, GL_LIGHT1

        invoke  glLightfv, GL_LIGHT0, GL_POSITION, light0Position
        invoke  glLightfv, GL_LIGHT1, GL_POSITION,  light1Position

        stdcall  Matrix.GetAxis, cameraPosition, targetPosition, upVector,\
                             xAxis, yAxis, zAxis


        stdcall File.LoadContent, fileName;, size
        mov [buffer], eax
        stdcall File.GetSize, fileName
        ; stdcall  PrintToConsole, [buffer] , eax
        stdcall ParseOBJ, [buffer], eax;, [objVertices], [objIndices]
       ;

        ret
endp