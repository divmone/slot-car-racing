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

        stdcall Vector3.Translate, oTurn, [angleX], [angleY],0 ;0[angleZ]

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

        ;mov [oTurn + Vector3.x], 0
        ;mov [oTurn + Vector3.y], 0
        ;mov [oTurn + Vector3.z], 0
        ;mov [oPos + Vector3.x], 0
        ;mov [oPos + Vector3.y], 0
       
        
        invoke  glUseProgram, [program]
        
        invoke glUniformMatrix4fv, [MVPLocation], 1, GL_FALSE, MVP
        ;invoke glUniformMatrix4fv, [modelLocation], 1, GL_FALSE, model
        
        invoke glUniform3fv, [viewPosLocation], 1, cameraPosition
        stdcall Vector3.RotateY, light0Position, [angle], light0Position
        invoke glUniform3fv, [lightPosLocation], 1, light0Position
        invoke glUniform3fv, [objectColorLocation], 1, objectColor
        invoke glUniform3fv, [lightColorLocation], 1, lightColorV
 
@@:     

        stdcall DrawMesh, car, [drawingMode]

        invoke  glUseProgram, 0

        invoke  SwapBuffers, [hdc]

        ret
endp

proc Tick
        finit
    fld     [angle]        
    fld [circleD]      
    fcom      
    fstsw   ax              
    sahf                    
    jb     @F              
    
    fldz
    fstp    [angle]
          
    ret

@@:
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