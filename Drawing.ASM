proc Draw, v1

        locals
                currentTime     dd      ?

        endl

        invoke  GetTickCount
        mov     [currentTime], eax

        sub     eax, [time]
        cmp     eax, 10
        jle     .Skip

        mov     eax, [currentTime]
        mov     [time], eax

        stdcall Tick

.Skip:
        invoke  glClearColor, 0.6, 0.6, 1.0, 1.0
        invoke  glClear, GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT

       ; stdcall Spline.GetPoint, cameraSpline, cameraPosition, [programTime]

        invoke  glMatrixMode, GL_MODELVIEW
        invoke  glLoadIdentity


        stdcall Matrix.LookAt, cameraPosition, targetPosition, upVector
        invoke glRotatef, [angleX], 0.0, 0.0, 1.0
        invoke glRotatef, [angleZ], 0.0, 1.0, 0.0

        invoke  glPushMatrix

       ; stdcall DrawMesh, cube, [posX], [posY], [posZ],1

         invoke glScalef , [scale], [scale] , [scale]
        stdcall DrawMesh, zh, [posX], [posY], [posZ],1
        invoke  glPopMatrix

       ; stdcall DrawMesh2, plane, 0.0, 0.0, 0.0, 0

        invoke  SwapBuffers, [hdc]

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

proc DrawMesh2 uses esi,\
     mesh,  v1, flag

       ; cmp [flag], false
       ; je @F

       ; invoke  glRotatef, [angleY], 0.0, 1.0, 0.0 ;
@@:
        invoke glTranslatef, [v1 + Vector3.x],  [v1 + Vector3.y],  [v1 + Vector3.z]


        mov     esi, [mesh]

        invoke  glEnableClientState, GL_VERTEX_ARRAY
        invoke  glEnableClientState, GL_COLOR_ARRAY
        invoke  glEnableClientState, GL_NORMAL_ARRAY

        invoke  glVertexPointer, 3, GL_FLOAT, ebx, [esi + Mesh.vertices]
        invoke  glColorPointer, 3, GL_FLOAT, ebx, [esi + Mesh.colors]
        invoke  glNormalPointer, GL_FLOAT, ebx, [esi + Mesh.normals]
        invoke  glDrawArrays, GL_TRIANGLES, ebx, [esi + Mesh.verticesCount]

        invoke  glDisableClientState, GL_VERTEX_ARRAY
        invoke  glDisableClientState, GL_COLOR_ARRAY
        invoke  glDisableClientState, GL_NORMAL_ARRAY


        ret
endp

proc DrawMesh uses esi,\
     mesh,  v1, flag

       ; cmp [flag], false
       ; je @F

        invoke  glRotatef, [angleY], 0.0, 1.0, 0.0 ;

@@:
        invoke glTranslatef, [v1 + Vector3.x],  [v1 + Vector3.y],  [v1 + Vector3.z]


        mov     esi, [mesh]

        invoke  glEnableClientState, GL_VERTEX_ARRAY
        invoke  glEnableClientState, GL_COLOR_ARRAY
        invoke  glEnableClientState, GL_NORMAL_ARRAY

        invoke  glVertexPointer, 3, GL_FLOAT, ebx, [esi + Mesh.vertices]
        invoke  glColorPointer, 3, GL_FLOAT, ebx, [esi + Mesh.colors]
        invoke  glNormalPointer, GL_FLOAT, ebx, [esi + Mesh.normals]
        invoke  glDrawArrays, GL_TRIANGLES, ebx, [esi + Mesh.verticesCount]

        invoke  glDisableClientState, GL_VERTEX_ARRAY
        invoke  glDisableClientState, GL_COLOR_ARRAY
        invoke  glDisableClientState, GL_NORMAL_ARRAY


        ret
endp