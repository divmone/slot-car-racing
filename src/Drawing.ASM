proc Draw, v1

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

        stdcall Matrix.LookAt, cameraPosition, targetPosition, upVector

        cmp     [program], ebx
        je      @F

        invoke  glUseProgram, [program]

        fild    [programTime]
        fdiv    [oneSecond]
        fstp    [tempFloat]
        push    [tempFloat]

       ; , (float)(programTime)

        fild    [clientRect.bottom]
        fstp    [tempFloat]
        push    [tempFloat]

        fild    [clientRect.right]
        fstp    [tempFloat]
        push    [tempFloat]

        invoke  glUniform2f, [sizeLocation] 
                           
        ;stdcall DrawMesh, plane, [drawingMode], 1.0, 1.0, 1.0

        invoke  glUseProgram, [program]

@@:
        invoke glRotatef, [angleY], 0.0, 1.0, 0.0
        invoke glRotatef, [angleX], 1.0, 0.0, 0.0
        invoke glRotatef, [angleZ], 0.0, 0.0, 1.0

        stdcall DrawMesh, car, [drawingMode], 0.0, 0.0, 0.0

        invoke  SwapBuffers, [hdc]

        ret
endp

proc UpdateMovement

    fld [angleY]
    fsin        
    fadd [posX] 
    fstp [posX]       

    fld [angleY]
    fcos

    fadd [posZ]   
    fstp [posZ]     

    ret
endp

proc MoveCamera
     invoke glRotatef, [angleX], 0.0, 0.0, 1.0


    ret
endp

proc Tick

        fld     [angle]
        fadd    [step]
        fstp    [angle]

        ret
endp

proc DrawMesh uses esi,\
     mesh, flag ,  v1

        mov     esi, [mesh]

        invoke  glEnableClientState, GL_VERTEX_ARRAY
        invoke  glEnableClientState, GL_COLOR_ARRAY
        invoke  glEnableClientState, GL_NORMAL_ARRAY

        invoke  glVertexPointer, 3, GL_FLOAT, ebx, [esi + Mesh.vertices]
        invoke  glColorPointer, 3, GL_FLOAT, ebx, [esi + Mesh.colors]
        invoke  glNormalPointer, GL_FLOAT, ebx, [esi + Mesh.normals]
        invoke  glDrawArrays, [flag], ebx, [esi + Mesh.verticesCount]

        invoke  glDisableClientState, GL_VERTEX_ARRAY
        invoke  glDisableClientState, GL_COLOR_ARRAY
        invoke  glDisableClientState, GL_NORMAL_ARRAY


        ret
endp