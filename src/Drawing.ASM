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


        ;stdcall Spline.GetPoint, cubeSpline,  tempPosition1, [programTime] 
        ;fld [programTime]
        ;fadd [one]
        ;fstp [nprogramTime]
     
        stdcall Spline.GetPoint, cubeSpline, car.transform.position, [programTime] 
        stdcall Spline.GetTangentVector, cubeSpline, tangentVector, [programTime] 

        stdcall Vector3.Normalize, tangentVector
        

        ;fld [nprogramTime]
        ;fadd [one]
        ;fstp [nprogramTime]
        
        ;stdcall Spline.GetPoint, cubeSpline, tempPosition2, [nprogramTime] 

        ;mov     esi, car.transform.position
        ;mov     edi, tempPosition
        ;mov     ecx, 3
        ;rep     movsd
.Skip:
        

        ;stdcall Vector3.Sub, tempPosition2, tempPosition
        ;stdcall Vector3.Sub, tempPosition, tempPosition1 

        ;stdcall Vector3.Length, tempPosition
        ;mov [v1Length], eax

        ;stdcall Vector3.Length, tempPosition2
        ;mov [v2Length], eax

        ;stdcall Vector3.Dup, tempPosition, tempPosition2
        ;mov [cosAngle], eax

        ;fld [v1Length]    ;v1L
        ;fmul [v2Length]  

        ;fdivr [cosAngle]       

        ;fld st0
        ;fmul st0, st0    ; srctan(sqrt(1 - src^2)/src)
        
        ;fld1

        ;fsubr [oneF]
        ;fsqrt
        ;fxch
        ;fpatan
        
        ;fmul [toRadian]

        ;fldpi

        ;fdivr st0, st1  
        ;fchs 
        ;fadd [ninety] 
        ;fadd [car.transform.rotation.y]   
        ;fstp [car.transform.rotation.y] 

        invoke  glClearColor, 0.6, 0.6, 1.0, 1.0
        invoke  glClear, GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT
         
       
        ;stdcall Vector3.RotateY, sphere.transform.position, [step], sphere.transform.position
        ;stdcall Spline.GetPoint, rotateSpline, sphere.transform.position, [programTime]
        
        invoke  glMatrixMode, GL_MODELVIEW 
        invoke  glLoadIdentity
        stdcall Matrix.LookAt, cameraPosition, targetPosition, upVector;, view 
        
        invoke glGetFloatv, GL_MODELVIEW_MATRIX, view

        stdcall Vector3.Translate, oTurn, [angleX], [angleZ], [angleY]
        
        stdcall Object.Draw, car
        stdcall Object.Draw, table
        stdcall Object.Draw, sphere

        invoke  SwapBuffers, [hdc]
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