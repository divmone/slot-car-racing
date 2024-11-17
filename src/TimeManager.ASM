proc TimeManager.GetFPS
    locals 
        FPS dd 0.0
        startTime dd 0.0
        lastTime dd 0.0
        currentFPS dd 0.0

    endl

    invoke GetTickCount
    mov [currentTime], eax

    sub eax, [lastTime]

    mov eax, [currentTime]
    mov [lastTime], eax
    


    ret
endp

proc TimeManager.GetTime
    locals
        temp dd 1000.0
    endl

    invoke GetTickCount

    cvtsi2ss xmm0, eax
    movss xmm1, [temp]
    divss xmm0, xmm1
    movd eax, xmm0

    ret
endp

proc TimeManager.UpdateFPS
    locals
        currentTime dd 0.0
        one dd 0.0
    endl

    stdcall TimeManager.GetTime
    mov [currentTime], eax
    inc [frames]

    fld [currentTime]
    fsub [lastTime]
    fld [one]
    fcomip st0, st1
    ja @f
    fidivr [frames]
    fistp [FPS]

    stdcall IntToStr, [FPS]
    stdcall Log, eax, 6
    stdcall Log, nMessage, nMessage.size
    
    mov [frames], 0
    mov eax, [currentTime]
    mov [lastTime], eax
@@:
    fstp st0
    ret
endp