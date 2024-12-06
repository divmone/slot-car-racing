proc Spline.GetPoint uses esi edi ebx,\
     spline, result, time

        locals
                t       dd      ?
                t2      dd      ?
                t1      dd      ?
                f       dd      ?
                index   dd      ?
        endl

        mov     esi, [spline]

        cmp     [esi + Spline.cycle], 1
        je      .DoNotCheck

        fld     [esi + Spline.time]                     ; tc
        fld     [time]                                  ; ts, tc
        fcomip  st0, st1                                ; tc
        fstp    [esi + Spline.time]                     ;
        ja      .Return                                 ; ts < tc

.DoNotCheck:
        mov     [index], 0

        fld     [esi + Spline.time]                     ; tc
        fld     [time]                                  ; ts, tc
        fprem                                           ; t, tc
        fstp    [t]                                     ; tc
        fstp    [esi + Spline.time]                     ;

        fldz                                            ; 0

        mov     ecx, [esi + Spline.pointsCount]
        mov     ebx, [esi + Spline.points]

.CheckPointsLoop:
        fadd    [ebx + Spline.Point.time]               ; t2
        fld     [t]                                     ; t, t2
        fcomip  st0, st1                                ; t2
        jb      .FoundTransition                        ; if t < t2

        add     ebx, sizeof.Spline.Point
        inc     [index]

        loop    .CheckPointsLoop

.FoundTransition:
        fst     [t2]                                    ; t2
        fld     st0                                     ; t2, t2
        fsub    [ebx + Spline.Point.time]               ; t1, t2
        fst     [t1]                                    ; t1, t2
        fsubp                                           ; (t2 - t1)
        fld     [t]                                     ; t, (t2 - t1)
        fsub    [t1]                                    ; (t - t1), (t2 - t1)
        fdivrp                                          ; f
        fstp    [f]                                     ;

        mov     eax, sizeof.Spline.Point
        xor     edx, edx
        mul     [index]

        mov     ebx, [spline]
        mov     esi, [ebx + Spline.points]
        add     esi, eax

        mov     edi, esi
        add     edi, sizeof.Spline.Point

        mov     ecx, [index]
        inc     ecx
        cmp     ecx, [ebx + Spline.pointsCount]
        jne     .Calculate
        mov     edi, [ebx + Spline.points]

.Calculate:
        stdcall Spline.CurveBezier2, [esi + Spline.Point.pMainVertex],\
                        [esi + Spline.Point.pDirectionNext], [edi + Spline.Point.pDirectionPrev],\
                        [edi + Spline.Point.pMainVertex], [result], [f]

.Return:
        ret
endp

proc Spline.CurveBezier2 uses esi, p1, p2, p3, p4, result, f
        locals 
                t dd ?
                tt dd ?
                ttt dd ?
                tempVector Vector4 
        
        endl

        fld [f]
        fst [t]
        fmul [f]
        fst [tt]
        fmul [f]
        fstp [ttt]

        lea esi, [tempVector]
        fld1
        fstp dword[esi + Vector4.x]
        fld [t]
        fstp dword[esi + Vector4.y]
        fld [tt]
        fstp dword[esi + Vector4.z]
        fld [ttt]
        fstp dword[esi + Vector4.w]

        stdcall Vector3.SMultiplyMatrix, esi, splineMatrix, splineVector 

        memcpy t1, [p1], 12
        memcpy t2, [p2], 12
        memcpy t3, [p3], 12
        memcpy t4, [p4], 12

        stdcall Vector3.CrossValue, t1, [splineVector.x]
        stdcall Vector3.CrossValue, t2, [splineVector.y]
        stdcall Vector3.CrossValue, t3, [splineVector.z]
        stdcall Vector3.CrossValue, t4, [splineVector.w]

        mov esi, [result]
        stdcall Vector3.Copy, esi, t1
        stdcall Vector3.Add, esi, t2
        stdcall Vector3.Add, esi, t3
        stdcall Vector3.Add, esi, t4

        ret
endp

proc Vector4.Multiply uses esi edi ebx, v1, v2, r1
        locals 
                t1 Vector3
                t2 Vector3
                t3 Vector3
                t4 Vector3
        endl

        mov esi, [v1]
        stdcall Vector3.CrossValue,


        ret
endp
proc Spline.CurveBezier, p1, p2, p3, p4, result, f
        locals
           t dd ?
           tt dd ?
           ttt dd ?
           three dd 3.0
           six dd 6.0
           q1 dd ?
           q2 dd ?
           q3 dd ?
           q4 dd ?
           t1 Vector3
           t2 Vector3
           t3 Vector3
           t4 Vector3
        endl

        mov eax, [f]
        mov [t], eax
        fld [t]
        fmul [t]
        fst [tt]
        fmul [t]
        fstp [ttt]

;-t^3+3t^2-3t+1

        fld1
        fchs
        fmul [ttt]
        fld [three]
        fmul [tt]
        faddp

        fld [three]
        fmul [t]
        fsubp
        fld1
        faddp
        fstp [q1]

;3t^3-6t^2+3t

        fld [three]
        fmul [ttt]
        fld [tt]
        fmul [six]
        fsubp
        fld [three]
        fmul [t]
        faddp
        fstp [q2]
;-3t^3+3t^2
        fld [three]
        fchs 
        fmul [ttt]
        fld [tt]
        fmul [three]
        faddp
        fstp [q3]
;t^3
        fld [ttt]
        fstp [q4]
   
        lea eax, [t1]
        memcpy eax, [p1], 12 

        lea eax, [t2]
        memcpy eax, [p2], 12 

        lea eax, [t3]
        memcpy eax, [p3], 12 

        lea eax, [t4]
        memcpy eax, [p4], 12 

        lea eax, [t1]
        stdcall Vector3.CrossValue, eax, [q1]
        lea eax, [t2]
        stdcall Vector3.CrossValue, eax, [q2]
        lea eax, [t3]
        stdcall Vector3.CrossValue, eax, [q3]
        lea eax, [t4]
        stdcall Vector3.CrossValue, eax, [q4]

        lea eax, [t1]
        stdcall Vector3.Add, [result], eax
        lea eax, [t2]
        stdcall Vector3.Add, [result], eax
        lea eax, [t3]
        stdcall Vector3.Add, [result], eax
        lea eax, [t4]
        stdcall Vector3.Add, [result], eax
        ret
endp

proc Vector3.SMultiplyMatrix uses esi edi ebx, v1, m1, r1

        mov esi, [v1]
        mov edi, [m1]
        mov ebx, [r1]

        ;1c
        mov ecx, 4
.loop:
        fld dword[esi]
        fmul dword[edi]
        fld dword[esi + 4]
        fmul dword[edi + 16]
        faddp
        fld dword[esi + 8]
        fmul dword[edi + 32]
        faddp
        fld dword[esi + 12]
        fmul dword[edi + 48]
        faddp
        fstp dword[ebx]
        add edi, 4
        add ebx, 4
        loop .loop
        ret
endp

proc Spline.CatmullRom uses esi edi, p0, p1, m0, m1, t
        locals
                tt dd ?
                ttt dd ?
                q0 dd ?
                q1 dd ?
                q2 dd ?
                q3 dd ?
                tx dd ?
                ty dd ?
                
        endl
     


        ret
endp


proc Spline.GetDerivative  uses esi edi ebx,\
     spline, result, time

        locals
                t       dd      ?
                t2      dd      ?
                t1      dd      ?
                f       dd      ?
                index   dd      ?
        endl

        mov     esi, [spline]

        cmp     [esi + Spline.cycle], 1
        je      .DoNotCheck

        fld     [esi + Spline.time]                     ; tc
        fld     [time]                                  ; ts, tc
        fcomip  st0, st1                                ; tc
        fstp    [esi + Spline.time]                     ;
        ja      .Return                                 ; ts < tc

.DoNotCheck:
        mov     [index], 0

        fld     [esi + Spline.time]                     ; tc
        fld     [time]                                  ; ts, tc
        fprem                                           ; t, tc
        fstp    [t]                                     ; tc
        fstp    [esi + Spline.time]                     ;

        fldz                                            ; 0

        mov     ecx, [esi + Spline.pointsCount]
        mov     ebx, [esi + Spline.points]

.CheckPointsLoop:
        fadd    [ebx + Spline.Point.time]               ; t2
        fld     [t]                                     ; t, t2
        fcomip  st0, st1                                ; t2
        jb      .FoundTransition                        ; if t < t2

        add     ebx, sizeof.Spline.Point
        inc     [index]

        loop    .CheckPointsLoop

.FoundTransition:
        fst     [t2]                                    ; t2
        fld     st0                                     ; t2, t2
        fsub    [ebx + Spline.Point.time]               ; t1, t2
        fst     [t1]                                    ; t1, t2
        fsubp                                           ; (t2 - t1)
        fld     [t]                                     ; t, (t2 - t1)
        fsub    [t1]                                    ; (t - t1), (t2 - t1)
        fdivrp                                          ; f
        fstp    [f]                                     ;

        mov     eax, sizeof.Spline.Point
        xor     edx, edx
        mul     [index]

        mov     ebx, [spline]
        mov     esi, [ebx + Spline.points]
        add     esi, eax

        mov     edi, esi
        add     edi, sizeof.Spline.Point

        mov     ecx, [index]
        inc     ecx
        cmp     ecx, [ebx + Spline.pointsCount]
        jne     .Calculate
        mov     edi, [ebx + Spline.points]

.Calculate:
        stdcall Spline.GetCurveBezierDerivate, [esi + Spline.Point.pMainVertex],\
                        [esi + Spline.Point.pDirectionNext], [edi + Spline.Point.pDirectionPrev],\
                        [edi + Spline.Point.pMainVertex], [result], [f]

.Return:
        ret
endp

proc Spline.GetAcceleration uses esi edi ebx,\
     spline, result, time

        locals
                t       dd      ?
                t2      dd      ?
                t1      dd      ?
                f       dd      ?
                index   dd      ?
        endl

        mov     esi, [spline]

        cmp     [esi + Spline.cycle], 1
        je      .DoNotCheck

        fld     [esi + Spline.time]                     ; tc
        fld     [time]                                  ; ts, tc
        fcomip  st0, st1                                ; tc
        fstp    [esi + Spline.time]                     ;
        ja      .Return                                 ; ts < tc

.DoNotCheck:
        mov     [index], 0

        fld     [esi + Spline.time]                     ; tc
        fld     [time]                                  ; ts, tc
        fprem                                           ; t, tc
        fstp    [t]                                     ; tc
        fstp    [esi + Spline.time]                     ;

        fldz                                            ; 0

        mov     ecx, [esi + Spline.pointsCount]
        mov     ebx, [esi + Spline.points]

.CheckPointsLoop:
        fadd    [ebx + Spline.Point.time]               ; t2
        fld     [t]                                     ; t, t2
        fcomip  st0, st1                                ; t2
        jb      .FoundTransition                        ; if t < t2

        add     ebx, sizeof.Spline.Point
        inc     [index]

        loop    .CheckPointsLoop

.FoundTransition:
        fst     [t2]                                    ; t2
        fld     st0                                     ; t2, t2
        fsub    [ebx + Spline.Point.time]               ; t1, t2
        fst     [t1]                                    ; t1, t2
        fsubp                                           ; (t2 - t1)
        fld     [t]                                     ; t, (t2 - t1)
        fsub    [t1]                                    ; (t - t1), (t2 - t1)
        fdivrp                                          ; f
        fstp    [f]                                     ;

        mov     eax, sizeof.Spline.Point
        xor     edx, edx
        mul     [index]

        mov     ebx, [spline]
        mov     esi, [ebx + Spline.points]
        add     esi, eax

        mov     edi, esi
        add     edi, sizeof.Spline.Point

        mov     ecx, [index]
        inc     ecx
        cmp     ecx, [ebx + Spline.pointsCount]
        jne     .Calculate
        mov     edi, [ebx + Spline.points]

.Calculate:
        stdcall Spline.GetCurveBezierAcceleration, [esi + Spline.Point.pMainVertex],\
                        [esi + Spline.Point.pDirectionNext], [edi + Spline.Point.pDirectionPrev],\
                        [edi + Spline.Point.pMainVertex], [result], [f]

.Return:
        ret
endp


proc Spline.GetCurveBezierDerivate uses esi, p1, p2, p3, p4, result, f
        locals 
                t dd ?
                tt dd ?
                two dd 2.0
                three dd 3.0
                tempVector Vector4 
        endl

        fld [f]
        fst [t]
        fmul [f]
        fstp [tt]


        lea esi, [tempVector]
        fldz
        fstp dword[esi + Vector4.x]
        fld1
        fstp dword[esi + Vector4.y]
        fld [t]
        fmul [two]
        fstp dword[esi + Vector4.z]
        fld [tt]
        fmul [three]
        fstp dword[esi + Vector4.w]

        stdcall Vector3.SMultiplyMatrix, esi, splineMatrix, splineVector 

        memcpy t1, [p1], 12
        memcpy t2, [p2], 12
        memcpy t3, [p3], 12
        memcpy t4, [p4], 12

        stdcall Vector3.CrossValue, t1, [splineVector.x]
        stdcall Vector3.CrossValue, t2, [splineVector.y]
        stdcall Vector3.CrossValue, t3, [splineVector.z]
        stdcall Vector3.CrossValue, t4, [splineVector.w]

        mov esi, [result]
        stdcall Vector3.Copy, esi, t1
        stdcall Vector3.Add, esi, t2
        stdcall Vector3.Add, esi, t3
        stdcall Vector3.Add, esi, t4

        ret
endp


proc Spline.GetCurveBezierAcceleration uses esi, p1, p2, p3, p4, result, f
        locals 
                two dd 2.0
                six dd 6.0
                tempVector Vector4 
        endl

        lea esi, [tempVector]
        fldz
        fstp dword[esi + Vector4.x]
        fldz
        fstp dword[esi + Vector4.y]
        fld [two]
        fstp dword[esi + Vector4.z]
        fld [f]
        fmul [six]
        fstp dword[esi + Vector4.w]

        stdcall Vector3.SMultiplyMatrix, esi, splineMatrix, splineVector 

        memcpy t1, [p1], 12
        memcpy t2, [p2], 12
        memcpy t3, [p3], 12
        memcpy t4, [p4], 12

        stdcall Vector3.CrossValue, t1, [splineVector.x]
        stdcall Vector3.CrossValue, t2, [splineVector.y]
        stdcall Vector3.CrossValue, t3, [splineVector.z]
        stdcall Vector3.CrossValue, t4, [splineVector.w]

        mov esi, [result]
        stdcall Vector3.Copy, esi, t1
        stdcall Vector3.Add, esi, t2
        stdcall Vector3.Add, esi, t3
        stdcall Vector3.Add, esi, t4

        ret
endp

proc Spline.GetRotation uses esi edi,\ 
        spline, objPtr, time

        locals
                axis Vector3
                point Vector3
                dupValue dd ?
                eps       dd    0.001
                prevTime      dd    ?
                nextTime      dd    ?
                one dd 1.0
                toDegree dd 180.0
                angle dd 0.0
                ninety dd 90.0
                tempq quaternion
        endl

        lea eax, [point]
        stdcall Spline.GetDerivative, [spline], eax, [time]

        ; lea eax, [point]
        ; stdcall Vector3.Normalize, eax

        lea esi, [point]
        fld dword [esi]
        fchs
        fld dword [esi + 8]
        fpatan
        fmul [toDegree]
        fldpi
        fdivr st0, st1
        fstp st1
        fstp [angle]
      
        



        stdcall Quaternion.CreateFromAxisAngle, [objPtr], 0.0, 1.0, 0.0, [angle]
.skip:        
      ret
endp
;  double sinp = std::sqrt(1 + 2 * (q.w * q.y - q.x * q.z));
;     double cosp = std::sqrt(1 - 2 * (q.w * q.y - q.x * q.z));
;     angles.pitch = 2 * std::atan2(sinp, cosp) - M_PI / 2;

proc Quaternion.ToEuler uses esi, objPtr
        locals
               sinp dd ?
                two dd 2.0
                result dd ?
        endl

        mov esi, [objPtr]
        fld dword[esi + quaternion.w]
        fmul dword[esi + quaternion.y]
        fld dword[esi + quaternion.x]
        fmul dword[esi + quaternion.z]
        fsubp
        fmul [two]
        fld1
        faddp
        fsqrt
        fstp [sinp]

        fld dword[esi + quaternion.w]
        fmul dword[esi + quaternion.y]
        fld dword[esi + quaternion.x]
        fmul dword[esi + quaternion.z]
        fsubp
        fmul [two]
        fld1
        fsubrp
        fsqrt
        fld [sinp]
        fpatan
        fmul [two]
        fldpi
        fdiv [two]
        fsubp

        fstp [result]

        mov eax, [result]
        ret
endp
 ;stdcall Matrix.Multiply4x4, tempMatrix,  car.rmatrix, car.rmatrix

        ;stdcall Matrix.Normalize, car.rmatrix

proc Matrix.Normalize uses esi edi,\ 
        matrix

    lea esi, [matrix]
    stdcall Vector3.Normalize, esi        ; Нормализуем 1-ю строку
    add esi, 16
    stdcall Vector3.Normalize, esi        ; Нормализуем 2-ю строку
    add esi, 16
    stdcall Vector3.Normalize, esi        ; Нормализуем 3-ю строку
    ret
endp

proc Vector3.GetAngle uses edi esi, v1, v2

        locals
                dupValue dd 0.0
                one dd 1.0
                toDegree dd 180.0
        endl

        stdcall Vector3.Normalize, [v1]

        stdcall Vector3.Normalize, [v2]

        stdcall Vector3.Dup, [v1], [v2]

        mov [dupValue], eax
        fld [dupValue]    
        fld st0
        fmul st0, st0
        fsubr [one] 
        fsqrt
        fxch
        fpatan
        fmul [toDegree]
        fldpi
        fdivr st0, st1
        fstp st1
        fstp [dupValue]
        mov eax, [dupValue]
        ret
endp

proc Vector3.GetAngleXY uses edi esi, v1, v2
 
        locals
                dupValue dd 0.0
                one dd 1.0
                toDegree dd 180.0
        endl

        stdcall Vector3.Copy, vec1, [v1]

        stdcall Vector3.Copy, vec2, [v2]

        
        stdcall Vector3.Normalize, vec1

        stdcall Vector3.Normalize, vec2

        stdcall Vector3.Dup, vec1, vec2

        mov [dupValue], eax

        fld [dupValue]    
        fld st0
        fmul st0, st0
        fsubr [one] 
        fsqrt
        fxch
        fpatan
        fmul [toDegree]
        fldpi
        fdivr st0, st1
        fstp st1

        ;fsubr [car.transform.rotation.z]
        fstp [car.transform.rotation.z]

        ret
endp

proc Vector3.GetAngleYZ uses edi esi, v1, v2

        locals
                vec1  Vector3
                vec2  Vector3
                dupValue dd ?
                one dd 1.0
                toDegree dd 180.0
                zero dd 10.0
        endl

        lea eax, [vec1]
        mov edi, eax
        mov esi, [v1]
        mov ecx, 3
        rep movsd

        lea eax, [vec2]
        mov edi, eax
        mov esi, [v2]
        mov ecx, 3
        rep movsd

        mov dword[vec1], 0.0
        mov dword[vec2], 0.0

        lea eax, [vec1]
        stdcall Vector3.Normalize, eax

        lea eax, [vec2]
        stdcall Vector3.Normalize, eax

        lea eax, [vec1]
        lea ecx, [vec2]
        stdcall Vector3.Dup, eax, ecx
        mov [dupValue], eax

        finit

        fld [dupValue]    
        fld st0
        fmul st0, st0
        fsubr [one] 
        fsqrt
        fxch
        fpatan
        fmul [toDegree]
        fldpi
        fdivr st0, st1
        ;fchs
        ;fadd [car.transform.rotation.x]
        fstp [car.transform.rotation.x]

        ret
endp


proc Vector3.DupXY uses edi esi, Vec1, Vec2
     locals
          res   dd    ?
     endl
     mov esi, [Vec1]
     mov edi, [Vec2]
  
     fld  dword[esi]
     fmul dword[edi]
     fld  dword[esi + 4]
     fmul dword[edi + 4]
     fadd st0, st1
     fstp [res]
     mov eax, [res]

  ret
endp

proc Vector3.DupXZ uses edi esi, Vec1, Vec2
     locals
          res   dd    ?
     endl
     mov esi, [Vec1]
     mov edi, [Vec2]
  
     fld  dword[esi]
     fmul dword[edi]
     fld  dword[esi + 8]
     fmul dword[edi + 8]
     fadd st0, st1
     fstp [res]
     mov eax, [res]

  ret
endp


