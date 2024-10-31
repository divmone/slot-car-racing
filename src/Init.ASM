proc Init uses esi
        locals
                hMainWindow     dd              ?
                aspect          dd              ?
        endl

        invoke  GetProcessHeap
        mov     [hHeap], eax

        invoke  RegisterClass, wndClass
        invoke  CreateWindowEx, ebx, className, className, POP_IT,\
                        ebx, ebx, ebx, ebx, ebx, ebx, ebx, ebx
        mov     [hMainWindow], eax

        invoke  GetClientRect, eax, clientRect
        invoke  ShowCursor, 0
        invoke  GetTickCount
        mov     [time], eax

        invoke  GetDC, [hMainWindow]
        mov     [hdc], eax
 
        stdcall Log.Create
        ;stdcall  PrintToConsole, okMessage + 1, okMessage.size - 1
  
        invoke  ChoosePixelFormat, [hdc], pfd
        invoke  SetPixelFormat, [hdc], eax, pfd

        invoke  wglCreateContext, [hdc]
        invoke  wglMakeCurrent, [hdc], eax

        invoke  glViewport, ebx, ebx, [clientRect.right], [clientRect.bottom]

        fild    [clientRect.right]      ; width
        fidiv   [clientRect.bottom]     ; width / height
        fstp    [aspect]

        stdcall Glext.LoadFunctions
        
        stdcall Object.Create, car, fileName

        invoke  glShadeModel, GL_SMOOTH
        invoke  glHint, GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST
        invoke  glEnable, GL_DEPTH_TEST
        invoke  glDepthFunc, GL_ALWAYS
     
        invoke  HeapAlloc, [hHeap], ebx, sizeof.Vertex * 6
        mov     [plane.normals], eax

        stdcall Mesh.CalculateNormals, plane

        stdcall Mesh.CalculateNormals, car

        stdcall Glext.InitShaders  
        
        stdcall VAO.Init, containerVAO, car, vertexVBO, normalsVBO

        stdcall VAO.Init, containerVAOPlane, plane, vertexVBOp, normalsVBOp

        stdcall Texture.Init
        
        stdcall Matrix.Projection, [aspect], [fovY], [zNear], [zFar], projection
        
        ret
endp