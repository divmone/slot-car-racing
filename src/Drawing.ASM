proc Draw
     locals 
                tempTime dd 0.0
                oneSecond dd 1000.0
        endl
        invoke  GetTickCount
        mov     [currentTime], eax
        sub     eax, [startTime]
        mov     [nprogramTime], eax

        fild    [nprogramTime]
        fdiv    [oneSecond]
        fstp    [programTime]

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
    
    ;invoke glDisable, GL_DEPTH_TEST

    stdcall FloatToStr, [car.speed], 3
    stdcall Rectangle.CreateText, R1, eax, -10.0, 9.0, 0.0, 1.0
    
    inc [counter];invoke glEnable, GL_DEPTH_TEST

    invoke  SwapBuffers, [hdc]  
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
    invoke glBindVertexArray, 0
    invoke glBindTexture, GL_TEXTURE_2D, 0
    ret
@@:
    invoke glUniform1i, [useInstancingLocation], 1
    invoke glActiveTexture, GL_TEXTURE1
    invoke glBindTexture, GL_TEXTURE_2D, [esi + Object.texture]
    invoke glBindVertexArray, [esi + Object.VAO]
            invoke  glDrawArraysInstanced, [flag], 0, [esi + Mesh.verticesCount], [instanseAmount]
    invoke glBindVertexArray, 0
    invoke glBindTexture, GL_TEXTURE_2D, 0

    ret
endp

proc Sprite.Draw uses esi, objPtr   

    stdcall Matrix.CreateModel, [objPtr]

    invoke glUseProgram, [program2D]
    invoke glUniformMatrix4fv, [modelLocation3], 1, GL_FALSE, model
    invoke glUniformMatrix4fv, [projectionLocation2D], 1, GL_FALSE, projection2D
    
    mov esi, [objPtr]
    invoke glActiveTexture, GL_TEXTURE0
    invoke glBindTexture, GL_TEXTURE_2D, [esi + Object.texture]
    invoke glBindVertexArray, [esi + Object.VAO]
            invoke  glDrawArrays, 6, 0, 6
    invoke glBindVertexArray, 0
    invoke glBindTexture, GL_TEXTURE_2D, 0
    
    ret
endp

