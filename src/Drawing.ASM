proc Draw uses esi

        locals
                currentTime     dd    ?
                five dd 5.0
        endl

        invoke  GetTickCount
        mov     [currentTime], eax

        sub     eax, [time]
        cmp     eax, 10
       ; jle     .Skip

        mov     eax, [currentTime]
        mov     [time], eax

        stdcall Tick
      ;  stdcall UpdateMovement
.Skip:
        invoke  glClearColor, 0.6, 0.6, 1.0, 1.0
        invoke  glClear, GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT
        stdcall DrawObject, car, oPos, oTurn        
        invoke  SwapBuffers, [hdc]
        ret
endp

proc DrawObject, objPtr, posV, turnV
        stdcall Vector3.RotateY, lightPosition, [lightAngle], lightPosition
        
        stdcall Vector3.Translate, [turnV], [angleX], [angleZ], [angleY]
        
        mov [angleX], 0
        mov [angleY], 0
        mov [angleZ], 0

        invoke  glMatrixMode, GL_MODELVIEW 
        invoke  glLoadIdentity
        stdcall Matrix.LookAt, cameraPosition, targetPosition, upVector, view 
        invoke glGetFloatv, GL_MODELVIEW_MATRIX, view


        stdcall Matrix.CreatePosition, [posV], position
        ;stdcall Matrix.CreateScale, oScale, scale
        stdcall Matrix.CreateTurn, [turnV]
        stdcall Matrix.Multiply4x4, turn,  position, model
        stdcall Matrix.Multiply4x4,  scale, model,   model

        stdcall Matrix.Multiply4x4, view, projection, PV
        stdcall Matrix.Multiply4x4, model, PV, MVP

        invoke  glUseProgram, [program]
        
        invoke glUniformMatrix4fv, [MVPLocation], 1, GL_FALSE, MVP
      
        invoke glUniform3fv, [viewPosLocation], 1, cameraPosition
       
        invoke glUniform3fv, [lightPosLocation], 1, lightPosition
        invoke glUniform3fv, [objectColorLocation], 1, objectColor
        invoke glUniform3fv, [lightColorLocation], 1, lightColor
@@:     
        stdcall DrawMesh, [objPtr], [drawingMode]
        invoke  glUseProgram, 0
        ret
endp

proc DrawMesh uses esi,\
     mesh, flag

        mov     esi, [mesh]

        invoke glBindTexture, GL_TEXTURE_2D, [esi + Object.texture]
        invoke glBindVertexArray, [esi + Object.VAO]
                invoke  glDrawArrays, [flag], 0, [esi + Mesh.verticesCount] 
        invoke glBindVertexArray, 0
        invoke glBindTexture, GL_TEXTURE_2D, 0

        ret
endp

proc Tick
    fld     [angle]        
    fadd    [stepp]        
    fcom   [circleD]      
    fstsw   ax              
    sahf                    
    ja     @F  
    fstp    [angle]         
    ret

@@:
    fstp    [angle]        
    mov     [angle], 0.0
    ret
endp