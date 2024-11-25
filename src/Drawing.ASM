proc Draw uses esi
        invoke  GetTickCount
        mov     [currentTime], eax
        sub     eax, [startTime]
        mov     [nprogramTime], eax

        fild    [nprogramTime]
        fdiv    [oneSecond]
        fstp    [programTime]
       ;jle     .Skip

        stdcall Tick

        stdcall Spline.GetPoint, cubeSpline, car.transform.position, [programTime] 
        stdcall Spline.GetRotation, cubeSpline, car.transform.position, [programTime]                                                                               
        invoke  glClearColor, 0.6, 0.6, 1.0, 1.0

        invoke  glClear, GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT

        
        stdcall Matrix.LookAt, cameraPosition, targetPosition, upVector 
        
        stdcall Object.Draw, car      
        stdcall Object.Draw, table
        stdcall Object.Draw, lamp
        stdcall Object.Draw, pens
        stdcall Object.Draw, books
        stdcall Object.Draw, track


        

        invoke  SwapBuffers, [hdc]
        

        ret
endp

proc Object.Draw uses esi edi,\ 
        objPtr

        memcpy tempMatrix, MVP, sizeof.Matrix4x4

        stdcall Matrix.CreateModel, [objPtr]

        stdcall Matrix.Multiply4x4, view, projection, PV
        stdcall Matrix.Multiply4x4, model, PV, MVP

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
    fstp    [angle]         
    ret
endp