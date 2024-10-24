proc Draw

        locals
                currentTime     dd      ?
                 tempFloat       dd      ? 
                speed     GLfloat 0.0  
                mposX   GLfloat 0.0  
                mposY   GLfloat 0.0  
                mposZ   GLfloat 0.0  
        endl

        invoke  GetTickCount
        mov     [currentTime], eax

        sub     eax, [time]
        cmp     eax, 10
        jle     .Skip

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

        stdcall Vector3.Translate, oTurn, [angleX], [angleY], [angleZ]

        stdcall Matrix.CreatePosition, oPos, position
        stdcall Matrix.CreateScale, oScale, scale
        stdcall Matrix.CreateTurn, oTurn
        stdcall Matrix.Multiply4x4, turn, model, model
        stdcall Matrix.Multiply4x4, position, model,  model

        stdcall Matrix.Multiply4x4, view, projection, PV
        stdcall Matrix.Multiply4x4, model, PV, MVP

        invoke  glUseProgram, [program]
        
        invoke glUniformMatrix4fv, 2, 1, GL_FALSE, MVP
        ;invoke  glUniformMatrix4fv, 2, 1, GL_FALSE, projection
        ;invoke  glUniformMatrix4fv, 3, 1, GL_FALSE, view
        ;invoke  glUniformMatrix4fv, 4, 1, GL_FALSE, model
        ;invoke  glUniform1f, 5, [scale]
@@:     
 
       

        stdcall DrawMesh, car, [drawingMode]

        invoke  glUseProgram, 0

        invoke  SwapBuffers, [hdc]

        ret
endp

proc Tick

        fld     [angle]
        fadd    [stepp]
        fstp    [angle]

        ret
endp

proc DrawMesh uses esi,\
     mesh, flag

        mov     esi, [mesh]

        invoke glBindVertexArray, [containerVAO]
                invoke  glDrawArrays, [flag], ebx, [esi + Mesh.verticesCount] 
        invoke glBindVertexArray, [containerVAO]

        ret
endp