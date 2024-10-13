proc StrToInt uses ebx edi,\
     pointer

        mov esi, [pointer]

        xor eax, eax
 @@:
        cmp byte[esi], '/'
        je @F
        mov bl, byte[esi]
        sub ebx, '0'
        imul eax,eax, 10
        add eax, ebx
        inc esi
        dec ecx
        jmp @B

@@:
        dec eax
    ret
endp

proc StrToFloat  pointer

        locals
            number dd 0.0
            precision dd 0
            sign db 0
            ten dd 10.0

        endl

        mov esi, [pointer]
        xor eax, eax

        cmp byte[esi], '-'
        jne @F
        mov [sign], 1
        xor eax, eax
        inc esi
        dec ecx

@@:
        xor ebx, ebx
        cmp byte[esi], '.'
        je @F
        mov bl, byte[esi]
        sub ebx, '0'
        imul eax, eax, 10
        add eax, ebx
        inc esi
        dec ecx
        jmp @B

@@:
        add eax, ebx

@@:
        inc esi
        dec ecx
        xor ebx, ebx
        cmp byte[esi], ' '
        je @F
        cmp byte[esi], 10
        je @F
        mov bl, byte[esi]
        sub ebx, '0'
        imul eax, eax, 10
        add eax, ebx
        inc [precision]
        jmp @B

@@:
        mov [number], eax
        mov eax, [precision]
        fild [number]
@@:
        cmp eax, 0
        je @F
        fdiv [ten]
        dec eax
        jmp @B
@@:
        cmp [sign], 1
        jne @F
        fchs
@@:
        fstp [number]

        mov eax, [number]

    ret
endp

proc Time.Get

    invoke GetSystemTime, systemTime 

    mov eax, [systemTime + SYSTEM_TIME.wMinute]
    ret
endp


