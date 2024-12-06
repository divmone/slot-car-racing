proc Init uses esi
        locals
                hMainWindow     dd              ?
                aspect          dd              ?
                vbo dd ?
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
        stdcall Glext.CreateShaders2D  
        
        ;invoke  PlaySound, musicPath, NULL,0x0008 or 0x00020000 or 0x0001
        
        stdcall Object.Create, car, fileName, textPath
        stdcall Object.Create, car2, fileName2, textPath2
        ;stdcall Object.Create, nissan, fileNameN, textPathN
        stdcall Object.Create, table, fileNameT, textPathT
        stdcall Object.Create, track, fileNameTr, textPathTr
        stdcall Object.Create, road, fileNameR, textPathR
        
        stdcall Quaternion.CreateFromAxisAngle, car, 0.0, 1.0, 0.0, 90.0
        stdcall Quaternion.CreateFromAxisAngle, table, 0.0, 1.0, 0.0, 90.0
        stdcall Quaternion.CreateFromAxisAngle, sphere, 0.0, 1.0, 0.0, 90.0
        stdcall Quaternion.CreateFromAxisAngle, lamp, 0.0, 1.0, 0.0, 90.0
        stdcall Quaternion.CreateFromAxisAngle, pens, 0.0, 1.0, 0.0, 90.0
        stdcall Quaternion.CreateFromAxisAngle, books, 0.0, 1.0, 0.0, 90.0
        stdcall Quaternion.CreateFromAxisAngle, track, 0.0, 1.0, 0.0, -90.0

        
        stdcall Object.SetPosition, sphere, 0.0, 50.0, 0.0
        stdcall Object.SetPosition, car, 0.0, 0.0, 0.0 
        stdcall Object.SetPosition, lamp, 45.0, 50.0, -110.0
        stdcall Object.SetPosition, pens, -30.0, 0.0, 120.0        
        stdcall Object.SetPosition, books, 25.0, 0.0, 110.0 
        stdcall Object.SetPosition, track, 0.0, -150.0, 50.0 

        stdcall Object.SetRotation, track, 0.0, 90.0, 0.0  
        ;stdcall Object.SetScale, car, 10.0, 10.0, 10.0
        stdcall Object.SetScale, books, 0.45, 0.45, 0.45
        stdcall Object.SetScale, table, 50.0, 50.0, 50.0
        stdcall Object.SetScale, pens, 2.0, 2.0, 2.0
        stdcall Object.SetScale, track, 50.0, 50.0, 50.0
        stdcall Object.SetPosition, table, 7.0, -170.0, 0.0
        ;stdcall Object.SetRotation, road, 20.0, -10.0, 0.0
        stdcall Object.InitModelMatrix, car
        stdcall Object.InitModelMatrix, road
        

        ;stdcall Quaternion.CreateFromAxisAngle, car, 0.0, 1.0, 0.0, 0.0
        ;stdcall Quaternion.CreateFromAxisAngle, road, 0.0, 1.0, 0.0, 0.0
        ;

        stdcall Quaternion.CreateFromAxisAngle, R1, 0.0, 0.0, 0.0, 0.0
        ;stdcall Quaternion.CreateMatrix, road, road.rmatrix
        ;stdcall Quaternion.CreateMatrix, R1,  R1.rmatrix

        invoke glGetUniformLocation, [program2D], modelName2D
        mov [modelLocation2D], eax

        stdcall Vector3.Copy, sphere.transform.position, cameraPosition1, 12
        invoke glGetUniformLocation, [program2D], projectionName
        mov [projectionLocation], eax

        stdcall Rectangle.Create, R1, 0.0, 0.0, 10.0, 10.0
       ;`stdcall Rectangle.Create, R2,  0.0, 0.0, 0.4, 0.2

        ;stdcall Rectangle.Create, R3, -0.2, -0.3, 0.4, 0.2
        stdcall Texture.Create, buttonTexture
        mov [R1.texture], eax 
;        mov [R2.texture], eax
;        mov [R3.texture], eax
        invoke  glShadeModel, GL_SMOOTH
        invoke  glHint, GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST
        invoke  glEnable, GL_DEPTH_TEST
        invoke  glDepthFunc, GL_LESS 
        invoke  glEnable, GL_CULL_FACE
        invoke  glCullFace, GL_BACK 
        invoke  glFrontFace, GL_CCW

        fild [clientRect.right]
        fstp [clientRect.right]

        fild [clientRect.bottom]
        fstp [clientRect.bottom]

        ;invoke glOrtho, 0.0, 2880.0, 1800.0, 0.0, 0.0, 1.0
        ;invoke glGetFloatv, GL_PROJECTION, projection2D
        
        stdcall Matrix.Ortho, projection2D, -20.0, 20.0, -20.0, 20.0, 20.0, 100.0

        ;stdcall Object.SetPosition,R1, -0.5, -0.5, 0.0
        ;mov [R1.q.w], 10.0
        ;mov [R1.q.z], 0.1
        stdcall Light.Init
        stdcall Matrix.Projection, [aspect], [fovY], [zNear], [zFar], projection
        
        invoke  GetTickCount
        mov [startTime], eax

        ret
endp