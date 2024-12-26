proc Camera.Move

    ret
endp

proc Camera.CalculatePosition uses esi edi, target, result, distance, pitch, yaw
    locals
        radPitch dd ?
        radYaw dd ?
        x dd ?
        y dd ?
        z dd ?
        toRadian dd 180.0
    endl

    fldpi
    fdiv [toRadian]
    fmul [pitch]
    fstp [radPitch]

    fldpi
    fdiv [toRadian]
    fmul [yaw]
    fstp [radYaw]

    fld [radPitch]
    fcos
    fld [radYaw]
    fsin
    fmulp
    fmul [distance]
    fstp [x]

    fld [radPitch]
    fsin
    fmul [distance]
    fstp [y]

    fld [radPitch]
    fcos
    fld [radYaw]
    fcos
    fmulp
    fmul [distance]
    fstp [z]

    mov esi, [target]
    mov edi, [result]

    fld dword[esi]
    fadd [x]
    fstp dword[edi]

    fld dword[esi + 4]
    fadd [y]
    fstp dword[edi + 4]

    fld dword[esi + 8]
    fadd [z]
    fstp dword[edi + 8]
    ret
endp