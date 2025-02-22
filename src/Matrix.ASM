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

        ;invoke  glRotatef, 135.0, 0.0, 1.0, 0.0
        invoke glGetFloatv, GL_MODELVIEW_MATRIX, view

        ret
endp    


proc Matrix.LookAt2 uses esi edi ebx,\
     camera, target, up, matrix

    locals
        temp dd ?
        f Vector3
        u Vector3
        s Vector3                   
    endl

    lea eax, [f]
    stdcall Vector3.Copy, eax, [target]
    
    lea eax, [f]
    stdcall Vector3.Sub, eax, [camera]

    lea eax, [f]
    stdcall Vector3.Normalize, eax

    lea eax, [u]
    stdcall Vector3.Copy, eax, [up]

    lea eax, [u]
    stdcall Vector3.Normalize, eax

    lea eax, [s]
    lea ecx, [f]
    lea edx, [u]
    stdcall Vector3.Cross, ecx, edx, eax

    lea eax, [s]
    stdcall Vector3.Normalize, eax

    lea eax, [s]
    lea ecx, [f]
    lea edx, [u]
    stdcall Vector3.Cross, eax, ecx, edx

    ; mov     edi, [matrix]
    ; mov     eax, 0.0
    ; mov     ecx, 16
    ; rep     stosd

    mov esi, [matrix]
    mov eax, [s.x]
    mov [esi + Matrix4x4.m11], eax
    mov eax, [s.y]
    mov [esi + Matrix4x4.m21], eax
    mov eax, [s.z]
    mov [esi + Matrix4x4.m31], eax

    mov eax, [u.x]
    mov [esi + Matrix4x4.m12], eax
    mov eax, [u.y]
    mov [esi + Matrix4x4.m22], eax
    mov eax, [u.z]
    mov [esi + Matrix4x4.m32], eax

    fld [f.x]
    fchs
    fstp [esi + Matrix4x4.m13]
    fld [f.y]
    fchs
    fstp [esi + Matrix4x4.m23]
    fld [f.z]
    fchs
    fstp [esi + Matrix4x4.m33]

    lea eax, [s]
    stdcall Vector3.Dup, eax, [camera]
    mov [temp], eax
    fld [temp]
    fchs
    fstp [esi + Matrix4x4.m41]

    lea eax, [u]
    stdcall Vector3.Dup, eax, [camera]
    mov [temp], eax
    fld [temp]
    fchs
    fstp [esi + Matrix4x4.m42]


    lea eax, [f]
    stdcall Vector3.Dup, eax, [camera]
    mov [esi + Matrix4x4.m43], eax

    mov [esi + Matrix4x4.m44], 1.0
    
    
    ret
endp    

; gluLookAt(GLdouble eyex, GLdouble eyey, GLdouble eyez, GLdouble centerx,
; 	  GLdouble centery, GLdouble centerz, GLdouble upx, GLdouble upy,
; 	  GLdouble upz)
; {
;     float forward[3], side[3], up[3];
;     GLfloat m[4][4];

;     forward[0] = centerx - eyex;
;     forward[1] = centery - eyey;
;     forward[2] = centerz - eyez;

;     up[0] = upx;
;     up[1] = upy;
;     up[2] = upz;

;     normalize(forward);

;     /* Side = forward x up */
;     cross(forward, up, side);
;     normalize(side);

;     /* Recompute up as: up = side x forward */
;     cross(side, forward, up);

;     __gluMakeIdentityf(&m[0][0]);
;     m[0][0] = side[0];
;     m[1][0] = side[1];
;     m[2][0] = side[2];

;     m[0][1] = up[0];
;     m[1][1] = up[1];
;     m[2][1] = up[2];

;     m[0][2] = -forward[0];
;     m[1][2] = -forward[1];
;     m[2][2] = -forward[2];

;     glMultMatrixf(&m[0][0]);
;     glTranslated(-eyex, -eyey, -eyez);
; }
; mat4x4 lookAt(vec3  const & eye, vec3  const & center, vec3  const & up)
; {
;     vec3  f = normalize(center - eye);
;     vec3  u = normalize(up);
;     vec3  s = normalize(cross(f, u));
;     u = cross(s, f);

;     mat4x4 Result(1);
;     Result[0][0] = s.x;
;     Result[1][0] = s.y;
;     Result[2][0] = s.z;

;     Result[0][1] = u.x;
;     Result[1][1] = u.y;
;     Result[2][1] = u.z;

;     Result[0][2] =-f.x;
;     Result[1][2] =-f.y;
;     Result[2][2] =-f.z;
;     Result[3][0] =-dot(s, eye);
;     Result[3][1] =-dot(u, eye);
;     Result[3][2] = dot(f, eye);
;     return Result;
; }
; glm::mat4 calculate_lookAt_matrix(glm::vec3 position, glm::vec3 target, glm::vec3 worldUp)
; {
;     // 1. Position = known
;     // 2. Calculate cameraDirection
;     glm::vec3 zaxis = glm::normalize(position - target);

;     // 3. Get positive right axis vector
;     glm::vec3 xaxis = glm::normalize(glm::cross(glm::normalize(worldUp), zaxis));
;     // 4. Calculate camera up vector
;     
        ;glm::vec3 yaxis = glm::cross(zaxis, xaxis);

;     // Create translation and rotation matrix
;     // In glm we access elements as mat[col][row] due to column-major layout
;     glm::mat4 translation; // Identity matrix by default
;     translation[3][0] = -position.x; // Third column, first row
;     translation[3][1] = -position.y;
;     translation[3][2] = -position.z;
;     glm::mat4 rotation;
;     rotation[0][0] = xaxis.x; // First column, first row
;     rotation[1][0] = xaxis.y;
;     rotation[2][0] = xaxis.z;
;     rotation[0][1] = yaxis.x; // First column, second row
;     rotation[1][1] = yaxis.y;
;     rotation[2][1] = yaxis.z;
;     rotation[0][2] = zaxis.x; // First column, third row
;     rotation[1][2] = zaxis.y;
;     rotation[2][2] = zaxis.z; 

;     // Return lookAt matrix as combination of translation and rotation matrix
;     return rotation * translation; // Remember to read from right to left (first translation then rotation)
; }

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

proc Matrix.Multiply4x4 uses ebx esi, matrix1, matrix2, matrix_res 

   locals
     temp    dd     ?        ; Объявление временной переменной для хранения промежуточных результатов
   endl

   ; Устанавливаем указатели на входные и выходные матрицы
   mov edx, [matrix_res]      
   mov ecx, [matrix1]         
   
   mov esi, 0                  ; Инициализация счетчика для строк первой матрицы
   .LoopA1:
       mov edi, 0              ; Инициализация счетчика для столбцов второй матрицы
       .LoopA2:
           mov [temp], 0.0     ; Обнуляем временную переменную для хранения суммы произведений
           mov ebx, 0          ; Инициализация счетчика для элементов строки первой матрицы
           .LoopA3:
               fld dword[ecx + ebx]   ; Загружаем элемент из первой матрицы
               push ecx edx
               mov ecx, [matrix2]     
               add ecx, edi       
               fmul dword[ecx + ebx * 4]  ; Умножаем элементы матриц
               pop edx ecx           
               fadd dword[temp]     
               fstp dword[temp]     
           add ebx, 4               ; Переходим к следующему элементу строки первой матрицы
           cmp ebx, 4 * 4          
           jnz .LoopA3             
           
           mov eax, [temp]          ; Загружаем результат суммы произведений в eax
           mov [edx + edi], eax     ; Записываем результат в выходную матрицу (matrix_res)
       add edi, 4                   ; Переходим к следующему столбцу
       cmp edi, 4 * 4               ; Проверка завершения обработки всех столбцов
       jnz .LoopA2                  ; Если не все столбцы обработаны, продолжаем обработку
   add esi, 16                      ; Переходим к следующей строке первой матрицы
   add edx, 16                       ; Переходим к следующей строке выходной матрицы
   add ecx, 16                       ; Переходим к следующей строке второй матрицы
   cmp esi, 16 * 4                   ; Проверка завершения обработки всех строк первой матрицы
   jnz .LoopA1                       ; Если не все строки обработаны, продолжаем обработку

  ret                               ; Завершаем процедуру
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