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
        stdcall Vector3.CubicInterpolate, [esi + Spline.Point.pMainVertex],\
                        [esi + Spline.Point.pDirectionNext], [edi + Spline.Point.pDirectionPrev],\
                        [edi + Spline.Point.pMainVertex], [result], [f]

.Return:
        ret
endp

proc Spline.GetRotation uses esi edi,\ 
        spline, currentV, time

        locals
                prevPoint Vector3 
                nextPoint Vector3 
                dupValue dd ?
                eps       dd    0.01
                prevTime      dd    ?
                nextTime      dd    ?
                one dd 1.0
                toDegree dd 180.0
        endl

        fld [time]
        fsub [eps]
        fstp [prevTime]

        fld [time]
        fadd [eps]
        fstp [nextTime]

        lea eax, [prevPoint]
        stdcall Spline.GetPoint, [spline], eax, [prevTime] 

        lea eax, [nextPoint]
        stdcall Spline.GetPoint, [spline], eax, [nextTime] 

        lea eax, [nextPoint]
        lea ecx, [prevPoint]

        stdcall Vector3.Sub, eax, ecx
        
        lea eax, [nextPoint]

        stdcall Vector3.GetAngleXZ, eax, car.matrix.m11

        
        ret
endp

proc Vector3.GetAngleXZ uses edi esi, v1, v2

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
        fsubr [car.transform.rotation.y]
        fstp [car.transform.rotation.y]
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
