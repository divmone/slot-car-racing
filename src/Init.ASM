proc Init uses esi
        locals
                hMainWindow     dd              ?

                vbo dd ?
                value dd 11.4
        endl
        stdcall Glext.LoadFunctions
        invoke  GetProcessHeap
        mov     [hHeap], eax

        invoke  RegisterClass, wndClass
        invoke  CreateWindowEx, ebx, className, className, POP_IT,\
                        ebx, ebx, ebx, ebx, ebx, ebx, ebx, ebx
        mov     [hMainWindow], eax


        invoke  GetClientRect, eax, clientRect
        invoke GetSystemMetrics, SM_CXSCREEN
        invoke  ShowCursor, 0
        invoke  GetTickCount
        mov     [time], eax

        invoke  GetDC, [hMainWindow]
        mov     [hdc], eax
        
        ;stdcall  PrintToConsole, okMessage + 1, okMessage.size - 1
    

        invoke  ChoosePixelFormat, [hdc], pfd
        invoke  SetPixelFormat, [hdc], eax, pfd

        invoke  wglCreateContext, [hdc]
        invoke  wglMakeCurrent, [hdc], eax

        invoke  glViewport, ebx, ebx, [clientRect.right], [clientRect.bottom]
        fild    [clientRect.right]      
        fidiv   [clientRect.bottom]   
        fstp    [aspect]

        invoke CreateThread, 0, 0, IntToStrThread, 0, 0, 0
        invoke CreateThread, 0, 0, PhysicsThread, 0, 0, 0

        stdcall Glext.LoadFunctions
        stdcall Glext.CreateShader, depthVShaderFile, depthFShaderFile 
        mov [depthShader], eax

        stdcall Glext.CreateShader, roadVShaderFile, roadFShaderFile 
        mov [roadShader], eax
        
        stdcall Glext.CreateShader, spriteVShaderFile, spriteFShaderFile 
        mov [spriteShader], eax
        
        stdcall Glext.CreateShaders 
        stdcall Glext.CreateShaders2D  

      
        ;invoke  PlaySound, musicPath, NULL,0x0008 or 0x00020000 or 0x0001
        
        stdcall Object.Create, car, fileName, textPath
        stdcall Object.Create, car2, fileName2, textPath2
        ;stdcall Object.Create, nissan, fileNameN, textPathN
        stdcall Object.Create, table, fileNameT, textPathT
        stdcall Object.Create, track, fileNameTr, textPathTr
        stdcall Object.Create, road, fileNameR, textPathR
        stdcall Object.Create, sphere, fileNameS, textPathS
        stdcall Object.Create, arch, fileNameA, textPathA
        stdcall Object.Create, grass, fileNameG, textPathG


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
        stdcall Object.SetPosition, track, 0.0, -140.0, 50.0 
        stdcall Object.SetPosition, table, 0.0, 100.0, 0.0
        stdcall Object.SetRotation, track, 0.0, 90.0, 0.0 

        stdcall Object.SetPosition, grass, 0.0, 0.0, 0.0  
        ;stdcall Object.SetScale, car, 10.0, 10.0, 10.0
        stdcall Object.SetScale, grass, 6.0, 6.0, 6.0
        stdcall Object.SetScale, arch, 0.4, 0.4, 0.4
        stdcall Object.SetScale, books, 0.45, 0.45, 0.45
        stdcall Object.SetScale, table, 50.0, 50.0, 50.0
        stdcall Object.SetScale, pens, 2.0, 2.0, 2.0
        stdcall Object.SetScale, track, 50.0, 50.0, 50.0
        stdcall Object.SetPosition, table, 7.0, -163.0, 0.0
        ;stdcall Object.SetRotation, road, 20.0, -10.0, 0.0
        stdcall Object.InitModelMatrix, car
        stdcall Object.InitModelMatrix, road
        
        stdcall Object.SetMaterial, car, carAmbient, carDiffuse, carSpecular, carShinine

        ;stdcall Quaternion.CreateFromAxisAngle, car, 0.0, 1.0, 0.0, 0.0
        ;stdcall Quaternion.CreateFromAxisAngle, road, 0.0, 1.0, 0.0, 0.0
        ;
 
        stdcall Quaternion.CreateFromAxisAngle, R1, 0.0, 0.0, 0.0, 0.0
        ;stdcall Quaternion.CreateMatrix, road, road.rmatrix
        ;stdcall Quaternion.CreateMatrix, R1,  R1.rmatrix

        invoke glGetUniformLocation, [program2D], modelName2D
        mov [modelLocation2D], eax

        invoke glUseProgram, [depthShader]
        invoke glGetUniformLocation, [depthShader], lightSpaceMatrixName
        mov [lightSpaceMatrixLocation2], eax
        
        invoke glGetUniformLocation, [depthShader], depthMapName
        mov [depthMapLocation1], eax

        invoke glGetUniformLocation, [depthShader], modelName
        mov [modelLocation2D], eax
        
        invoke glUseProgram, [program]

        invoke glGetUniformLocation, [program], texName
        mov [texLocation], eax

        invoke glGetUniformLocation, [program], depthMapName
        mov [depthMapLocation], eax


        invoke glUseProgram, [roadShader]
        invoke glGetUniformLocation, [roadShader], viewName
        mov [viewLocation2], eax
        invoke glGetUniformLocation, [roadShader], projectionName
        mov [projectionLocation2], eax
        invoke glGetUniformLocation, [roadShader], modelName
        mov [lightSpaceMatrixLocation3], eax
        invoke glGetUniformLocation,[roadShader], lightPosName
        mov [lightPosLocation2], eax
        invoke glGetUniformLocation,[roadShader], viewPosName
        mov [viewPosLocation2], eax
        invoke glGetUniformLocation, [roadShader], modelName
        mov [modelLocation2], eax
        invoke glGetUniformLocation, [roadShader], texName
        mov [texLocation2], eax
        invoke glGetUniformLocation, [roadShader], depthMapName
        mov [depthMapLocation2], eax

        invoke glUseProgram, [program2D]
         invoke glGetUniformLocation, [program2D], modelName2D
        mov [modelLocation3], eax
        invoke glGetUniformLocation, [program2D], projectionName2D
        mov [projectionLocation2D], eax
        invoke glGetUniformLocation, [program2D], colorName
        mov [colorNameLocation], eax



        invoke glUseProgram, [program]
        invoke glUniform3fv, [lightPosLocation], 1, lightPosition
        invoke glUniform3fv, [viewPosLocation], 1, cameraPosition
        invoke glUniform1i, [depthMapLocation], 0
        invoke glUniform1i, [texLocation], 1
        
        invoke glUseProgram, [spriteShader]
        
        invoke glGetUniformLocation, [spriteShader], modelName2D
        mov [modelLocationSprite], eax
        invoke glGetUniformLocation, [spriteShader], projectionName2D
        mov [projectionLocation2DSprite], eax
       
        stdcall Rectangle.Create, R1, 0.0, 0.0, 1.0, 1.0
        stdcall Object.SetPosition, R1, -9.0, 9.0, 0.0
        stdcall Object.SetScale, R1, 1.3, 2.0, 1.0

        stdcall Rectangle.Create, R3, 0.0, 0.0, 0.7, 0.7
        stdcall Object.SetPosition, R3, -6.0, -5.0, 0.0
        ;stdcall Object.SetScale, R3, 1.3, 2.0, 1.0

        stdcall Rectangle.Create, R4, 0.0, 0.0, 0.7, 1.0
        stdcall Object.SetPosition, R4, -5.0, 9.0, 0.0
        stdcall Object.SetScale, R4, 1.3, 2.0, 1.0

        stdcall Rectangle.Create, R2, 0.0, 0.0, 1.0, 1.0
        stdcall Object.SetPosition, R2, -10.0, 9.0, 0.0

        stdcall Rectangle.Create, splashRect, -3.5, -3.5, 7.0, 7.0
        stdcall Object.SetPosition, splashRect, 0.0, 0.0, 0.0
        
        stdcall Rectangle.Create, carRect, -10.0, 0.0, 1.0, 1.0
        
        

        stdcall Texture.CreateRGBA, carTexture, 512, 512
        mov [carRect.texture], eax

        stdcall Texture.CreateRGBA, fontTexture, 512, 512
        mov [R1.texture], eax 
        mov [R2.texture], eax 
        mov [R3.texture], eax
        

        stdcall Texture.Create, splashTexture
        mov [splashRect.texture], eax
        

        stdcall Button.Create, startButton, -9.0, -4.0, startMessage, BLACK_COLOR, GRAY_COLOR
        stdcall Button.Create, settingsButton, -9.0, -6.0, settingsMessage, BLACK_COLOR, GRAY_COLOR
        stdcall Button.Create, exitButton, -9.0, -8.0, exitMessage, BLACK_COLOR, GRAY_COLOR
        
        stdcall Button.Create, timeGameButton, -9.0, -4.0, timeGameMessage, BLACK_COLOR, GRAY_COLOR
        stdcall Button.Create, botGameButton, -9.0, -6.0, botGameMessage, BLACK_COLOR, GRAY_COLOR
        stdcall Button.Create, driveAtarGameButton, -9.0, -8.0, driveAtarGameMessage, BLACK_COLOR, GRAY_COLOR

        stdcall Button.Create, firstModeButton, -9.0, -4.0, firstModeMessage, BLACK_COLOR, GRAY_COLOR
        stdcall Button.Create, secondModeButton, -9.0, -6.0, secongModeMessage, BLACK_COLOR, GRAY_COLOR
        stdcall Button.Create, thirdModeButton, -9.0, -8.0, thirdModeMessage, BLACK_COLOR, GRAY_COLOR


        invoke glAlphaFunc, GL_GREATER, 0.9

        invoke  glHint, GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST
        invoke  glEnable, GL_DEPTH_TEST
        invoke  glDepthFunc, GL_LESS 
        ;Binvoke  glEnable, GL_CULL_FACE
        ;invoke  glCullFace, GL_BACK 
        invoke  glFrontFace, GL_CCW
        invoke glEnable, GL_MULTISAMPLE  
        stdcall Track.InitArray
        stdcall Spline.GetPoint, cubeSpline, arch.transform.position, 0.0
        stdcall Spline.GetRotation, cubeSpline, arch, 0.0                                                                      

        ; stdcall Object.SetPosition, R1, 0.0, 1.0, 0.0
        ;stdcall Object.SetScale, R1, 0.2, 0.2, 0.2
        ; stdcall Object.SetScale, R2, 0.2, 0.2, 0.2
        ; stdcall Object.SetScale, R3, 0.2, 0.2, 0.2
        stdcall Matrix.Ortho, lightProjection, -1.0, 1.0, -1.0, 1.0, 1.0, 7.5
        stdcall Matrix.Ortho, projection2D, -10.0, 10.0, -10.0, 10.0, 1.0, 10.0
        stdcall Matrix.Projection, [aspect], [fovY], [zNear], [zFar], projection
        stdcall Light.Init
        mov [road.useInstancing], 1
        
        stdcall UI.SetActiveButton, menuButtons,0

        invoke CreateThread, 0, 0, SplashTimerThread, 0, 0, 0
        ret
endp


proc MatrixThread1
.loop: 

    stdcall Matrix.LookAt2, lightPosition, car.transform.position, upVector, view1
    stdcall Matrix.Multiply4x4, view1, lightProjection,  lightSpaceMatrix

    jmp .loop
endp

proc MatrixThread3
.loop: 

   stdcall Matrix.LookAt2, tempCameraVector,  car.transform.position, upVector, view
    
    jmp .loop
endp


proc PhysicsThread, lpParam
.loop: 
    invoke Sleep, 1
    stdcall Object.CheckLap, car
    mov [car.lapCount], eax
    stdcall Physics.Update, 0.07, cubeSpline, car
    jmp .loop
endp

proc IntToStrThread, lpParam

.loop:
      invoke Sleep, 1
      stdcall IntToStr, [car.lapCount]
      mov [lapCountStr], eax
      stdcall IntToStr, [globalTimer]
      mov [globalTimerStr], eax

      cmp [EXIT], 1
      jne .loop
      invoke ExitThread, 0

endp


proc DecrementThread, lpParam
.threadLoop:
    invoke Sleep, 1000
    dec [globalTimer]
    cmp [globalTimer], 0
    jg .threadLoop           
    mov [GAME_MODE], ENDGAME
    invoke ExitThread, 0
endp


proc SplashTimerThread, lpParam
.threadLoop:
    invoke Sleep, 10
    stdcall Vector3.AddValue, splachColor, 0.01
    dec [globalTimer]
    cmp [globalTimer], 50
    jg .threadLoop

 .threadLoop1:
    invoke Sleep, 10
    stdcall Vector3.SubValue, splachColor, 0.01
    dec [globalTimer]
    cmp [globalTimer], 0
    jg .threadLoop1    
    
             
    mov [GAME_MODE], MAINMENU
    invoke ExitThread, 0
endp