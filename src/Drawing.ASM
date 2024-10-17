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
        
        invoke  glUniform1f, 2,  [scale]  
        invoke  glUniform1f, 3,  [angleX] 
        invoke  glUniform1f, 4,  [angleY]  
        invoke  glUniform1f, 5,  [angleZ] 
        invoke  glClearColor, 0.6, 0.6, 1.0, 1.0
        invoke  glClear, GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT

    
@@:     
 
       invoke  glUseProgram, [program]

        stdcall DrawMesh, car, [drawingMode]

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
                ;invoke  glDrawArrays, GL_QUADS, 0, 8         
        invoke glBindVertexArray, [containerVAO]

        ret
endp