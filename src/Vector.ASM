
proc Vector3.Length uses esi,\
     vector

        locals
                result  dd      ?
        endl

        mov     esi, [vector]

        fld     [esi + Vector3.x]
        fmul    [esi + Vector3.x]

        fld     [esi + Vector3.y]
        fmul    [esi + Vector3.y]

        fld     [esi + Vector3.z]
        fmul    [esi + Vector3.z]

        faddp
        faddp
        fsqrt
        fstp    [result]

        mov     eax, [result]

        ret
endp

proc Vector3.Distance uses esi edi,\
     v1, v2

        locals
                result  dd      ?
        endl

        mov     esi, [v1]
        mov     edi, [v2]

        fld     [esi + Vector3.x]
        fsub    [edi + Vector3.x]
        fmul    st0, st0

        fld     [esi + Vector3.y]
        fsub    [edi + Vector3.y]
        fmul    st0, st0

        fld     [esi + Vector3.z]
        fsub    [edi + Vector3.z]
        fmul    st0, st0

        faddp
        faddp
        fsqrt
        fstp    [result]

        mov     eax, [result]

        ret
endp

proc Vector3.Normalize uses edi,\
     vector

        locals
                l       dd      ?
        endl

        mov     edi, [vector]

        stdcall Vector3.Length, [vector]
        mov     [l], eax

        fld     [edi + Vector3.x]
        fdiv    [l]
        fstp    [edi + Vector3.x]

        fld     [edi + Vector3.y]
        fdiv    [l]
        fstp    [edi + Vector3.y]

        fld     [edi + Vector3.z]
        fdiv    [l]
        fstp    [edi + Vector3.z]

        ret
endp

proc Vector3.RotateRY   uses esi  ebx,\
     v1, theta, radius, result

     locals
            tempC    dd      ?
            tempS    dd      ?
            temp     dd      ?
     endl

     mov     esi, [v1]
     mov     ebx, [result]

     fldpi           ;pi
     fimul    [theta] ;pi*theta
     fdiv   [tAngle]
     fst     [temp]    ;(pi*theta)/180
     fcos            ;cos((pi*theta)/180))
     fstp  [tempC]
     fld   [temp]
     fsin
     fstp   [tempS]

     fld [tempC]
     fmul [esi + Vector3.x]
     fadd [esi + Vector3.x]
     fstp [ebx + Vector3.x]

     fld [tempS]
     fmul [esi + Vector3.x]
     fadd [esi + Vector3.z]
     fstp [ebx + Vector3.z]

     ret
endp

proc Vector3.RotateX  uses esi  ebx,\
     v1, theta, result

     locals
            tempC    dd      ?
            tempS    dd      ?
            temp     dd      ?

     endl

     mov     esi, [v1]
     mov     ebx, [result]

     fld [PI]           ;pi
     fmul    [theta] ;pi*theta
     fdiv   [tAngle]
     fst     [temp]    ;(pi*theta)/180
     fcos            ;cos((pi*theta)/180))
     fstp  [tempC]
     fld   [temp]
     fsin
     fstp   [tempS]

     fld    [tempC]
     fmul   [esi + Vector3.y]
     fstp   [temp]

     fld    [tempS]
     fmul   [esi + Vector3.z]
     fadd   [temp]
     fstp   [ebx + Vector3.z]

     fld    [tempC]
     fmul   [esi + Vector3.y]
     fstp   [temp]

     fld    [tempS]
     fmul   [esi + Vector3.z]
     fchs
     fadd   [temp]
     fstp   [ebx + Vector3.y]

     ret

;z' = y * cos(theta) + z * sin(theta)
;y' = y * cos(theta) - z * sin(theta)

endp

proc Vector3.RotateY  uses esi  ebx,\
     v1, theta, result

     locals
            tempC    dd      ?
            tempS    dd      ?
            temp     dd      ?

     endl

     mov     esi, [v1]
     mov     ebx, [result]

     fldpi           ;pi
     fmul    [theta] ;pi*theta
     fdiv   [tAngle]
     fst     [temp]    ;(pi*theta)/180
     fcos            ;cos((pi*theta)/180))
     fstp  [tempC]
     fld   [temp]
     fsin
     fstp   [tempS]

     fld    [tempC]
     fmul   [esi + Vector3.x]
     fstp   [temp]

     fld    [tempS]
     fmul   [esi + Vector3.z]
     fadd   [temp]
     fstp   [ebx + Vector3.x]

     fld    [tempC]
     fmul   [esi + Vector3.z]
     fstp   [temp]

     fld    [tempS]
     fmul   [esi + Vector3.x]

     fsubr   [temp]
     fstp   [ebx + Vector3.z]

     fld     [esi + Vector3.y]
     fstp    [ebx + Vector3.y]

     ret

;x' = x * cos(theta) + z * sin(theta)
;z' = z * cos(theta) - x * sin(theta)

endp

;x'=x*cos(L)-y*sin(L);
;y'=-x*sin(L)+y*cos(L);
;z'=z;

proc Vector3.RotateZ  uses esi  ebx,\
     v1, theta, result

     locals
            tempC    dd      ?
            tempS    dd      ?
            temp     dd      ?

     endl

     mov     esi, [v1]
     mov     ebx, [result]

     fldpi           ;pi
     fmul    [theta] ;pi*theta
     fdiv   [tAngle]
     fst     [temp]    ;(pi*theta)/180
     fcos            ;cos((pi*theta)/180))
     fstp  [tempC]
     fld   [temp]
     fsin
     fstp   [tempS]

     fld    [tempC]
     fmul   [esi + Vector3.x]
     fstp   [temp]

     fld    [tempS]
     fmul   [esi + Vector3.y]
     fsub   [temp]
     fstp   [ebx + Vector3.x]

     fld    [tempC]
     fmul   [esi + Vector3.y]
     fstp   [temp]

     fld    [tempS]
     fmul   [esi + Vector3.x]

     fsubr   [temp]
     fstp   [ebx + Vector3.z]

     fld     [esi + Vector3.y]
     fstp    [ebx + Vector3.y]

     ret

endp

proc Vector3.Cross uses esi edi ebx,\
     v1, v2, result

        locals
                temp    dd      ?
        endl

        mov     esi, [v1]
        mov     edi, [v2]
        mov     ebx, [result]

        fld     [esi + Vector3.z]
        fmul    [edi + Vector3.y]
        fstp    [temp]
        fld     [esi + Vector3.y]
        fmul    [edi + Vector3.z]
        fsub    [temp]
        fstp    [ebx + Vector3.x]

        fld     [esi + Vector3.x]
        fmul    [edi + Vector3.z]
        fstp    [temp]
        fld     [esi + Vector3.z]
        fmul    [edi + Vector3.x]
        fsub    [temp]
        fstp    [ebx + Vector3.y]

        fld     [esi + Vector3.y]
        fmul    [edi + Vector3.x]
        fstp    [temp]
        fld     [esi + Vector3.x]
        fmul    [edi + Vector3.y]
        fsub    [temp]
        fstp    [ebx + Vector3.z]

        ret
endp

proc Vector3.Copy uses esi edi,\
     dest, src

        mov     esi, [src]
        mov     edi, [dest]
        mov     ecx, 3
        rep     movsd

        ret
endp

proc Vector3.Add uses esi edi,\
     dest, src

        mov     esi, [src]
        mov     edi, [dest]

        fld      [edi + Vector3.x]
        fadd     [esi + Vector3.x]
        fstp    [edi + Vector3.x]

        fld      [edi + Vector3.y]
        fadd     [esi + Vector3.y]
        fstp    [edi + Vector3.y]

        fld      [edi + Vector3.z]
        fadd     [esi + Vector3.z]
        fstp    [edi + Vector3.z]

        ret
endp

proc Vector3.Sub uses esi edi,\
     dest, src

        mov     esi, [src]
        mov     edi, [dest]

        fld     [edi + Vector3.x]
        fsub    [esi + Vector3.x]
        fstp    [edi + Vector3.x]

        fld     [edi + Vector3.y]
        fsub    [esi + Vector3.y]
        fstp    [edi + Vector3.y]

        fld     [edi + Vector3.z]
        fsub    [esi + Vector3.z]
        fstp    [edi + Vector3.z]

        ret
endp

 proc Vector3.Interpolate uses esi edi ebx,\
     v1, v2, result, f

        locals
                r       dd      ?
        endl

        mov     esi, [v1]
        mov     edi, [v2]
        mov     ebx, [result]

        fld1
        fsub    [f]
        fstp    [r]

        fld     [esi + Vector3.x]
        fmul    [r]
        fld     [edi + Vector3.x]
        fmul    [f]
        faddp
        fstp    [ebx + Vector3.x]

        fld     [esi + Vector3.y]
        fmul    [r]
        fld     [edi + Vector3.y]
        fmul    [f]
        faddp
        fstp    [ebx + Vector3.y]

        fld     [esi + Vector3.z]
        fmul    [r]
        fld     [edi + Vector3.z]
        fmul    [f]
        faddp
        fstp    [ebx + Vector3.z]

        ret
endp
proc Vector3.CubicInterpolate uses esi edi ebx,\
     v1, d1, d2, v2, result, f

        locals
                p0      Vector3
                p1      Vector3
                p2      Vector3
        endl

        lea     esi, [p0]
        lea     edi, [p1]
        lea     ebx, [p2]

        stdcall Vector3.Interpolate, [v1], [d1], esi, [f]
        stdcall Vector3.Interpolate, [d1], [d2], edi, [f]
        stdcall Vector3.Interpolate, [d2], [v2], ebx, [f]
        stdcall Vector3.Interpolate, esi, edi, esi, [f]
        stdcall Vector3.Interpolate, edi, ebx, edi, [f]
        stdcall Vector3.Interpolate, esi, edi, [result], [f]

        ret
endp

proc Vector3.Translate  uses esi edi ebx,\
     v1, x, y, z

     mov esi, [v1]

     fld [x]
     fadd  [esi + Vector3.x]
     fstp  [esi + Vector3.x]

     fld [y]
     fadd  [esi + Vector3.y]
     fstp  [esi + Vector3.y]

     fld [z]
     fadd  [esi + Vector3.z]
     fstp  [esi + Vector3.z]

     ret

endp


proc RotateCamera uses ebx ecx edx,\
     cameraPos, targetPos,upVec, angle

    locals
        deltaX  GLfloat ?
        deltaZ  GLfloat ?
        radius  GLfloat ?
        sinA    GLfloat ?
        cosA    GLfloat ?
    endl

    fld     [cameraPos + Vector3.x]
    fsub    [targetPos + Vector3.x]
    fstp    [deltaX]

    fld     [cameraPos  + Vector3.z]
    fsub    [targetPos  + Vector3.z]
    fstp    [deltaZ]

    fld     [deltaX]
    fmul    [deltaX]
    fld     [deltaZ]
    fmul    [deltaZ]
    faddp   st1, st0
    fsqrt
    fstp    [radius]

    fld     [angle]
    fsin
    fstp    [sinA]

    fld     [angle]
    fcos
    fstp    [cosA]


    fld     [radius]
    fmul    [cosA]
    fadd    [targetPos  + Vector3.x]
    fstp    [cameraPos  + Vector3.x]

    fld     [radius]
    fmul    [sinA]
    fadd    [targetPos  + Vector3.z]
    fstp    [cameraPos  + Vector3.z]

    ret
endp
