proc Draw uses esi

        locals
                currentTime     dd    ?
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
        stdcall Vector3.RotateY, lightPosition, [lightAngle], lightPosition
 
        invoke  glMatrixMode, GL_MODELVIEW 
        invoke  glLoadIdentity
        stdcall Matrix.LookAt, cameraPosition, targetPosition, upVector, view 
        
        invoke glGetFloatv, GL_MODELVIEW_MATRIX, view

        stdcall Vector3.Translate, oTurn, [angleX], [angleZ], [angleY]
        

        stdcall DrawObject, car, oPos, oTurn, oScale   

        stdcall DrawObject, table, oPos2, oTurn2, oScale

        invoke  SwapBuffers, [hdc]
        ret
endp

proc PushMatrix

        

        ret
endp

proc PopMatrix, matrix

        memcpy MVP, tempMatrix, sizeof.Matrix4x4

        ret
endp

proc DrawObject uses esi, objPtr, posV, turnV, scaleV 
        memcpy tempMatrix, MVP, sizeof.Matrix4x4

        stdcall Matrix.CreatePosition, [posV], position
        stdcall Matrix.CreateScale, [scaleV], scale
        stdcall Matrix.CreateTurn, [turnV]
        
        stdcall Matrix.Multiply4x4, turn, position, model
        stdcall Matrix.Multiply4x4, scale, model, model
        stdcall Matrix.Multiply4x4, view, projection, PV
        stdcall Matrix.Multiply4x4, model, PV, MVP

        stdcall Matrix.Multiply4x4, turn, model, model  ; Rotate the model's axes

        invoke  glUseProgram, [program]
        
        invoke glUniformMatrix4fv, [MVPLocation], 1, GL_FALSE, MVP
      
        invoke glUniform3fv, [viewPosLocation], 1, cameraPosition
       
        invoke glUniform3fv, [lightPosLocation], 1, lightPosition
        invoke glUniform3fv, [objectColorLocation], 1, objectColor
        invoke glUniform3fv, [lightColorLocation], 1, lightColor
@@:     
        stdcall DrawMesh, [objPtr], [drawingMode]
        invoke  glUseProgram, 0
        
        memcpy MVP, tempMatrix, sizeof.Matrix4x4
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