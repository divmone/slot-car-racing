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

proc Spline.GetTangentVector uses esi edi,\
        spline, result, time

        locals
                prevPoint Vector3 
                nextPoint Vector3 
                eps       dd    0.1
                prevTime      dd    ?
                nextTime      dd    ?
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

        lea eax, [prevPoint]
        lea ecx, [nextPoint]
        stdcall Vector3.Sub, ecx, eax

        mov edi, [result]
        lea eax, [nextPoint]
        mov esi, eax
        mov ecx, 3
        rep movsd 
        ret
endp
