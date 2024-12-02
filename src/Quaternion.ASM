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

;pMatrix[ 0] = 1.0f - 2.0f * ( y * y + z * z ); 
;pMatrix[ 1] = 2.0f * (x * y + z * w);
;pMatrix[ 2] = 2.0f * (x * z - y * w);
;pMatrix[ 3] = 0.0f; 

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


; // pitch (y-axis rotation)

; // yaw (z-axis rotation)
; double siny_cosp = 2 * (q.w * q.z + q.x * q.y);
; double cosy_cosp = 1 - 2 * (q.y * q.y + q.z * q.z);
; angles.yaw = std::atan2(siny_cosp, cosy_cosp);

proc Quaternion.ToEulerAngles
    locals
        sinr_cosp GLfloat ?
        cosr_cosp GLfloat ?
        sinp GLfloat ?
        cosp GLfloat ?
        siny_cosp GLfloat ?
        cosy_cosp GLfloat ?
        two GLfloat 2.0
        one GLfloat 1.0
    endl

    ; double sinr_cosp = 2 * (q.w * q.x + q.y * q.z);
    ; double cosr_cosp = 1 - 2 * (q.x * q.x + q.y * q.y);
    ; angles.roll = std::atan2(sinr_cosp, cosr_cosp);

    fld [w]
    fmul [x]
    fld [y]
    fmul [z]
    faddp
    fmul [two]
    fstp [sinr_cosp]

    fld [x]
    fmul st0, st0
    fld [y]
    fmul st0, st0
    faddp
    fmul [two]
    fsubr [one]
    fld [sinr_cosp]
    fpatan 
    fstp [car.transform.rotation.x]

; double sinp = std::sqrt(1 + 2 * (q.w * q.y - q.x * q.z));
; double cosp = std::sqrt(1 - 2 * (q.w * q.y - q.x * q.z));
; angles.pitch = 2 * std::atan2(sinp, cosp) - M_PI / 2;

    fld [w]
    fmul [y]
    fld [x]
    fmul [z]
    fsubp
    fmul [two]
    fadd [one]
    fstp [sinp]

    fld [w]
    fmul [y]
    fld [x]
    fmul [z]
    fsubp
    fmul [two]
    fsubr [one]
    fld [sinp]
    fpatan
    fmul [two]
    fldpi
    fdiv [two]
    fsubp
    fstp [car.transform.rotation.y]


    ret
endp
;    // w = cos( theta / 2 )
;    // x = X * sin( theta / 2 )
;    // y = Y * sin( theta / 2 )
;    // z = Z * sin( theta / 2 )

proc Quaternion.Multiply uses esi edi ebx, q1, q2, result 
 
    mov esi, [q1]
    mov edi, [q2]
    mov ebx, [result]

    fld dword[esi + quaternion.w]
    fmul dword[edi + quaternion.w]

    fld dword[esi + quaternion.x]
    fmul dword[edi + quaternion.x]
    fsubp

    fld dword[esi + quaternion.y]
    fmul dword[edi + quaternion.y]
    fsubp

    fld dword[esi + quaternion.z]
    fmul dword[edi + quaternion.z]
    fsubp

    fstp [ebx + quaternion.w]

;-------------------------------------------------
    fld dword[esi + quaternion.w]
    fmul dword[edi + quaternion.x]

    fld dword[esi + quaternion.x]
    fmul dword[edi + quaternion.w]
    faddp

    fld dword[esi + quaternion.y]
    fmul dword[edi + quaternion.z]
    faddp

    fld dword[esi + quaternion.z]
    fmul dword[edi + quaternion.y]
    fsubp

    fstp [ebx + quaternion.x]
;---------------------------------------
    fld dword[esi + quaternion.w]
    fmul dword[edi + quaternion.y]

    fld dword[esi + quaternion.y]
    fmul dword[edi + quaternion.w]
    faddp

    fld dword[esi + quaternion.z]
    fmul dword[edi + quaternion.x]
    faddp

    fld dword[esi + quaternion.x]
    fmul dword[edi + quaternion.z]
    fsubp

    fstp [ebx + quaternion.y]
;-----------------------------
    fld dword[esi + quaternion.w]
    fmul dword[edi + quaternion.z]

    fld dword[esi + quaternion.z]
    fmul dword[edi + quaternion.w]
    faddp

    fld dword[esi + quaternion.x]
    fmul dword[edi + quaternion.y]
    faddp

    fld dword[esi + quaternion.y]
    fmul dword[edi + quaternion.x]
    fsubp
    fstp [ebx + quaternion.z]

    ret
endp

proc Quaternion.Add uses esi edi, dest, src
    mov esi, [dest]
    mov edi, [src]

    fld dword[esi]
    fadd dword[edi]
    fstp dword[esi]

    
    fld dword[esi + 4]
    fadd dword[edi + 4]
    fstp dword[esi + 4]

    
    fld dword[esi + 8]
    fadd dword[edi + 8]
    fstp dword[esi + 8]

    
    fld dword[esi + 12]
    fadd dword[edi + 12]
    fstp dword[esi + 12]
       
    ret
endp