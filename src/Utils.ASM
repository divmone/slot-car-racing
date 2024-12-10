proc Float.AddValue uses ebx, value,  term 
    mov ebx, [value]
    fld dword [ebx]
    fadd [term] 
    fstp dword[ebx]
    ret
endp

proc Float.SubValue uses ebx, value, term 
    mov ebx, [value]
    fld dword [ebx]
    fsub [term] 
    fstp dword[ebx]
    ret
endp

proc StrToInt uses ebx edi,\
     pointer

        mov esi, [pointer]

        xor eax, eax
 @@:
        cmp byte[esi], '/'
        je @F
        mov bl, byte[esi]
        sub ebx, '0'
        xor edx, edx
        push ecx
        mov ecx, 10
        mul ecx
        pop ecx
        add eax, ebx
        inc esi
        dec ecx
        jmp @B

@@:
        dec eax
    ret
endp

proc StrToFloat, pointer
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
        push ecx
        xor edx, edx
        mov ecx, 10
        mul ecx
        pop ecx
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
        xor edx, edx
        push ecx
        mov ecx, 10
        mul ecx
        pop ecx
        add eax, ebx
        inc [precision]
        cmp [precision], 9
        ;jg .precisionOF
        jmp @B

.precisionOF:
        inc esi
        dec ecx
        xor ebx, ebx
        cmp byte[esi], ' '
        je @F
        cmp byte[esi], 10
        je @F
        jmp .precisionOF
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

proc IntToStr uses edi esi, \
                value

    locals
        isNegative       db 0
        resString        dd 0
        numberLength     dd 0
    endl

    stdcall GetNumberLength, [value]
    mov [numberLength], eax
    inc eax               

    cmp [value], 0
    jg @f                 
    mov [isNegative], 1   
    neg [value]           
    inc eax               
@@:
    malloc eax
    mov [resString], eax

    cmp [value], 0
    jne @f
    mov esi, [resString]
    mov byte[esi], '0'    
    mov byte[esi + 1], 0 
    mov eax, esi
    ret
@@:
    mov ecx, 10
    mov eax, [value]
.loop_convert:
    xor edx, edx         
    div ecx             
    add edx, '0'        
    push edx            
    cmp eax, 0
    jg .loop_convert

    mov esi, [resString]
    mov ecx, 0

    cmp [isNegative], 1
    jne .loop_pop         

    mov byte[esi], '-'    
    inc esi               

.loop_pop:
    pop eax
    mov byte [esi + ecx], al 
    inc ecx
    cmp ecx, [numberLength]
    jne .loop_pop

    mov byte [esi + ecx], 0 
    mov eax, [resString]
    ret
endp

proc IntToStr2 uses edi esi, \
                value

    locals
        isNegative       db 0
        resString        dd 0
        numberLength     dd 0
    endl

    stdcall GetNumberLength, [value]
    mov [numberLength], eax
        
    malloc eax
    mov [resString], eax

    cmp [value], 0
    jne @f
    mov esi, [resString]
    mov byte[esi], '0'    
    mov eax, esi
    ret
@@:
    mov ecx, 10
    mov eax, [value]
.loop_convert:
    xor edx, edx         
    div ecx             
    add edx, '0'        
    push edx            
    cmp eax, 0
    jg .loop_convert

    mov esi, [resString]
    mov ecx, 0
 
.loop_pop:
    pop eax
    mov byte [esi + ecx], al 
    inc ecx
    cmp ecx, [numberLength]
    jne .loop_pop

    mov eax, [resString]
    ret
endp

proc GetNumberLength uses edx,\
                        value

    locals
        length dd 0
    endl

    cmp [value], 0
    jne @f
    mov [length], 1
    jmp @done
@@:
    cmp [value], 0
    jg @f
    neg [value]
    inc [length]

@@:
    mov eax, [value]
    mov ecx, 10

@@loop:
    xor edx, edx
    div ecx
    inc [length]
    cmp eax, 0
    jne @@loop

@done:
    mov eax, [length]
    ret
endp  

proc GetStringLength uses esi,\
                string

    xor ecx, ecx
    mov esi, [string]

.loop:
    cmp byte[esi], 0
    je @f
    inc esi
    inc ecx
    jmp .loop
@@: 
    mov eax, ecx
    ret
endp

proc Time.Get

    invoke GetSystemTime, systemTime 

    mov eax, [systemTime + SYSTEM_TIME.wMinute]
    ret
endp

proc FloatToStr uses esi, value, precision
    locals
        intValue dd ?
        intString dd ?
        intStringL dd ?
        afterPointString dd ?
        afterPointStringL dd ?
        afterPointValue dd ?
        ten dd 10.0
        resultString dd ?
        resultStringL dd ?
    endl
    ;int3
    fld [value]
    fistp [intValue]

    stdcall IntToStr2, [intValue]
    mov [intString], eax

    stdcall GetNumberLength, [intValue]
    mov [intStringL], eax

    fld [value]
    fild [intValue]
    fsubp
    fstp [afterPointValue]

    mov ecx, [precision] 
    fld1
 .lp:
    fmul [ten]
    loop .lp
    fmul [afterPointValue]
    fistp [afterPointValue] 

    stdcall IntToStr, [afterPointValue] 
    mov [afterPointString], eax

    stdcall GetNumberLength, [afterPointValue]
    mov [afterPointStringL], eax

    mov eax, [intStringL]
    add eax, [afterPointStringL]
    inc eax
    mov [resultStringL], eax

    malloc eax
    mov [resultString], eax
    mov ecx, [intString]
    memcpy eax, ecx, [intStringL]

    mov esi, [resultString] 
    add esi, [intStringL]
    mov byte[esi], '.'
    inc esi
    mov ecx, esi
    mov eax, [afterPointString]
    memcpy ecx, eax, [afterPointStringL]

    mov eax, [resultString]
    mov ecx, [resultStringL]
    ret
endp

proc	GetRandomNumber	minValue, maxValue
	push		ebx ecx edx
	mov		eax, [seed]
	or		eax, eax
	jnz		@2
@1:
	invoke		GetTickCount 
	or		eax, eax
	jz		@1
@2:
	xor		edx, edx
	mov		ebx, 127773
	div		ebx
	push		eax 
	mov		eax, 16807 
	mul		edx 
	pop		edx 
	push		eax 
	mov		eax, 2836 
	mul		edx 
	pop		edx 
	sub		edx, eax 
	mov		eax, edx 
	mov		[seed], edx
	xor		edx, edx
	mov		ebx, [maxValue]
	sub		ebx, [minValue]
	inc		ebx
	div		ebx
	mov		eax, edx
	add		eax, [minValue]
	pop		edx ecx ebx
    ret
endp