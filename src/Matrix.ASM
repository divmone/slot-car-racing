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
        ret
endp  

proc Matrix.Ortho uses esi edi,\
             matrix, left, right, bottom, top, zNear, zFar

  locals
    two dd 2.0
    mtwo dd -2.0
    mone dd -1.0
  endl

  mov esi, [matrix]

  ;mov     edi, esi
  ;mov     eax, 0
  ;mov     ecx, 16
  ;rep     stosd

  fld [right]
  fsub [left]
  fdivr [two]
  fstp dword[esi + Matrix4x4.m11]

  fld [top]
  fsub [bottom]
  fdivr [two]
  fstp dword[esi + Matrix4x4.m22]

  fld [zFar]
  fsub [zNear]
  fdivr [mtwo]
  fstp dword[esi + Matrix4x4.m33]

  fld1
  fstp dword[esi + Matrix4x4.m44]

  fld [right]
  fadd [left]
  fld [right]
  fsub [left]
  fdivp
  fmul [mone]
  fstp dword[esi + Matrix4x4.m14]

  fld [top]
  fadd [bottom]
  fld [top]
  fsub [bottom]
  fdivp
  fmul [mone]
  fstp dword[esi + Matrix4x4.m24]

  fld [zFar]
  fadd [zNear]
  fld [zFar]
  fsub [zNear]
  fdivp
  fmul [mone]
  fstp dword[esi + Matrix4x4.m34]

  ret
endp

proc Matrix.LookAt uses esi edi ebx,\
     camera, target, up

        locals
                temp    dd              ?
                zAxis   Vector3
                xAxis   Vector3
                yAxis   Vector3
        endl

        invoke  glLoadIdentity

        mov     edi, view
        mov     ecx, 4 * 4
        xor     eax, eax
        rep     stosd

        mov     esi, [camera]
        mov     edi, [target]
        mov     ebx, [up]

        fld     [edi + Vector3.x]
        fsub    [esi + Vector3.x]
        fstp    [zAxis.x]

        fld     [edi + Vector3.y]
        fsub    [esi + Vector3.y]
        fstp    [zAxis.y]

        fld     [edi + Vector3.z]
        fsub    [esi + Vector3.z]
        fstp    [zAxis.z]

        lea     eax, [zAxis]
        stdcall Vector3.Normalize, eax

        lea     eax, [zAxis]
        lea     ecx, [xAxis]
        stdcall Vector3.Cross, eax, ebx, ecx

        lea     eax, [xAxis]
        stdcall Vector3.Normalize, eax

        lea     eax, [xAxis]
        lea     ecx, [zAxis]
        lea     ebx, [yAxis]
        stdcall Vector3.Cross, eax, ecx, ebx

        lea     esi, [xAxis]

        mov     edi, view
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

        lea     esi, [zAxis]
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
        fld     [esi + Vector3.x]
        fchs
        fstp    [temp]
        push    [temp]
        invoke  glTranslatef

        invoke  glRotatef, 135.0, 0.0, 1.0, 0.0
        invoke glGetFloatv, GL_MODELVIEW_MATRIX, view

        ret
endp         

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

proc Matrix.CreateModel2 uses esi edi, pos, turnC, scaleC

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


proc Matrix.CreatePosition uses esi edi, posV, positionM
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


proc Matrix.CreateTurn uses esi edi , objPtr, turnV

    locals
       a  dd  ?
       b  dd  ?
       c  dd  ?
       PiDegree dd 180.0
    endl
    mov esi, [turnV]
    mov edi ,[objPtr]
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
    fstp  dword[edi + 0]

    fld  [c]
    fsin
    fld  [b]
    fcos
    fmulp
    fchs
    fstp  dword[edi + 4]

    fld  [b]
    fsin
    fstp  dword[edi + 8]

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
    fstp  dword[edi + 16]

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
    fstp  dword[edi + 20]

    fld  [a]
    fsin
    fld  [b]
    fcos
    fmulp
    fchs
    fstp  dword[edi + 24]

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
    fstp  dword[edi + 32]

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
    fstp dword [edi + 36]

    fld  [a]
    fcos
    fld  [b]
    fcos
    fmulp
    fstp  dword[edi + 40]

    fld1
    fstp dword[edi + 60]
  ret
endp


proc Matrix.CreateScale uses esi edi, scaleC, scaleM 

  mov esi, [scaleC]     
  mov edi, [scaleM]  
          
  fld  [esi + Vector3.x]    
  fstp [edi + Matrix4x4.m11]
  
  fld  [esi + Vector3.y]
  fstp [edi + Matrix4x4.m22]
  
  fld  [esi + Vector3.z]
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
       mov edi, 0
       gf_MatrixMultiply4x4.LoopA2:
           mov [temp], 0.0
           mov ebx, 0
           gf_MatrixMultiply4x4.LoopA3:
               fld dword[ecx + ebx]
               push ecx edx
               mov ecx, [matrix2]
               add ecx, edi
               fmul dword[ecx + ebx * 4]  
               pop edx ecx
               fadd dword[temp]
               fstp dword[temp]
           add ebx, 4
           cmp ebx, 4 * 4
           jnz gf_MatrixMultiply4x4.LoopA3
           
           mov eax, [temp]
           mov [edx + edi], eax
       add edi, 4
       cmp edi, 4 * 4
       jnz gf_MatrixMultiply4x4.LoopA2
   add esi, 16
   add edx, 16
   add ecx, 16
   cmp esi, 16 * 4
   jnz gf_MatrixMultiply4x4.LoopA1

  ret
endp

proc Matrix.CreateModel uses esi edi, objPtr
    mov esi, [objPtr]
    add esi, Object.transform.position
    stdcall Matrix.CreatePosition, esi, position 

    mov esi, [objPtr]
    add esi, Object.transform.scale
    stdcall Matrix.CreateScale, esi, scale


    ;stdcall Quaternion.CreateFromAxisAngle, [objPtr], 0.0, 1.0, 0.0, 90.0

    
    stdcall Quaternion.CreateMatrix, [objPtr], turn
    
    ; mov esi, [objPtr]
    ; add esi, Object.transform.rotation
    ; stdcall Matrix.CreateTurn, turn, esi

    stdcall Matrix.Multiply4x4, scale, turn, model 
    stdcall Matrix.Multiply4x4, model, position, model 

    mov edi, [objPtr]
    add edi, Object.matrix
    mov esi, model
    mov ecx, 16
    rep movsd




    ret
endp