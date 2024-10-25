proc Matrix.Projection uses edi,\
     aspect, fov, zNear, zFar, matrix

        locals
                sine            dd              ?
                cotangent       dd              ?
                deltaZ          dd              ?
                radians         dd              ?
                result          dd              ?
        endl

        mov     edi, [matrix]
        mov     ecx, 4 * 4
        xor     eax, eax
        rep     stosd

        mov     edi, [matrix]

        fld     [fov]
        fld1
        fld1
        faddp
        fdivp
        fdiv    [radian]
        fstp    [radians]

        fld     [zFar]
        fsub    [zNear]
        fstp    [deltaZ]

        fld     [radians]
        fsin
        fstp    [sine]

        fld     [radians]
        fcos
        fdiv    [sine]
        fstp    [cotangent]

        fld     [cotangent]
        fdiv    [aspect]
        fstp    [edi + Matrix4x4.m11]

        fld     [cotangent]
        fstp    [edi + Matrix4x4.m22]

        fld     [zFar]
        fadd    [zNear]
        fdiv    [deltaZ]
        fchs
        fstp    [edi + Matrix4x4.m33]

        fld1
        fchs
        fstp    [edi + Matrix4x4.m34]

        fld1
        fld1
        faddp
        fchs
        fmul    [zNear]
        fmul    [zFar]
        fdiv    [deltaZ]
        fstp    [edi + Matrix4x4.m43]

        ;invoke  glMultMatrixf, edi

        ret
endp  

proc Matrix.Projection1 uses edi,\
     aspect, fov, zNear, zFar

        locals
                matrix          Matrix4x4
                sine            dd              ?
                cotangent       dd              ?
                deltaZ          dd              ?
                radians         dd              ?
                result          dd              ?
        endl

        lea     edi, [matrix]
        mov     ecx, 4 * 4
        xor     eax, eax
        rep     stosd

        lea     edi, [matrix]

        fld     [fov]
        fld1
        fld1
        faddp
        fdivp
        fdiv    [radian]
        fstp    [radians]

        fld     [zFar]
        fsub    [zNear]
        fstp    [deltaZ]

        fld     [radians]
        fsin
        fstp    [sine]

        fld     [radians]
        fcos
        fdiv    [sine]
        fstp    [cotangent]

        fld     [cotangent]
        fdiv    [aspect]
        fstp    [edi + Matrix4x4.m11]

        fld     [cotangent]
        fstp    [edi + Matrix4x4.m22]

        fld     [zFar]
        fadd    [zNear]
        fdiv    [deltaZ]
        fchs
        fstp    [edi + Matrix4x4.m33]

        fld1
        fchs
        fstp    [edi + Matrix4x4.m34]

        fld1
        fld1
        faddp
        fchs
        fmul    [zNear]
        fmul    [zFar]
        fdiv    [deltaZ]
        fstp    [edi + Matrix4x4.m43]

        push edi
        memcpy  projection, edi, 64
        pop edi

        invoke  glMultMatrixf, edi

        ret
endp           

proc Matrix.LookAt1 uses esi edi ebx,\
     camera, target, up

        locals
                temp    dd              ?
                matrix  Matrix4x4
                forw    Vector3
                side    Vector3
        endl

        lea     edi, [matrix]
        mov     ecx, 4 * 4
        xor     eax, eax
        rep     stosd

        mov     esi, [camera]
        mov     edi, [target]
        mov     ebx, [up]

        fld     [edi + Vector3.x]
        fsub    [esi + Vector3.x]
        fstp    [forw.x]

        fld     [edi + Vector3.y]
        fsub    [esi + Vector3.y]
        fstp    [forw.y]

        fld     [edi + Vector3.z]
        fsub    [esi + Vector3.z]
        fstp    [forw.z]

        lea     eax, [forw]
        stdcall Vector3.Normalize, eax

        lea     eax, [forw]
        lea     ecx, [side]
        stdcall Vector3.Cross, eax, ebx, ecx

        lea     eax, [side]
        stdcall Vector3.Normalize, eax

        lea     eax, [side]
        lea     ecx, [forw]
        stdcall Vector3.Cross, eax, ecx, ebx

        lea     esi, [side]
        lea     edi, [matrix]
        fld     [esi + Vector3.x]
        fstp    [edi + Matrix4x4.m11]
        fld     [esi + Vector3.y]
        fstp    [edi + Matrix4x4.m21]
        fld     [esi + Vector3.z]
        fstp    [edi + Matrix4x4.m31]

        fld     [ebx + Vector3.x]
        fstp    [edi + Matrix4x4.m12]
        fld     [ebx + Vector3.y]
        fstp    [edi + Matrix4x4.m22]
        fld     [ebx + Vector3.z]
        fstp    [edi + Matrix4x4.m32]

        lea     esi, [forw]
        fld     [esi + Vector3.x]
        fchs
        fstp    [edi + Matrix4x4.m13]
        fld     [esi + Vector3.y]
        fchs
        fstp    [edi + Matrix4x4.m23]
        fld     [esi + Vector3.z]
        fchs
        fstp    [edi + Matrix4x4.m33]

        fld1
        fstp    [edi + Matrix4x4.m44]

        push edi
        memcpy  view, edi, 64
        pop edi

        invoke  glMultMatrixf, edi

        mov     esi, [camera]
        fld     [esi + Vector3.z]
        fchs
        fstp    [temp]
        push    [temp]
        fld     [esi + Vector3.y]
        fchs
        fstp    [temp]
        push    [temp]
        fld     [esi + Vector3.z]
        fchs
        fstp    [temp]
        push    [temp]
        invoke  glTranslatef

        ret
endp   

proc Matrix.LookAt uses esi edi ebx,\
     camera, target, up, matrix

        locals
                temp    dd              ?
                ;matrix  Matrix4x4
                forw    Vector3
                side    Vector3
        endl

        mov     edi, [matrix]
        mov     ecx, 4 * 4
        xor     eax, eax
        rep     stosd

        mov     esi, [camera]
        mov     edi, [target]
        mov     ebx, [up]

        fld     [edi + Vector3.x]
        fsub    [esi + Vector3.x]
        fstp    [forw.x]

        fld     [edi + Vector3.y]
        fsub    [esi + Vector3.y]
        fstp    [forw.y]

        fld     [edi + Vector3.z]
        fsub    [esi + Vector3.z]
        fstp    [forw.z]

        lea     eax, [forw]
        stdcall Vector3.Normalize, eax

        lea     eax, [forw]
        lea     ecx, [side]
        stdcall Vector3.Cross, eax, ebx, ecx

        lea     eax, [side]
        stdcall Vector3.Normalize, eax

        lea     eax, [side]
        lea     ecx, [forw]
        stdcall Vector3.Cross, eax, ecx, ebx

        lea     esi, [side]
        mov     edi, [matrix]
        fld     [esi + Vector3.x]
        fstp    [edi + Matrix4x4.m11]
        fld     [esi + Vector3.y]
        fstp    [edi + Matrix4x4.m21]
        fld     [esi + Vector3.z]
        fstp    [edi + Matrix4x4.m31]

        fld     [ebx + Vector3.x]
        fstp    [edi + Matrix4x4.m12]
        fld     [ebx + Vector3.y]
        fstp    [edi + Matrix4x4.m22]
        fld     [ebx + Vector3.z]
        fstp    [edi + Matrix4x4.m32]

        lea     esi, [forw]
        fld     [esi + Vector3.x]
        fchs
        fstp    [edi + Matrix4x4.m13]
        fld     [esi + Vector3.y]
        fchs
        fstp    [edi + Matrix4x4.m23]
        fld     [esi + Vector3.z]
        fchs
        fstp    [edi + Matrix4x4.m33]

        fld1
        fstp    [edi + Matrix4x4.m44]

 
        invoke  glMultMatrixf, edi

        mov     esi, [camera]
        fld     [esi + Vector3.z]
        fchs
        fstp    [temp]
        push    [temp]
        fld     [esi + Vector3.y]
        fchs
        fstp    [temp]
        push    [temp]
        fld     [esi + Vector3.z]
        fchs
        fstp    [temp]
        push    [temp]
        invoke  glTranslatef

        push edi
        memcpy  view, edi, 64
        pop edi

        ret
endp

 ;float zAxis = normalize(eye - target)
 ;float xAxis = normalize(up * zAxis)
 ;float yAxis = up

proc Matrix.GetAxis  uses esi edi ebx,\
     camera, target, up, xAx, yAx, zAx

         locals
                temp    dd              ?
                matrix  Matrix4x4
                forw    Vector3
                side    Vector3
        endl

        lea     edi, [matrix]
        mov     ecx, 4 * 4
        xor     eax, eax
        rep     stosd

        mov     esi, [camera]
        mov     edi, [target]
        mov     ebx, [up]

        fld     [edi + Vector3.x]
        fsub    [esi + Vector3.x]
        fstp    [forw.x]

        fld     [edi + Vector3.y]
        fsub    [esi + Vector3.y]
        fstp    [forw.y]

        fld     [edi + Vector3.z]
        fsub    [esi + Vector3.z]
        fstp    [forw.z]

        lea     eax, [forw]
        stdcall Vector3.Normalize, eax
        lea     eax, [forw]
        lea ecx, [zAx]
        stdcall Vector3.Copy, eax, ecx

        lea     eax, [forw]
        lea     ecx, [side]
        stdcall Vector3.Cross, eax, ebx, ecx


        lea     eax, [side]
        stdcall Vector3.Normalize, eax
           lea     eax, [forw]
        lea ecx, [xAx]
        stdcall Vector3.Copy, eax, ecx
        lea     eax, [up]
        lea ecx, [yAx]
        stdcall Vector3.Copy, eax, ecx



        ret

endp



proc Matrix.Rotate uses edi ,\
                matrix, angleD, axis
        locals
                angleR  dd ?
                cos     dd ?
                acos    dd ?
                sin     dd ?
                divisor dd      180.0
                temp    Vector3   ?     
                rotate Matrix4x4 0, 0, 0, 0,\
                                 0, 0, 0, 0,\
                                 0, 0, 0, 0,\
                                 0, 0, 0, 0
                
        endl

        fldpi
        fdiv [divisor]
        fmul [angleD]

        fst [angleR]

        fsincos

        fstp [sin]
        fstp [cos]

        stdcall Vector3.Normalize, [axis]

        fld1 
        fsub [cos]
        fstp [acos]

        fld [temp + Vector3.x]
        fmul [acos]
        fstp [temp + Vector3.x]

        fld [temp + Vector3.y]
        fmul [acos]
        fstp [temp + Vector3.y]

        fld [temp + Vector3.z]
        fmul [acos]
        fstp [temp + Vector3.z]

        lea edi, [rotate]

        fld [temp + Vector3.x]
        fmul [axis + Vector3.x]
        fadd [cos]
        fstp [edi + Matrix4x4.m11]
        


        ret
endp

proc gf_frastrum uses esi edi ebx, look_vec3, CameraPos, CameraTurn
    locals
      Pos    dd   ?, ?, ?
      Turn   dd   ?, ?, ?
      leftPlaneTurn  dd  60.0 
      leftPlanePos   dd  0.0 
    endl
    
    mov ecx, 0
    @@:
        fld [CameraPos + ecx]
        fstp [Pos + ecx]
        fld [CameraTurn + ecx]
        fstp [Turn + ecx]
    add ecx, 4
    cmp ecx, 12
    jnz @B
    
    ;gf_tmpMMMatrix ;gf_pr_view_matrix
    lea esi, [gf_frastrum_planes]
    
    ;near
    fld dword[gf_pr_view_matrix + 16 * 0 + 4 * 2]   ;[0][2]
    fstp dword[esi]
    fld dword[gf_pr_view_matrix + 16 * 1 + 4 * 2]   ;[1][2]
    fstp dword[esi + 4]
    fld dword[gf_pr_view_matrix + 16 * 2 + 4 * 2]   ;[2][2]
    fstp dword[esi + 8]
    fld dword[gf_pr_view_matrix + 16 * 3 + 4 * 2]   ;[3][2]
    fstp dword[esi + 12]
    add esi, 16
    ;left
    fld dword[gf_pr_view_matrix + 16 * 0 + 4 * 3]   ;[0][3]
    fadd dword[gf_pr_view_matrix + 16 * 0 + 4 * 0]  ;[0][0]
    fstp dword[esi]
    fld dword[gf_pr_view_matrix + 16 * 1 + 4 * 3]   ;[1][3]
    fadd dword[gf_pr_view_matrix + 16 * 1 + 4 * 0]  ;[1][0]
    fstp dword[esi + 4]
    fld dword[gf_pr_view_matrix + 16 * 2 + 4 * 3]   ;[2][3]
    fadd dword[gf_pr_view_matrix + 16 * 2 + 4 * 0]  ;[2][0]
    fstp dword[esi + 8]
    fld dword[gf_pr_view_matrix + 16 * 3 + 4 * 3]   ;[3][3]
    fadd dword[gf_pr_view_matrix + 16 * 3 + 4 * 0]  ;[3][0]
    fstp dword[esi + 12]
    add esi, 16
    ;right
    fld dword[gf_pr_view_matrix + 16 * 0 + 4 * 3]   ;[0][3]
    fsub dword[gf_pr_view_matrix + 16 * 0 + 4 * 0]  ;[0][0]
    fstp dword[esi]
    fld dword[gf_pr_view_matrix + 16 * 1 + 4 * 3]   ;[1][3]
    fsub dword[gf_pr_view_matrix + 16 * 1 + 4 * 0]  ;[1][0]
    fstp dword[esi + 4]
    fld dword[gf_pr_view_matrix + 16 * 2 + 4 * 3]   ;[2][3]
    fsub dword[gf_pr_view_matrix + 16 * 2 + 4 * 0]  ;[2][0]
    fstp dword[esi + 8]
    fld dword[gf_pr_view_matrix + 16 * 3 + 4 * 3]   ;[3][3]
    fsub dword[gf_pr_view_matrix + 16 * 3 + 4 * 0]  ;[3][0]
    fstp dword[esi + 12]
    add esi, 16
    ;top
    fld dword[gf_pr_view_matrix + 16 * 0 + 4 * 3]   ;[0][3]
    fsub dword[gf_pr_view_matrix + 16 * 0 + 4 * 1]  ;[0][1]
    fstp dword[esi]
    fld dword[gf_pr_view_matrix + 16 * 1 + 4 * 3]   ;[1][3]
    fsub dword[gf_pr_view_matrix + 16 * 1 + 4 * 1]  ;[1][1]
    fstp dword[esi + 4]
    fld dword[gf_pr_view_matrix + 16 * 2 + 4 * 3]   ;[2][3]
    fsub dword[gf_pr_view_matrix + 16 * 2 + 4 * 1]  ;[2][1]
    fstp dword[esi + 8]
    fld dword[gf_pr_view_matrix + 16 * 3 + 4 * 3]   ;[3][3]
    fsub dword[gf_pr_view_matrix + 16 * 3 + 4 * 1]  ;[3][1]
    fstp dword[esi + 12]
    add esi, 16
    ;bottom
    fld dword[gf_pr_view_matrix + 16 * 0 + 4 * 3]   ;[0][3]
    fadd dword[gf_pr_view_matrix + 16 * 0 + 4 * 1]  ;[0][1]
    fstp dword[esi]
    fld dword[gf_pr_view_matrix + 16 * 1 + 4 * 3]   ;[1][3]
    fadd dword[gf_pr_view_matrix + 16 * 1 + 4 * 1]  ;[1][1]
    fstp dword[esi + 4]
    fld dword[gf_pr_view_matrix + 16 * 2 + 4 * 3]   ;[2][3]
    fadd dword[gf_pr_view_matrix + 16 * 2 + 4 * 1]  ;[2][1]
    fstp dword[esi + 8]
    fld dword[gf_pr_view_matrix + 16 * 3 + 4 * 3]   ;[0][3]
    fadd dword[gf_pr_view_matrix + 16 * 3 + 4 * 1]  ;[0][2]
    fstp dword[esi + 12]
    add esi, 16
    
  ret
endp


proc gf_get_camera_lookvec uses esi edi, pos, turn
    locals
       a  dd  ?
       b  dd  ?
       PiDegree dd 180.0
    endl
    mov esi, [turn]
    mov edi, [pos]

    ;Calculate a in radian
    fldpi
    fmul dword[esi]
    fdiv [PiDegree]
    fstp [a]
    ;Calculate b in radian
    fldpi
    fmul dword[esi + 4]
    fdiv [PiDegree]
    fstp [b]
    
    
    fld dword[edi + 0]
    fld [a]
    fcos
    fld [b] 
    fsin
    fmulp
    fsubp
    fstp [gf_camera_lookvec + 0]
    
    fld dword[edi + 4]
    fld [a]
    fsin
    faddp
    fstp [gf_camera_lookvec + 4]
    
    fld dword[edi + 8]
    fld [a]
    fcos
    fld [b] 
    fcos
    fmulp
    faddp
    fstp [gf_camera_lookvec + 8]
    
  ret
endp


proc gf_get_camera_upvec, CameraTurn
  locals
    tmp dd 1.0
    res dd ?
    radCalc dd 0.01745329252
  endl
  mov esi, [CameraTurn]
  fld dword[esi]
  fmul [radCalc]
  fcos
  fstp [gf_uplookvec + 4]
  
  ret
endp


proc Matrix.CreateModel uses esi edi, pos, turnC, scaleC

    stdcall Matrix.CreatePosition, [pos]
    stdcall Matrix.CreateScale, [scaleC]
    stdcall Matrix.CreateTurn, [turnC]
    stdcall Matrix.Multiply4x4, turn, scale, model
    stdcall Matrix.Multiply4x4, model, position, model

    ret
endp

proc Matrix.Multiply uses ebx esi edi, Matrix1, Matrix2, ResMatrix
   locals
     Temp dd ?
   endl

   mov ebx, 0
   .Loop_A1:   ;(i)
      mov esi, 0
     .Loop_A2:   ;(j)
        mov edi, 0
        mov [Temp], 0.0
        .Loop_A3:    ;(k)
           push ebx
           add ebx, [Matrix1]
           fld dword [ebx + edi]
           mov ebx, edi
           shl ebx, 2
           add ebx, [Matrix2]
           fld dword [ebx + esi]
           fmulp
           fadd dword [Temp]
           fstp dword [Temp]
           pop ebx
        add edi, 4
        cmp edi, 16
        jnz .Loop_A3
        mov eax, [Temp]
        push ebx
        add ebx, [ResMatrix]
        mov [ebx + esi], eax
        pop ebx
      add esi, 4
      cmp esi, 16
      jnz .Loop_A2
   add ebx, 16
   cmp ebx, 16 * 4
   jnz .Loop_A1
   
  ret
endp


proc Matrix.CreatePosition, posV, positionM
  mov edi, [positionM]
                        
  mov esi, [posV]
  fld  [esi + Vector3.x]
  fstp [edi + Matrix4x4.m41]
  
  fld  [esi + Vector3.y]
  fstp [edi + Matrix4x4.m42]
  
  fld  [esi + Vector3.z]
  ;fchs 
  fstp [edi + Matrix4x4.m43]
  
  ret
endp


proc Matrix.CreateTurn, turnV

    locals
       a  dd  ?
       b  dd  ?
       c  dd  ?
       PiDegree dd 180.0
    endl
    mov esi, [turnV]

    fldpi
    fmul  dword [esi]
    fdiv  [PiDegree]
    fstp  [a]

    fldpi
    fmul  dword [esi + 4]
    fdiv  [PiDegree]
    fstp  [b]

    fldpi
    fmul dword [esi + 8]
    fdiv [PiDegree]
    fstp  [c]


    fld  [b]
    fcos
    fld  [c]
    fcos
    fmulp
    fstp  dword[turn + 0]

    fld  [c]
    fsin
    fld  [b]
    fcos
    fmulp
    fchs
    fstp  dword[turn + 4]

    fld  [b]
    fsin
    fstp  dword[turn + 8]

    fld  [a]
    fsin
    fld  [b]
    fsin
    fmulp
    fld  [c]
    fcos
    fmulp
    fld  [c]
    fsin
    fld  [a]
    fcos
    fmulp
    faddp
    fstp  dword[turn + 16]

    fld  [a]
    fcos
    fld  [c]
    fcos
    fmulp
    fld  [a]
    fsin
    fld  [b]
    fsin
    fmulp
    fld  [c]
    fsin
    fmulp
    fsubp
    fstp  dword[turn + 20]

    fld  [a]
    fsin
    fld  [b]
    fcos
    fmulp
    fchs
    fstp  dword[turn + 24]

    fld  [a]
    fsin
    fld  [c]
    fsin
    fmulp
    fld  [b]
    fsin
    fld  [a]
    fcos
    fmulp
    fld  [c]
    fcos
    fmulp
    fsubp
    fstp  dword[turn + 32]

    fld  [a]
    fsin
    fld  [c]
    fcos
    fmulp
    fld  [b]
    fsin
    fld  [c]
    fsin
    fmulp
    fld  [a]
    fcos
    fmulp
    faddp
    fstp dword [turn + 36]

    fld  [a]
    fcos
    fld  [b]
    fcos
    fmulp
    fstp  dword[turn + 40]

    fld1
    fstp dword[turn + 60]
  ret
endp


proc Matrix.CreateScale, scaleC, scaleM 
          
  mov edi, [scaleM]  
          
  fld  [scaleC]    
  fstp [edi + Matrix4x4.m11]
  
  fld  [scaleC]
  fstp [edi + Matrix4x4.m22]
  
  fld  [scaleC]
  fstp [edi + Matrix4x4.m33]
  
  ret
endp

proc Matrix.Multiply4x4 uses ebx ecx edx, matrix1, matrix2, matrix_res 

   locals
     temp    dd     ?
   endl

   mov edx, [matrix_res]
   mov ecx, [matrix1]
   
   mov esi, 0
   gf_MatrixMultiply4x4.LoopA1:
   ;###########################111
       mov edi, 0
       gf_MatrixMultiply4x4.LoopA2:
       ;###########################222
           mov [temp], 0.0
           mov ebx, 0
           gf_MatrixMultiply4x4.LoopA3:
           ;###########################333
               fld dword[ecx + ebx]
               push ecx edx
               mov ecx, [matrix2]
               add ecx, edi
               fmul dword[ecx + ebx * 4]  
               pop edx ecx
               fadd dword[temp]
               fstp dword[temp]
           ;###########################333  
           add ebx, 4
           cmp ebx, 4 * 4
           jnz gf_MatrixMultiply4x4.LoopA3
           
           mov eax, [temp]
           mov [edx + edi], eax
       ;###########################222
       add edi, 4
       cmp edi, 4 * 4
       jnz gf_MatrixMultiply4x4.LoopA2
   ;###########################111
   add esi, 16
   add edx, 16
   add ecx, 16
   cmp esi, 16 * 4
   jnz gf_MatrixMultiply4x4.LoopA1

  ret
endp


