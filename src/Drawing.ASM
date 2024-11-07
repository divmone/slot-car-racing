proc Draw uses esi
        invoke  GetTickCount
        mov     [currentTime], eax
        sub     eax, [startTime]
        mov     [programTime], eax

        fild    [programTime]
        fdiv    [oneSecond]
        fstp    [programTime]

        mov     eax, [currentTime]
        sub     eax, [lastTime]
        cmp     eax, 10
        jle     .Skip

        mov     eax, [currentTime]
        mov     [lastTime], eax   
        ;stdcall Tick
      ;  stdcall UpdateMovement
.Skip:
        invoke  glClearColor, 0.6, 0.6, 1.0, 1.0
        invoke  glClear, GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT
        
        stdcall Spline.GetPoint, cubeSpline, car.transform.position, [programTime]                                                  
        
        stdcall Spline.GetPoint, rotateSpline, car.transform.rotation, [programTime]                                                  
        
        stdcall Vector3.RotateY, sphere.transform.position, [lightAngle], sphere.transform.position
 
        invoke  glMatrixMode, GL_MODELVIEW 
        invoke  glLoadIdentity
        stdcall Matrix.LookAt, cameraPosition, targetPosition, upVector, view 
        
        invoke glGetFloatv, GL_MODELVIEW_MATRIX, view

        stdcall Vector3.Translate, oTurn, [angleX], [angleZ], [angleY]
        
        stdcall Object.Draw, car
        stdcall Object.Draw, table
        stdcall Object.Draw, sphere

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

proc Object.Draw uses esi ,\ 
        objPtr

        memcpy tempMatrix, MVP, sizeof.Matrix4x4

        mov esi, [objPtr]
        add esi, Object.transform.position
        stdcall Matrix.CreatePosition, esi, position
        add esi, 12
        stdcall Matrix.CreateTurn, esi
        add esi, 12
        stdcall Matrix.CreateScale, esi, scale

        stdcall Matrix.Multiply4x4, turn, position, model
        stdcall Matrix.Multiply4x4, scale, model, model
        stdcall Matrix.Multiply4x4, view, projection, PV
        stdcall Matrix.Multiply4x4, model, PV, MVP

        stdcall Matrix.Multiply4x4, turn, model, model  ; Rotate the model's axes

        invoke  glUseProgram, [program]
        
        invoke glUniformMatrix4fv, [MVPLocation], 1, GL_FALSE, MVP
      
        invoke glUniform3fv, [viewPosLocation], 1, cameraPosition
       
        invoke glUniform3fv, [lightPosLocation], 1, sphere.transform.position
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