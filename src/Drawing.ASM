proc Draw
        locals 
                tempTime dd 0.0
                step dd 0.01
                maxB dd 3.0
                counter dd 0
        endl
        invoke  GetTickCount
        mov     [currentTime], eax
        sub     eax, [startTime]
        mov     [nprogramTime], eax

        fild    [nprogramTime]
        fdiv    [oneSecond]
        fstp    [programTime]
       ;jle     .Skip

        stdcall Spline.GetPoint, cubeSpline, car.transform.position, [programTime] 
        stdcall Spline.GetRotation, cubeSpline, car, [programTime]                                                                               
   
        invoke  glClearColor, 0.6, 0.6, 1.0, 1.0

        invoke  glClear, GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT
        
        stdcall Vector3.Copy, tempCameraVector, cameraFront
        stdcall Vector3.Add, tempCameraVector, cameraPosition
        stdcall Matrix.LookAt, cameraPosition, targetPosition, upVector 
        
.loop: 
       ; stdcall Spline.GetPoint, cubeSpline, road.transform.position, [tempTime] 
       ; stdcall Spline.GetRotation, cubeSpline, road, [tempTime]                                                                             
        stdcall Object.Draw, road  

        ; fld [tempTime]
        ; fadd [step]
        ; fld [maxB]
        ; fcomip st0, st1
        ; fstp [tempTime]
        ; ja .loop

@@:
        stdcall Object.Draw, car     
        stdcall Object.Draw, table
        stdcall Object.Draw, track

        invoke  SwapBuffers, [hdc]
        

        ret
endp

proc Sprite.Draw uses esi, objPtr
        
        stdcall Matrix.CreateModel, [objPtr]

        invoke glUseProgram, [program2D]
        invoke glUniformMatrix4fv, [modelLocation2D], 1, GL_FALSE, model
        invoke glUniformMatrix4fv, [projectionLocation], 1, GL_FALSE, projection2D
      
        mov esi, [objPtr]
        invoke glBindTexture, GL_TEXTURE_2D, [esi + Object.texture]
        invoke glBindVertexArray, [esi + Object.VAO]
                invoke  glDrawArrays, 6, 0, 4
        invoke glBindVertexArray, 0
        invoke glBindTexture, GL_TEXTURE_2D, 0
        
        invoke glUseProgram, 0
       
        ret
endp

proc Object.Draw, objPtr
        ;memcpy tempMatrix, MVP, sizeof.Matrix4x4

        stdcall Matrix.CreateModel, [objPtr]

        stdcall Matrix.Multiply4x4, view, projection, PV
        stdcall Matrix.Multiply4x4, model, PV, MVP

        invoke  glUseProgram, [program]
        
        invoke glUniformMatrix4fv, [MVPLocation], 1, GL_FALSE, MVP
      
        invoke glUniform3fv, [viewPosLocation], 1, lightPosition1
       
        invoke glUniform3fv, [lightPosLocation], 1, cameraPosition
        invoke glUniform3fv, [objectColorLocation], 1, objectColor
        invoke glUniform3fv, [lightColorLocation], 1, lightColor
@@:     
        stdcall DrawMesh, [objPtr], [drawingMode]
        invoke  glUseProgram, 0
        ;memcpy MVP, tempMatrix, sizeof.Matrix4x4
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