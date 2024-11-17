proc Quaternion.CreateFromAxisAngle X, Y, Z, degree
    locals
        angle GLfloat ?
        toRadian GLfloat 180.0
        two GLfloat 2.0
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
    ret
endp

;pMatrix[ 0] = 1.0f - 2.0f * ( y * y + z * z ); 
;pMatrix[ 1] = 2.0f * (x * y + z * w);
;pMatrix[ 2] = 2.0f * (x * z - y * w);
;pMatrix[ 3] = 0.0f; 

proc Quaternion.CreateMatrix uses esi edi,\
                    matrix
    locals 
        two GLfloat 2.0
    endl
    mov esi, [matrix]

    fld [y]
    fmul st0, st0
    fld [z]
    fmul st0, st0
    faddp
    fmul [two]
    fsubr [one]

    fstp [esi + Matrix4x4.m11]

    fld [x]
    fmul [y]
    fld [z]
    fmul [w]
    faddp
    fmul [two]
    fstp [esi + Matrix4x4.m12]

    fld [x]
    fmul [z]
    fld [z]
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
    fld [y]
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
;    // w = cos( theta / 2 )
;    // x = X * sin( theta / 2 )
;    // y = Y * sin( theta / 2 )
;    // z = Z * sin( theta / 2 )