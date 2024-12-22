proc UI.DrawMainMenu uses esi, buttons
  locals
    ten dd 1000.0
  endl
    stdcall	 GetRandomNumber, 1, 30
    mov [car.acceleration], eax
    fild [car.acceleration]
    fdiv [ten]
    fstp [car.acceleration]
    stdcall Physics.Update, 0.07, cubeSpline, car
    ;stdcall Spline.GetPoint, cubeSpline, car,  [programTime]
    ;stdcall Spline.GetRotation, cubeSpline, car,  [programTime]                                                               
  
    stdcall Matrix.LookAt2, lightPosition, car.transform.position, upVector, view1
    stdcall Matrix.Multiply4x4, view1, lightProjection,  lightSpaceMatrix
    
    invoke glViewport, 0, 0, SHADOW_WIDTH, SHADOW_HEIGHT
  
    invoke glBindFramebuffer, GL_FRAMEBUFFER, [depthMapFBO]
        invoke glClear, GL_DEPTH_BUFFER_BIT
         invoke glUseProgram, [depthShader]
         invoke glUniformMatrix4fv, [lightSpaceMatrixLocation2], 1, GL_FALSE, lightSpaceMatrix 
         invoke glActiveTexture, GL_TEXTURE0
    invoke glBindTexture, GL_TEXTURE_2D, [depthMap]
    stdcall RenderScene, [depthShader]
    invoke glBindFramebuffer, GL_FRAMEBUFFER, 0
    
    invoke  glClearColor, 0.6, 0.6, 1.0, 1.0

    invoke  glClear, GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT
        
    invoke  glViewport, 0, 0, [clientRect.right], [clientRect.bottom]

    stdcall Matrix.LookAt2, tempCameraVector,  car.transform.position, upVector, view
    
    invoke glUseProgram, [program]
    invoke glUniformMatrix4fv, [projectionLocation], 1, GL_FALSE, projection
    invoke glUniformMatrix4fv, [viewLocation], 1, GL_FALSE, view
    invoke glUniformMatrix4fv, [lightSpaceMatrixLocation], 1, GL_FALSE, lightSpaceMatrix
    invoke glActiveTexture, GL_TEXTURE0
    invoke glBindTexture, GL_TEXTURE_2D, [depthMap]
    stdcall RenderScene, [program]


    invoke glUseProgram, [program2D]
    invoke glEnable, GL_ALPHA_TEST
  
    invoke glUniformMatrix4fv, [projectionLocation2D], 1, GL_FALSE, projection2D
        mov esi, [buttons]

    stdcall Button.Draw, [esi]
    stdcall Button.Draw, [esi + 4]
    stdcall Button.Draw, [esi + 8]
     stdcall Sprite.Draw2, carRect
        stdcall Sprite.DrawText, R1, logoMessage, -9.0, 7.0, WHITE_COLOR, 1.2
        invoke glDisable, GL_ALPHA_TEST

    ret
endp

proc UI.StartRender
   
  ;stdcall Matrix.LookAt, menuPosition, menuTargetPosition, upVector 
 
   
  invoke glUseProgram, 0  

  ret
endp   

proc UI.EndRender
  
  invoke  glEnable, GL_DEPTH_TEST
  invoke glUseProgram, [program]
  
 
  invoke  glMatrixMode, GL_MODELVIEW 
  invoke  glLoadMatrixf, view
  
  ;memcpy MVP, tempMatrix, sizeof.Matrix4x4      
  ret
endp   


proc Rectangle.Init uses esi, objPtr
    locals 
      vao dd ?
      vbo dd ?
    endl   

  mov esi, [objPtr]
  add esi, Object.VAO
  invoke glGenVertexArrays, 1, esi      
  invoke glBindVertexArray, [esi]

  lea eax, [vbo]
  invoke glGenBuffers, 1, eax
  invoke glBindBuffer, GL_ARRAY_BUFFER, [vbo]
  invoke glBufferData, GL_ARRAY_BUFFER, 32, rectangleV, GL_STATIC_DRAW

  invoke glEnableVertexAttribArray, 0
    
  invoke glVertexAttribPointer, 0, 2, GL_FLOAT, GL_FALSE, 0, 0

  invoke glBindVertexArray, 0
  ret
endp

proc UI.SetActiveButton uses esi, buttons, number
   
    mov eax, [number] 
    shl eax, 2        
            
    mov esi, [buttons]
    add esi, eax      

    mov eax, [esi]    
    mov esi, eax      

    
    mov [esi + Button.isActive], 1
    mov [esi + Button.textColor], WHITE_COLOR  
    stdcall Object.SetPosition, carRect, 0.0, [esi + Button.position.y], 0.0
    ;stdcall Rectangle.Create, carRect, -10.0, [esi + Button.position.y], 1.0, 1.0
   
           
    ret
endp

proc UI.SetDeactiveButton uses esi, buttons,  number
    mov eax, [number]   
    shl eax, 2          
    
    mov esi, [buttons]
        
    mov eax, [esi + eax]      
    mov esi, eax        

    mov [esi + Button.isActive], 0     
    mov [esi + Button.textColor], GRAY_COLOR

    ret
endp


proc Rectangle.Create uses esi ,\
                    objPtr, x, y, width, heigth

    locals
      vao dd ?
      vbo dd ?
      tao dd ?
      buffer dd ?
      char db 0
      charSize dd 0.0625
      sixteen dd 16.0
      x1 dd 0
      y1 dd 4
      left dd ?
      right dd ?
      top dd ?
      bottom dd ?
    endl
    
    malloc 32


    mov [buffer], eax
    mov esi, eax

   
    mov eax, [x]
    mov dword[esi], eax

    mov eax, [y]
    mov dword[esi + 4], eax

    add esi, 8
    fld [x]
    fadd [width]
    fstp dword[esi]

    add esi, 4
    mov eax, [y]
    mov dword[esi], eax

    add esi, 4
    fld [x]
    fadd [width]
    fstp dword[esi]

    add esi, 4
    fld [y]
    fadd [heigth]
    fstp dword[esi]
    
    add esi, 4
    mov eax, [x]
    mov dword[esi], eax

    add esi, 4
    fld [y]
    fadd [heigth]
    fstp dword[esi]

    lea eax, [vao]
    invoke glGenVertexArrays, 1, eax   
    invoke glBindVertexArray, [vao]

    lea eax, [vbo]
    invoke glGenBuffers, 1, eax
    invoke glBindBuffer, GL_ARRAY_BUFFER, [vbo]

    invoke glBufferData, GL_ARRAY_BUFFER, 32, [buffer], GL_DYNAMIC_DRAW
    invoke glEnableVertexAttribArray, 0
    
    invoke glVertexAttribPointer, 0, 2, GL_FLOAT, GL_FALSE, 0, 0

    lea eax, [tao]
    invoke glGenBuffers, 1, eax
    invoke glBindBuffer, GL_ARRAY_BUFFER, [tao]

    invoke glBufferData, GL_ARRAY_BUFFER, 32, textCoords, GL_DYNAMIC_DRAW

    invoke glEnableVertexAttribArray, 1
    
    invoke glVertexAttribPointer, 1, 2, GL_FLOAT, GL_FALSE, 0, 0
        
    invoke glBindVertexArray, 0


    mov esi, [objPtr]
    mov eax, [vao]
    mov [esi + Object.VAO], eax
    ;add esi, Object.transform
    mov [esi + Object.transform.position.x], 0.0
    mov [esi + Object.transform.position.y], 0.0
    mov [esi + Object.transform.position.z], 0.0

    mov [esi + Object.transform.rotation.x], 0.0
    mov [esi + Object.transform.rotation.y], 0.0
    mov [esi + Object.transform.rotation.z], 0.0

    mov [esi + Object.transform.scale.x], 1.0
    mov [esi + Object.transform.scale.y], 1.0
    mov [esi + Object.transform.scale.z], 1.0

    mov [esi + Object.q.x], 0.0
    mov [esi + Object.q.y], 0.0
    mov [esi + Object.q.z], 0.0
    mov [esi + Object.q.w], 0.0
    ret
endp


proc Text.Render uses esi edi,\
                    text, vao, x, y, width, heigth

    locals
      tao dd ?
      buffer dd ?
      char dd 0
      charSize dd 0.0625
      sixteen dd 16.0

      x1 dd 0
      y1 dd 4
      left dd ?
      right dd ?
      top dd ?
      bottom dd ?
    endl
    
    mov edi, [text]


    cmp [edi], 0
    je .endl


    mov eax, [edi]
    shr eax, 4
    mov [y1], eax

    mov eax, [edi]
    and eax, 1111b
    mov [x1], eax


    fild [x1]
    fmul [charSize]
    fst [left]

    fadd [charSize]

    fstp [right]

    fild [y1]
    fmul [charSize]
    fst [top]
    fadd [charSize]
    fstp [bottom]
;0
    mov esi , textCoords
    mov eax, [left]
    mov [esi], eax

    add esi, 4
    mov eax, [bottom]
    mov [esi], eax

    add esi, 4
    mov eax, [right]
    mov [esi], eax

    add esi, 4
    mov eax, [bottom]
    mov [esi], eax

    add esi ,4
    mov eax, [right]
    mov [esi], eax

    add esi, 4
    mov eax, [top]
    mov [esi], eax

    add esi, 4
    mov eax, [left]
    
    mov [esi], eax

    add esi, 4
    mov eax, [top]
    mov [esi], eax

    malloc 32


    mov [buffer], eax
    mov esi, eax

   
    mov eax, [x]
    mov dword[esi], eax

    mov eax, [y]
    mov dword[esi + 4], eax

    add esi, 8
    fld [x]
    fadd [width]
    fstp dword[esi]

    add esi, 4
    mov eax, [y]
    mov dword[esi], eax

    add esi, 4
    fld [x]
    fadd [width]
    fstp dword[esi]

    add esi, 4
    fld [y]
    fadd [heigth]
    fstp dword[esi]
    
    add esi, 4
    mov eax, [x]
    mov dword[esi], eax

    add esi, 4
    fld [y]
    fadd [heigth]
    fstp dword[esi]

    invoke glBindVertexArray, [vao]

    lea eax, [tao]
    invoke glGenBuffers, 1, eax
    invoke glBindBuffer, GL_ARRAY_BUFFER, [tao]

    invoke glBufferData, GL_ARRAY_BUFFER, 32, textCoords, GL_STATIC_DRAW


    invoke glEnableVertexAttribArray, 1
    
    invoke glVertexAttribPointer, 1, 2, GL_FLOAT, GL_FALSE, 0, 0
        
    invoke glBindVertexArray, 0


    invoke glBindVertexArray, [R2.VAO]
      invoke  glDrawArrays, 6, 0, 4
    invoke glBindVertexArray, 0

.endl:

    ret
endp


proc UI.Pause
      cmp [GAME_MODE], GAME
      je @F
      mov [GAME_MODE], GAME
      stdcall UI.EndRender
      
      ret
@@:
      mov [GAME_MODE], PAUSEMENU
      stdcall UI.StartRender
    ret
endp

proc UI.Unpause

  ret
endp