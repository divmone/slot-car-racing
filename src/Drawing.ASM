proc Draw uses esi
        invoke  GetTickCount
        mov     [currentTime], eax
        sub     eax, [startTime]
        mov     [programTime], eax

        fild    [programTime]
        fdiv    [oneSecond]
        fstp    [programTime]

        jle     .Skip

        stdcall Spline.GetPoint, cubeSpline, car.transform.position, [programTime] 
        
        stdcall Spline.GetRotation, cubeSpline, car.transform.position, [programTime]
        ;stdcall Vector3.RotateY, car.transform.position, 1.0, car.transform.position
.Skip:
        invoke  glClearColor, 0.6, 0.6, 1.0, 1.0
        invoke  glClear, GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT

        
        stdcall Matrix.LookAt, cameraPosition, targetPosition, upVector 
        
       
        stdcall Vector3.Translate, oTurn, [angleX], [angleZ], [angleY]
        


        stdcall Object.Draw, car
        stdcall Object.Draw, table
        stdcall Object.Draw, sphere

        invoke  SwapBuffers, [hdc]
        ret
endp

proc Object.Draw uses esi edi,\ 
        objPtr

        memcpy tempMatrix, MVP, sizeof.Matrix4x4

        mov esi, [objPtr]
        add esi, Object.transform.position
        stdcall Matrix.CreatePosition, esi, position
        add esi, 12
        stdcall Matrix.CreateTurn, esi
        add esi, 12
        stdcall Matrix.CreateScale, esi, scale

        stdcall Matrix.Multiply4x4, scale, turn, model 
        stdcall Matrix.Multiply4x4, model, position, model 

        
        mov edi, [objPtr]
        add edi, Object.matrix
        mov esi, model
        mov ecx, 16
        rep movsd

        
        stdcall Matrix.Multiply4x4, view, projection, PV
        stdcall Matrix.Multiply4x4, model, PV, MVP

        invoke  glUseProgram, [program]
        
        invoke glUniformMatrix4fv, [MVPLocation], 1, GL_FALSE, MVP
      
        invoke glUniform3fv, [viewPosLocation], 1, cameraPosition
       
        invoke glUniform3fv, [lightPosLocation], 1, cameraPosition;sphere.transform.position
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