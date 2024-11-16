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

        fild    [clientRect.right]      
        fidiv   [clientRect.bottom]     
        fstp    [aspect]

        stdcall Glext.LoadFunctions
        stdcall Glext.CreateShaders  
        
        invoke  PlaySound, musicPath, NULL,0x0008 or 0x00020000 or 0x0001
        
        stdcall Object.Create, car, fileName, textPath
        stdcall Object.Create, nissan, fileNameN, textPathN
        stdcall Object.Create, table, fileNameT, textPathT
        stdcall Object.Create, sphere, fileNameS, textPathS

        stdcall Object.SetPosition, sphere, 0.0, 50.0, 0.0
        stdcall Object.SetPosition, car, 10.0, 0.0, 10.0        
        stdcall Object.SetScale, car, 10.0, 10.0, 10.0
        stdcall Object.InitModelMatrix, car

        invoke  glShadeModel, GL_SMOOTH
        invoke  glHint, GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST
        invoke  glEnable, GL_DEPTH_TEST
        invoke  glDepthFunc, GL_LESS 
        invoke  glEnable, GL_CULL_FACE
        invoke  glCullFace, GL_BACK 
        invoke  glFrontFace, GL_CCW

        stdcall Matrix.Projection, [aspect], [fovY], [zNear], [zFar], projection
        
        invoke  GetTickCount
        mov [startTime], eax

        ret
endp