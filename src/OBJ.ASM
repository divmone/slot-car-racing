proc OBJ.ParseVertices uses edi esi,\
    buffer, length, verticesCount

        locals
            resultVertices dd 0
        endl

        xor edx, edx
        mov ecx, 12
        mov eax, [verticesCount]
        mul ecx
        malloc  eax
        mov     [resultVertices], eax

        mov esi, [buffer]
        mov ecx, [length]
        mov edi, [resultVertices]
.cycle:
        cmp byte[esi], 'v'
        jne .skipLine

        cmp byte [esi + 1], ' '
        jne .skipLine

        add esi, 2
        sub ecx, 2
        stdcall StrToFloat, esi
        mov [edi], eax
        add esi, 1
        dec ecx
        stdcall StrToFloat, esi
        mov [edi + 4], eax

        add esi, 1
        dec ecx
        stdcall StrToFloat, esi
        mov [edi + 8], eax

        add edi, 12
        add esi, 1
        dec ecx
        loop .cycle

.skipLine:

        cmp byte [esi], 10
        je @F
        cmp byte [esi], 0
        je @F
         dec ecx
         jz .end
        inc esi
        jmp .skipLine

@@:
        inc esi
        loop .cycle

.end:

       mov eax, [resultVertices]
    ret
endp


proc OBJ.ParseIndices uses ebx edi esi ,\
    buffer, length, indicesCount

        locals
            resultIndices dd 0
            iCount        dd 0
        endl

        xor edx, edx
        mov ecx, 3 * 4
        mov eax, [indicesCount]
        mul ecx

        malloc eax  ; eax
        mov     [resultIndices], eax

        xor edx, edx
        mov ecx, 3
        mov eax, [indicesCount]
        mul ecx
        mov [iCount], eax

        mov esi, [buffer]
        mov ecx, [length]
        mov edi, [resultIndices]
.cycle:
        cmp byte[esi], 'f'
        jne .skipLine

        cmp byte [esi + 1], ' '
        jne .skipLine


        add esi, 2
        dec ecx
        dec ecx
        stdcall StrToInt, esi
        mov [edi], eax

        dec[iCount]

        stdcall SkipToSpace, esi

        inc esi
        dec ecx


        stdcall StrToInt, esi

        mov [edi +  4], eax

        dec[iCount]


        stdcall SkipToSpace, esi

        inc esi
        dec ecx

        stdcall StrToInt, esi
        mov [edi + 8], eax
        dec[iCount]
        add edi, 12

       jmp .l1

.skipLine:

        cmp byte [esi], 10
        je @F
        cmp byte [esi], 0
        je @F
        dec ecx
        jz .end
        inc esi
        jmp .skipLine
@@:
        inc esi
.l1:
        cmp [iCount], 0
        je .end
        loop .cycle
.end:
       mov eax, [resultIndices]
    ret
endp

proc SkipToSpace  pointer

        mov esi, [pointer]
.cycle:
        cmp byte[esi], ' '
        je @F
        inc esi
        dec ecx
        jmp .cycle

@@:
        ret
endp

proc OBJ.CountObj uses esi ebx,\
    buffer, length, verticesCount, indicesCount, textCoordCount

    locals
        vCount dd 0
        iCount dd 0
        tCount dd 0
    endl
        mov esi, [buffer]
        mov ecx, [length]

.countCycle:
        cmp byte[esi], 'v'
        jne .l1
        cmp byte[esi + 1], ' '
        jne @F
        inc [vCount]
        jmp .newLine

@@:
        cmp byte[esi + 1], 't'
        jne .newLine
        cmp byte[esi + 2], ' '
        jne .newLine
        inc [tCount]
.l1:
        cmp byte[esi], 'f'
        jne .newLine
        cmp byte[esi + 1], ' '
        jne .newLine
        inc [iCount]
        jmp .newLine

@@:

.newLine:

        cmp byte [esi], 10
        je @F
        cmp byte[esi], 0
        je .endl
        inc esi
        dec ecx
        jmp .newLine
@@:
        inc esi
        loop .countCycle
.endl:
        mov ebx, [verticesCount] 
        mov eax, [vCount]       
        mov [ebx], eax 

        mov ebx, [indicesCount] 
        mov eax, [iCount]       
        mov [ebx], eax 

        mov ebx, [textCoordCount] 
        mov eax, [tCount]       
        mov [ebx], eax 
    ret
endp

proc OBJ.ParseTextCoord uses edi esi,\
    buffer, length, textCoordCount
          locals
            resultVertices dd 0
            temp       dd 0
            ten dd 100.0
        endl

        xor edx, edx
        mov ecx, 8
        mov eax, [textCoordCount]
        mul ecx
        malloc  eax
        mov     [resultVertices], eax

        mov esi, [buffer]
        mov ecx, [length]
        mov edi, [resultVertices]
.cycle:
        cmp byte[esi], 'v'
        jne .skipLine

        cmp byte [esi + 1], 't'
        jne .skipLine

        add esi, 2
        sub ecx, 2
        stdcall StrToFloat, esi
        mov [temp], eax
        fld [temp]
        fmul [ten]
        fstp [temp]
        mov eax, [temp]
        mov [edi], eax
        add esi, 1
        dec ecx
        stdcall StrToFloat, esi
        mov [temp], eax
        fld [temp]
        fmul [ten]
        fstp [temp]
        mov eax, [temp]
        mov [edi + 4], eax
        add esi, 1
        dec ecx
        add edi, 8
  
        loop .cycle

.skipLine:

        cmp byte [esi], 10
        je @F
        cmp byte [esi], 0
        je @F
         dec ecx
         jz .end
        inc esi
        jmp .skipLine

@@:
        inc esi
        loop .cycle

.end:

        mov eax, [resultVertices]
        ret
endp

proc SkipToSlash pointer
        mov esi, [pointer]
.cycle:
        cmp byte[esi], '/'
        je @F
        inc esi
        dec ecx
        jmp .cycle

@@:
        ret
endp

proc OBJ.ParseTextCoordI uses ebx edi esi ,\
    buffer, length, indicesCount

        locals
            resultIndices dd 0
            iCount        dd 0
        endl

        xor edx, edx
        mov ecx, 3 * 4
        mov eax, [indicesCount]
        mul ecx

        malloc eax 
        mov     [resultIndices], eax

        xor edx, edx
        mov ecx, 3
        mov eax, [indicesCount]
        mul ecx
        mov [iCount], eax

        mov esi, [buffer]
        mov ecx, [length]
        mov edi, [resultIndices]
.cycle:
        cmp byte[esi], 'f'
        jne .skipLine

        cmp byte [esi + 1], ' '
        jne .skipLine

        
        add esi, 2
        sub ecx, 2
        
        stdcall SkipToSlash, esi
        inc esi
        dec ecx

        stdcall StrToInt, esi
        mov [edi], eax
        dec[iCount]

        stdcall SkipToSpace, esi
        stdcall SkipToSlash, esi
        inc esi
        dec ecx

        stdcall StrToInt, esi
        mov [edi +  4], eax
        dec[iCount]

        stdcall SkipToSpace, esi
        stdcall SkipToSlash, esi
        inc esi
        dec ecx

        stdcall StrToInt, esi
        mov [edi + 8], eax
        dec[iCount]

        add edi, 12
        jmp .l1
.skipLine:
        cmp byte [esi], 10
        je @F
        cmp byte [esi], 0
        je @F
        dec ecx
        jz .end
        inc esi
        jmp .skipLine
@@:
        inc esi
.l1:
        cmp [iCount], 0
        je .end
        loop .cycle
.end:
        mov eax, [resultIndices]
        ret
endp

