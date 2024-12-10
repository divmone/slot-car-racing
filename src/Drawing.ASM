proc Draw uses esi
        locals 
                tempTime dd 0.0
                step dd 0.05
                maxB dd 11.0
                counter dd 0
                angle dd 0.1
                dist dd 10.0
                dist1 dd 5.0
                oneSecond dd 100000.0
                angle dd ?
                toDegree dd 180.0
        endl    
       

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

.Skip:        
        invoke  glClearColor, 0.6, 0.6, 1.0, 1.0

        invoke  glClear, GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT
        
    
        stdcall Physics.Update, 0.07, cubeSpline, car

        fldpi
        fmul [tempAngle3]
        fdiv [toDegree]
        
        fstp [angle]

        fld [car.transform.position.z]  ; Z-координата машины
        fld [dist]                      ; Смещение камеры назад (за машиной)
        fsubp      
        fld [angle]
        fcos
        fmulp                      ; tempCameraVector.z = car.z - dist
        fstp [tempCameraVector.z]

        fld [car.transform.position.y]  ; Y-координата машины
        fld [dist1]                     ; Смещение камеры вверх
        faddp 
        fld [angle]
        fsin
        fmulp                            ; tempCameraVector.y = car.y + dist1
        fstp [tempCameraVector.y]

        fld [car.transform.position.x]
        fstp [tempCameraVector.x]

   

      stdcall Matrix.LookAt, tempCameraVector, car.transform.position, upVector
        invoke glUseProgram, [program]  
.loop: 
        stdcall Spline.GetPoint, cubeSpline, road.transform.position, [tempTime] 
        stdcall Spline.GetRotation, cubeSpline, road, [tempTime]                                                                             
       
        stdcall Object.Draw, road  

        fld [tempTime]
        fadd [step]
        fld [maxB]
        fcomip st0, st1
        fstp [tempTime]
        ja .loop

        mov [tempTime], 0.0

@@:
        ;stdcall Object.Draw, sphere   
        ;invoke glDisable, GL_TEXTURE_2D
        stdcall Object.Draw, car
        ;stdcall Object.Draw, car2      
        stdcall Object.Draw, table
        stdcall Object.Draw, track
        ;stdcall Object.Draw, sphere
 invoke glUseProgram, 0 
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

proc Object.Draw uses esi, objPtr
        ;memcpy tempMatrix, MVP, sizeof.Matrix4x4

        stdcall Matrix.CreateModel, [objPtr]

        stdcall Matrix.Multiply4x4, view, projection, PV
        stdcall Matrix.Multiply4x4, model, PV, MVP

        
        invoke glUniformMatrix4fv, [MVPLocation], 1, GL_FALSE, MVP
      
        invoke glUniform3fv, [viewPosLocation], 1, tempCameraVector
       
        invoke glUniform3fv, [lightPosLocation], 1, lightPosition
        invoke glUniform3fv, [objectColorLocation], 1, objectColor
        invoke glUniform3fv, [lightColorLocation], 1, lightColor

        mov esi, [objPtr]
        add esi, Object.material.ambient
        invoke glUniform3fv, [ambientLocation], 1, esi

        mov esi, [objPtr]
        add esi, Object.material.diffuse
        invoke glUniform3fv, [diffuseLocation], 1, esi

        mov esi, [objPtr]
        add esi, Object.material.specular
        invoke glUniform3fv, [specularLocation], 1, esi
        
        mov esi, [objPtr]
        invoke  glUniform1f, [shininessLocation], [esi + Object.material.shininess]

@@:     
        stdcall DrawMesh, [objPtr], [drawingMode]

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