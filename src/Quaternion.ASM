proc Quaternion.CreateFromAxisAngle uses esi, objPtr, X, Y, Z, degree
    locals
        angle GLfloat ?
        toRadian GLfloat 180.0
        two GLfloat 2.0
        x GLfloat 0.0
        y GLfloat 0.0
        z GLfloat 0.0
        w GLfloat 0.0
    endl

    fld [degree]
    fdiv [toRadian]
    fldpi
    fmulp
    fdiv [two]
    fsincos
    fxch
    fstp [w]

    fst [angle]

    fmul [X]
    fstp [x]

    fld [angle]
    fmul [Y]
    fstp [y]

    fld [angle]
    fmul [Z]
    fstp [z]

    mov esi, [objPtr]
    mov eax, [x]
    mov [esi + Object.q.x], eax

    mov eax, [y]
    mov [esi + Object.q.y], eax

    mov eax, [z]
    mov [esi + Object.q.z], eax

    mov eax, [w]
    mov [esi + Object.q.w], eax

    ret
endp

proc Quaternion.CreateMatrix uses esi edi,\
                    objPtr, matrix
    locals 
        two GLfloat 2.0
        one dd 1.0
        x GLfloat 0.0
        y GLfloat 0.0
        z GLfloat 0.0
        w GLfloat 0.0
    endl
    mov esi, [objPtr]

    mov eax, [esi + Object.q.x]
    mov [x], eax
    mov eax, [esi + Object.q.y]
    mov [y], eax
    mov eax, [esi + Object.q.z]
    mov [z], eax
    mov eax, [esi + Object.q.w]
    mov [w], eax

    mov esi, [matrix]

    fld [y]   ;1 - 2(yy +zz)
    fmul st0, st0
    fld [z]
    fmul st0, st0
    faddp
    fmul [two]
    fsubr [one]

    fstp [esi + Matrix4x4.m11]

    fld [x] ;2(xy + zz)
    fmul [y]
    fld [z]
    fmul [w]
    faddp
    fmul [two]
    fstp [esi + Matrix4x4.m12]

    fld [x] ; 2(x*z - yw)
    fmul [z]
    fld [y]
    fmul [w]
    fsubp
    fmul [two]
    fstp [esi + Matrix4x4.m13]

    mov [esi + Matrix4x4.m14], 0.0

    fld [x]
    fmul [y]
    fld [z]
    fmul [w]
    fsubp
    fmul [two]
    fstp [esi + Matrix4x4.m21]

    fld [x]
    fmul st0, st0
    fld [z]
    fmul st0, st0
    faddp
    fmul [two]
    fsubr [one]

    fstp [esi + Matrix4x4.m22]

    fld [z]
    fmul [y]
    fld [x]
    fmul [w]
    faddp
    fmul [two]
    fstp [esi + Matrix4x4.m23]

    mov [esi + Matrix4x4.m24], 0.0

    fld [x]
    fmul [z]
    fld [y]
    fmul [w]
    faddp
    fmul [two]
    fstp [esi + Matrix4x4.m31]

    fld [y]
    fmul [z]
    fld [x]
    fmul [w]
    fsubp
    fmul [two]
    fstp [esi + Matrix4x4.m32]

    fld [x]
    fmul st0, st0
    fld [y]
    fmul st0, st0
    faddp
    fmul [two]
    fsubr [one]
    fstp [esi + Matrix4x4.m33]

    mov [esi + Matrix4x4.m34], 0.0

    mov [esi + Matrix4x4.m41], 0.0
    mov [esi + Matrix4x4.m42], 0.0
    mov [esi + Matrix4x4.m43], 0.0
    mov [esi + Matrix4x4.m44], 1.0

    ret
endp 