proc Draw

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
        invoke  glMatrixMode, GL_MODELVIEW
        
       invoke  glLoadIdentity
        ;stdcall  gf_get_camera_lookvec, 
       ; stdcall Matrix.Rotate, view, 10.0, upVector
        stdcall Matrix.LookAt, cameraPosition, targetPosition, upVector, view 

       
        invoke glGetFloatv, GL_MODELVIEW_MATRIX, view
        stdcall Vector3.RotateY, lightPosition, [lightAngle], lightPosition
        stdcall Vector3.Translate, oTurn, [angleX], [angleZ], [angleY]

        ;stdcall Vector3.Normalize, oTurn
        mov [angleX], 0
        mov [angleY], 0
        mov [angleZ], 0

        stdcall Matrix.CreatePosition, oPos, position
        ;stdcall Matrix.CreateScale, oScale, scale
        stdcall Matrix.CreateTurn, oTurn
        stdcall Matrix.Multiply4x4, turn,  position, model
        stdcall Matrix.Multiply4x4,  model, scale,   model

        stdcall Matrix.Multiply4x4, view, projection, PV
        stdcall Matrix.Multiply4x4, model, PV, MVP

        invoke  glUseProgram, [program]
        
        invoke glUniformMatrix4fv, [MVPLocation], 1, GL_FALSE, MVP
      
        invoke glUniform3fv, [viewPosLocation], 1, cameraPosition
       
        invoke glUniform3fv, [lightPosLocation], 1, lightPosition
        invoke glUniform3fv, [objectColorLocation], 1, objectColor
        invoke glUniform3fv, [lightColorLocation], 1, lightColor
 
@@:     

        ;stdcall DrawMesh, car, [drawingMode], [containerVAO]

       ; invoke glTranslatef, 10.0, 40.0, 10.0

        stdcall DrawMesh, plane, [drawingMode], [containerVAOPlane]
        invoke  glUseProgram, 0
        

        invoke  SwapBuffers, [hdc]

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

proc DrawMesh uses esi,\
     mesh, flag, VAO

        mov     esi, [mesh]

        invoke glBindTexture, GL_TEXTURE_2D, [texture]
        invoke glBindVertexArray, [VAO]
                invoke  glDrawArrays, [flag], ebx, [esi + Mesh.verticesCount] 
        invoke glBindVertexArray, 0
        invoke glBindTexture, GL_TEXTURE_2D, 0

        ret
endp