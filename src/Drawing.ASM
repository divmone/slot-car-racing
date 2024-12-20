proc Draw     
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
    invoke glClear, GL_DEPTH_BUFFER_BIT
    invoke glUniformMatrix4fv, [projectionLocation2D], 1, GL_FALSE, projection2D
        stdcall IntToStr, [car.lapCount] 
        stdcall Sprite.DrawText, R2, eax, -9.0, 9.0, WHITE_COLOR
        invoke glDisable, GL_ALPHA_TEST
        ;stdcall Sprite.Draw, R1, ORANGE_COLOR
    ret
endp


proc DrawMenu

    invoke glUseProgram, [program2D]
    invoke glEnable, GL_ALPHA_TEST
    invoke glClear, GL_DEPTH_BUFFER_BIT
    invoke glUniformMatrix4fv, [projectionLocation2D], 1, GL_FALSE, projection2D
        stdcall Button.Draw, startButton
        stdcall Button.Draw, settingsButton
        stdcall Button.Draw, exitButton
        invoke glDisable, GL_ALPHA_TEST
        ;stdcall Sprite.Draw, R1, ORANGE_COLOR
    
    ret
endp

proc DrawMainMenu
    
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

    stdcall Matrix.LookAt2, cameraPosition,  car.transform.position, upVector, view
    
    invoke glUseProgram, [program]
    invoke glUniformMatrix4fv, [projectionLocation], 1, GL_FALSE, projection
    invoke glUniformMatrix4fv, [viewLocation], 1, GL_FALSE, view
    invoke glUniformMatrix4fv, [lightSpaceMatrixLocation], 1, GL_FALSE, lightSpaceMatrix
    invoke glActiveTexture, GL_TEXTURE0
    invoke glBindTexture, GL_TEXTURE_2D, [depthMap]
    
    stdcall Object.Draw, road, [shader]
    stdcall Object.Draw, car,  [shader]      
    stdcall Object.Draw, table, [shader] 

    stdcall DrawMenu

    ret
endp

proc RenderScene uses esi, shader
    locals 
        dist dd 10.0
        dist1 dd 10.0
        toDegree dd 180.0
    endl  
          
    ;invoke CreateThread, 0, 0, ThreadWrapper, arg, 0, threadId

    cmp [CAMERA_MODE], 1
    jne @F
    fldpi
    fmul [tempAngle3]
    fdiv [toDegree]
    
    fstp [angle]

    fld [car.transform.position.z] 
    fld [dist]                     
    fsubp                        
    fstp [tempCameraVector.z]

    fld [car.transform.position.y] 
    fld [dist1]                    
    faddp                          
    fstp [tempCameraVector.y]

    fld [car.transform.position.x]
    fstp [tempCameraVector.x]
    
    stdcall Object.Draw, road, [shader]
    stdcall Object.Draw, car,  [shader] 
    stdcall Object.Draw, car2,  [shader]       
    stdcall Object.Draw, table, [shader] 
    stdcall Object.Draw, track, [shader]
    stdcall Object.Draw, arch, [shader] 
    
    ret
endp

proc Object.Draw uses esi, objPtr, shader
    ;memcpy tempMatrix, MVP, sizeof.Matrix4x4

    stdcall Matrix.CreateModel, [objPtr]
    mov eax, [shader]
    cmp eax, [depthShader]
    jne @F
    invoke glUniformMatrix4fv, [modelLocation2D], 1, GL_FALSE, model 
    stdcall DrawMesh, [objPtr], [drawingMode]
    ret
@@:

    invoke glUniformMatrix4fv, [modelLocation], 1, GL_FALSE, model  
    stdcall DrawMesh, [objPtr], [drawingMode]
    ret
endp  
  
proc DrawMesh uses esi,\
    mesh, flag

    mov esi, [mesh]
    cmp [esi + Object.useInstancing], 1
    je @f
    invoke glUniform1i, [useInstancingLocation], 0
  
    invoke glActiveTexture, GL_TEXTURE1
    invoke glBindTexture, GL_TEXTURE_2D, [esi + Object.texture]
    invoke glBindVertexArray, [esi + Object.VAO]
            invoke  glDrawArrays, [flag], 0, [esi + Mesh.verticesCount]

    ret
@@:
    invoke glUniform1i, [useInstancingLocation], 1
    invoke glActiveTexture, GL_TEXTURE1
    invoke glBindTexture, GL_TEXTURE_2D, [esi + Object.texture]
    invoke glBindVertexArray, [esi + Object.VAO]
            invoke  glDrawArraysInstanced, [flag], 0, [esi + Mesh.verticesCount], [instanseAmount]
    ret
endp

proc Sprite.Draw uses esi, objPtr, color 

    stdcall Matrix.CreateModel, [objPtr]

    invoke glUseProgram, [program2D]
    invoke glUniformMatrix4fv, [modelLocation3], 1, GL_FALSE, model
    invoke glUniformMatrix4fv, [projectionLocation2D], 1, GL_FALSE, projection2D
    invoke glUniform3fv, [colorNameLocation], 1, [color]
    mov esi, [objPtr]
    invoke glActiveTexture, GL_TEXTURE0
    invoke glBindTexture, GL_TEXTURE_2D, [esi + Object.texture]
    invoke glBindVertexArray, [esi + Object.VAO]
            invoke  glDrawArrays, 6, 0, 6
    invoke glBindVertexArray, 0
    invoke glBindTexture, GL_TEXTURE_2D, 0
    
    ret
endp


proc Sprite.DrawText uses esi edi ebx,\
                    objPtr, text, x, y, color

    locals
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
      xpos dd 0.0
      step dd 1.0
    endl
    
    mov esi, [objPtr]
    invoke glBindVertexArray, [esi + Object.VAO] 
    lea eax, [tao]
    invoke glGenBuffers, 1, eax
    invoke glBindBuffer, GL_ARRAY_BUFFER, [tao]

    mov edi, [text]

.loop:
    cmp byte[edi], 0
    je .endl
  
    xor eax, eax
    mov al, byte[edi]
    shr eax, 4
    mov [y1], eax


    mov al, byte[edi]
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
   
    mov ebx, textCoords    
    
    movss xmm0, [left]       
    movss xmm1, [bottom]     
    movss xmm2, [right]      
    movss xmm3, [top]        

    movups [ebx], xmm0     
    movups [ebx + 4], xmm1
    movups [ebx + 8], xmm2
    movups [ebx + 12], xmm1

    movups [ebx + 16], xmm2
    movups [ebx + 20], xmm3
    movups [ebx + 24], xmm0
    movups [ebx + 28], xmm3


    invoke glBufferData, GL_ARRAY_BUFFER, 32, textCoords, GL_DYNAMIC_DRAW

    invoke glEnableVertexAttribArray, 1
    
    invoke glVertexAttribPointer, 1, 2, GL_FLOAT, GL_FALSE, 0, 0
        
    stdcall Object.SetPosition, esi, [x], [y], 0.0
    stdcall Matrix.CreateModel, esi
    invoke glUniform3fv, [colorNameLocation], 1, [color]
    invoke glUniformMatrix4fv, [modelLocation3], 1, GL_FALSE, model
        invoke glActiveTexture, GL_TEXTURE0
        invoke glBindTexture, GL_TEXTURE_2D, [esi + Object.texture]
                invoke  glDrawArrays, 6, 0, 4
        
    inc edi
    movss xmm0, dword [x]      
    addss xmm0, dword [step]   
    movss dword [x], xmm0 
    
    jmp .loop
.endl:
    ret
endp

